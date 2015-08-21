//
//  FaceGameIntroViewController.swift
//  TCPal
//
//  Created by Wren on 8/4/15.
//  Copyright © 2015 Janardan Yri. All rights reserved.
//

import UIKit

class FaceGameIntroViewController: UIViewController {

	init() {
		super.init(nibName: "FaceGameIntroViewController", bundle: nil)

		self.tabBarItem = UITabBarItem(title: "Face Game", image: UIImage(named: "first"), selectedImage: nil)
	}

	required init?(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}

	// MARK: - View

	@IBOutlet weak var tc18button: UIButton!
	@IBOutlet weak var tc19button: UIButton!

	// MARK: - Actions

	@IBAction func didTapPlay(sender: UIButton) {
		let cohort : Int = {
			switch (sender) {
			case self.tc18button:
				return 18
			case self.tc19button:
				return 19
			default:
				assert(false)
				return 0
			}
		}()

		self.loadAndPlay(cohort)
	}

	// MARK: - Data Marshaling

	// Note: if we go back to loading materials from the internet, check the history for this file and pull in async code again :)

	func loadAndPlay(cohort: Int) {

		let (maybePersons, maybeError) = FaceGameIntroViewController.loadMaterials(cohort)

		guard let persons = maybePersons where maybeError == nil else {
			// TODO: error messages?
			let alert = UIAlertController(title: "A porblem!", message: nil, preferredStyle: .Alert)
			alert.addAction(UIAlertAction(title: "Oh no!", style: .Cancel, handler: nil))
			self.presentViewController(alert, animated: true, completion: nil)
			return
		}

		let gameVC = FaceGameViewController(persons: persons)
		self.presentViewController(gameVC, animated: true, completion: nil)
	}

	static func loadMaterials(cohort: Int) -> (persons:[Person]?, error:ErrorType?) {

		let sampleJSONURL = NSBundle.mainBundle().URLForResource("tc-\(cohort)", withExtension: "json")!
		do {
			let sampleJSON = try String(contentsOfURL: sampleJSONURL)
			let persons = try Person.arrayFromJSON(sampleJSON, cohort:cohort)
			let personsWithFaces = persons.filter { $0.face != nil }
			return (personsWithFaces, nil)
		} catch let error { 
			return (nil, error)
		}

	}
}
