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
		let sampleJSONURL = NSBundle.mainBundle().URLForResource("facegame-persons-sample", withExtension: "json")!
		do {
			let sampleJSON = try String(contentsOfURL: sampleJSONURL)
			let persons = try self.personsFromJSON(sampleJSON)
			self.loadFaces(persons: persons, completion: { (success) -> Void in
				if success {
					completion(persons: persons, error: nil)
				} else {
					completion(persons: nil, error: nil)
				}
			})

		} catch let error { 
			completion(persons: nil, error: error)
		}

	}

	static func loadFaces(persons persons: [Person], completion: (success: Bool) -> Void) {

		var extantCount = persons.count
		var overallSuccess = true

		let incrementalCompletion : (success:Bool) -> Void = { success in
			overallSuccess = overallSuccess && success

			if (--extantCount == 0) {
				completion(success: overallSuccess)
			}
		}

		for person in persons {
			if let _ = person.face {
				incrementalCompletion(success: true)
			} else {
				person.getFace(incrementalCompletion)
			}
		}
	}

	enum PersonJSONError : ErrorType {
		case MalformedInput
	}

	static func personsFromJSON(JSON: String) throws -> [Person] {

		guard let JSONData = JSON.dataUsingEncoding(NSUTF8StringEncoding) else {
			throw PersonJSONError.MalformedInput
		}

		let JSONObject = try NSJSONSerialization.JSONObjectWithData(JSONData, options: NSJSONReadingOptions(rawValue:0))

		guard let personDicts = JSONObject as? [[String : String]] else {
			throw PersonJSONError.MalformedInput
		}

		var persons = [Person]()

		for personDict in personDicts {
			guard let name = personDict["name"], faceString = personDict["face"], faceURL = NSURL(string: faceString) else {
				throw PersonJSONError.MalformedInput
			}

			let person = Person(
				name: name,
				faceURL: faceURL
			)
			
			persons.append(person)
		}

		return persons
	}

}
