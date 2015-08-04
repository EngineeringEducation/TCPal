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
		self.persons = persons

		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Model
	let persons : [Person]

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

		self.throwUpNewPerson()
	}

	// MARK: - Happenin' Stuff

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
