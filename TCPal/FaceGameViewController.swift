//
//  FaceGameViewController.swift
//  TCPal
//
//  Created by Wren on 8/4/15.
//  Copyright © 2015 Janardan Yri. All rights reserved.
//

import GameplayKit
import QuartzCore
import UIKit

class FaceGameViewController: UIViewController {

	init(persons: [Person]) {
		self.persons = GKRandomSource.sharedRandom().arrayByShufflingObjectsInArray(persons) as! [Person]

		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Model

	let persons : [Person] // This has been shuffled into the intended order of presentation.

	lazy var distinctNames : [String] = {
		Array(Set(self.persons.map { $0.fullName }))
	}()

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
	}

	// MARK: - Happenin' Stuff

	override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
		return .Portrait
	}

	func showNextPerson() {

		self.currentPersonIndex += 1

		var randomNames = Array((GKRandomSource.sharedRandom().arrayByShufflingObjectsInArray(self.distinctNames) as! [String])[0..<self.faceGameView.nameOptionCount])

		let selectedName = self.currentPerson.fullName

		// Ensure that the correct name makes it into the random array
		if !randomNames.contains(selectedName) {
			randomNames[Int(arc4random_uniform(4))] = selectedName
		}

		self.nameOptions = randomNames
	}

	func conclude() {
		let alert = UIAlertController(title: "oh my", message: "you got \(self.correctCount) out of \(self.persons.count)", preferredStyle: .Alert)
		alert.addAction(UIAlertAction(title: "oh wow!", style: .Default, handler: { (action) -> Void in
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

		self.faceGameView.confirmationLabel.text = (correct) ? "Y" : "N"

		if self.currentPersonIndex + 1 < self.persons.count {
			self.showNextPerson()
		} else {
			self.conclude()
		}
	}
}
