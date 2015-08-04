//
//  FaceGameViewController.swift
//  TCPal
//
//  Created by Wren on 8/4/15.
//  Copyright © 2015 Janardan Yri. All rights reserved.
//

import QuartzCore
import UIKit

class FaceGameViewController: UIViewController {

  // MARK: - Model

  var persons = [
    Person(name: "Bill Murray", faceURL: NSURL(string: "https://upload.wikimedia.org/wikipedia/commons/0/0a/Bill_Murray%2C_Monuments_Men_premiere.jpg")!),
    Person(name: "Stephen Hawking", faceURL: NSURL(string: "https://upload.wikimedia.org/wikipedia/commons/e/eb/Stephen_Hawking.StarChild.jpg")!)
  ]

  // MARK: - "View Model"-ish

  var currentPerson : Person! {
    didSet {
      self.faceView.image = self.currentPerson.face!
    }
  }

  var nameChoices : [String]! {
    didSet {
      for i in (0..<self.buttons.count) {
        self.buttons[i].setTitle(self.nameChoices[i], forState: .Normal)
      }
    }
  }

  // MARK: - Views

  lazy var faceView : UIImageView = {
    let imageView = UIImageView(frame: CGRect(x: 100, y: 100, width: 200, height: 200))
    imageView.clipsToBounds = true
    imageView.contentMode = .ScaleAspectFill
    imageView.layer.cornerRadius = 100
    return imageView
  }()

  lazy var buttons : [UIButton] = {
    return (0...1).map { index in
      let button = UIButton(frame: CGRect(x: 50, y: 350 + 50 * index, width: 200, height: 50))
      button.setTitleColor(UIColor.blackColor(), forState:.Normal)
      return button
    }
  }()

  lazy var confirmationLabel : UILabel = {
    let label = UILabel(frame: CGRect(x: 100, y: 30, width: 300, height: 50))
    label.textColor = UIColor.blackColor()
    return label
  }()

  // MARK: - View Lifecycle

  override func loadView() {
    self.view = {
      let view = UIView()
      view.backgroundColor = UIColor.whiteColor()
      return view
    }()

    self.view.addSubview(self.faceView)

    for button in self.buttons {
      button.addTarget(self, action: "didTapNameButton:", forControlEvents: .TouchUpInside)
      self.view.addSubview(button)
    }

    self.view.addSubview(self.confirmationLabel)
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    self.loadFaces()
  }

  // MARK: - Happenin' Stuff

  func loadFaces() {

    var extantCount = self.persons.count
    var failed = false

    for person in self.persons {

      person.getFace({ (success) -> Void in
        if (!success) {
          failed = true
          print("failed :(")
        }

        if (--extantCount == 0) {
          if (failed == false) {
            self.throwUpNewPerson()
          } else {
            // FIXME: Do something when we've completed with partial success
          }
        }
      })
    }
  }

  func throwUpNewPerson() {
    let randomIndex = Int(arc4random_uniform(UInt32(self.persons.count)))
    self.currentPerson = self.persons[randomIndex]

    // FIXME: randomize these
    self.nameChoices = self.persons.map { person in
      return person.name
    }
  }

  func didTapNameButton(sender : UIButton) {
    let buttonIndex = self.buttons.indexOf(sender)!
    let selectedName = self.nameChoices[buttonIndex]
    self.confirmationLabel.text = (selectedName == self.currentPerson.name) ? "Y" : "N"
    self.throwUpNewPerson()
  }
}
