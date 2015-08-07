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
		super.init(nibName: nil, bundle: nil)

		self.tabBarItem = UITabBarItem(title: "Face Game", image: nil, selectedImage: nil)
	}

	required init?(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Model
	var persons : [Person]!

	// MARK: - Status Label/Buttons

	@IBOutlet weak var retryButton: UIButton!
	@IBOutlet weak var loadingLabel: UILabel!
	@IBOutlet weak var playButton: UIButton!

	@IBOutlet var statusViews: [UIView]!

	func showStatusView(selectedView : UIView) {
		for statusView in self.statusViews {
			statusView.hidden = (statusView != selectedView)
		}
	}

	// MARK: - View Lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()

		self.loadAllMaterials()
	}

	// MARK: - Actions

	@IBAction func didTapRetry(sender: UIButton) {
		self.loadAllMaterials()
	}

	@IBAction func didTapPlay(sender: UIButton) {
		let gameVC = FaceGameViewController(persons: self.persons)
		self.presentViewController(gameVC, animated: true, completion: nil)
	}

	// MARK: - Data Marshaling

	func loadAllMaterials() {
		self.showStatusView(self.loadingLabel)

		self.dynamicType.loadAllMaterials { (persons, error) -> Void in
			if let _ = error {
				// TODO: error messages?
				let alert = UIAlertController(title: "A porblem!", message: nil, preferredStyle: .Alert)
				alert.addAction(UIAlertAction(title: "Oh no!", style: .Cancel, handler: nil))
				self.presentViewController(alert, animated: true, completion: nil)
				self.showStatusView(self.retryButton)
			} else if let persons = persons {
				self.persons = persons
				self.showStatusView(self.playButton)
			} else {
				self.showStatusView(self.retryButton)
			}
		}
	}

	static func loadAllMaterials(completion: (persons:[Person]?, error:ErrorType?) -> Void) {
		let sampleJSONURL = NSBundle.mainBundle().URLForResource("tc-18", withExtension: "json")!
		do {
			let sampleJSON = try String(contentsOfURL: sampleJSONURL)
			let persons = try Person.arrayFromJSON(sampleJSON, cohort:18)
			Person.loadFaces(persons: persons, completion: { (success) -> Void in
				// FIXME: Right now images are sourced from wherever, some links aren't even to images as such, so I guess partial failure is OK
				let personsWithFaces = persons.filter({ (person) -> Bool in
					person.face != nil
				})

				if (personsWithFaces.count >= 4) {
					completion(persons: personsWithFaces, error: nil)
				} else {
					completion(persons: nil, error: nil)
				}
			})

		} catch let error { 
			completion(persons: nil, error: error)
		}

	}
}
