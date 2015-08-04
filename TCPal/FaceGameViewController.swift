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
			self.faceGameView.faceView.image = self.currentPerson.face!
		}
	}

	var nameChoices : [String]! {
		didSet {
			for i in (0..<self.faceGameView.buttons.count) {
				self.faceGameView.buttons[i].setTitle(self.nameChoices[i], forState: .Normal)
			}
		}
	}

	// MARK: - View

	lazy var faceGameView = FaceGameView()

	// MARK: - View Lifecycle

	override func loadView() {
		self.view = self.faceGameView
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		for button in self.faceGameView.buttons {
			button.addTarget(self, action: "didTapNameButton:", forControlEvents: .TouchUpInside)
		}

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
		let buttonIndex = self.faceGameView.buttons.indexOf(sender)!
		let selectedName = self.nameChoices[buttonIndex]
		self.faceGameView.confirmationLabel.text = (selectedName == self.currentPerson.name) ? "Y" : "N"
		self.throwUpNewPerson()
	}
}
