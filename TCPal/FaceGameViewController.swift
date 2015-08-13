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

	init(persons: [Person]) {
		self.persons = persons.wk_shuffled()

		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Model

	let persons : [Person] // This has been shuffled into the intended order of presentation.

	var correctCount = 0

	var currentPersonIndex = -1 {
		didSet {
			self.faceGameView.faceView.image = self.currentPerson.face!
		}
	}

	var currentPerson : Person {
		get {
			return self.persons[self.currentPersonIndex]
		}
	}

	var nameOptions : [String]! {
		didSet {
			for i in (0..<self.faceGameView.nameOptionCount) {
				self.faceGameView.buttons[i].setTitle(self.nameOptions[i], forState: .Normal)
			}
		}
	}

	var startDate : NSDate!

	// MARK: - View

	lazy var faceGameView = FaceGameView(nameOptionCount: 4)

	// MARK: - View Lifecycle

	override func loadView() {
		self.view = self.faceGameView
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		for button in self.faceGameView.buttons {
			button.addTarget(self, action: "didTapNameButton:", forControlEvents: .TouchUpInside)
		}

		self.showNextPerson()
		self.startDate = NSDate()
	}

	// MARK: - Happenin' Stuff

	override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
		return .Portrait
	}

	func showNextPerson() {

		self.currentPersonIndex += 1

		let sameGenderedNames = self.persons.filter({ (person) -> Bool in
			return person.gender == self.currentPerson.gender
		}).map({ $0.fullName })

		var randomNames = Array(sameGenderedNames.wk_shuffled()[0..<self.faceGameView.nameOptionCount])

		let selectedName = self.currentPerson.fullName

		// Ensure that the correct name makes it into the random array
		if !randomNames.contains(selectedName) {
			randomNames[Int(arc4random_uniform(4))] = selectedName
		}

		self.nameOptions = randomNames
	}

	func conclude() {

		let (title, message, buttonText) : (String, String, String) = {
			if (self.correctCount == self.persons.count) {
				let completionSeconds = Int(-self.startDate.timeIntervalSinceNow)
				return (
					"good job!",
					"you knew everyone omg!\nyou took \(completionSeconds) seconds :)",
					"yay!!"
				)
			} else {
				return (
					"oh my",
					"you got \(self.correctCount) out of \(self.persons.count)",
					"oh wow!"
				)
			}
		}()
		
		let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
		alert.addAction(UIAlertAction(title: buttonText, style: .Default, handler: { (action) -> Void in
			// TODO: completion block / delegate for this view controller
			self.presentingViewController!.dismissViewControllerAnimated(true, completion: nil)
		}))

		self.presentViewController(alert, animated: true, completion: nil)
	}

	func didTapNameButton(sender : UIButton) {
		let buttonIndex = self.faceGameView.buttons.indexOf(sender)!
		let selectedName = self.nameOptions[buttonIndex]

		let correct = (selectedName == self.currentPerson.fullName)
		if (correct) {
			self.correctCount++
		}

		self.faceGameView.confirmationLabel.text = (correct) ? "you're right! :)" : "not so much :("
		self.faceGameView.confirmationLabel.alpha = 1
		UIView.animateWithDuration(1) { () -> Void in
			self.faceGameView.confirmationLabel.alpha = 0
		}


		if self.currentPersonIndex + 1 < self.persons.count {
			self.showNextPerson()
		} else {
			self.conclude()
		}
	}
}
