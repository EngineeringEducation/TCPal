//
//  Person.swift
//  TCPal
//
//  Created by Wren on 8/4/15.
//  Copyright © 2015 Janardan Yri. All rights reserved.
//

import ContactsUI

enum Track {
	case SalesBD
	case GrowthMarketing
	case ProductDesign
	case Engineering

	init?(name : String) {
		switch (name) {
		case "BD / Sales":
			self = .SalesBD
		case "Sales & BD":
			self = .SalesBD
		case "Growth":
			self = .GrowthMarketing
		case "Product Design":
			self = .ProductDesign
		case "Engineering":
			self = .Engineering
		default:
			return nil
		}
	}

	func abbreviation() -> String {
		switch (self) {
		case .SalesBD:
			return "SBD"
		case .GrowthMarketing:
			return "GM"
		case .ProductDesign:
			return "PD"
		case .Engineering:
			return "E"
		}
	}

	func color() -> UIColor {
		switch (self) {
		case .SalesBD:
			return UIColor(red: 1, green: 0, blue: 0, alpha: 1)
		case .GrowthMarketing:
			return UIColor(red: 0.1, green: 0.8, blue: 0.1, alpha: 1)
		case .ProductDesign:
			return UIColor(red: 0.6, green: 0, blue: 0.6, alpha: 1)
		case .Engineering:
			return UIColor(red: 0.1, green: 0, blue: 1, alpha: 1)
		}
	}
}

class Person {
	let givenName : String
	let familyName : String

	var fullName : String {
		get {
			return "\(self.givenName) \(self.familyName)"
		}
	}

	let tradecraftEmail : String
	let personalEmail : String

	let track : Track
	let cohort : Int

	var face : UIImage?
	let faceURL : NSURL?

	init(givenName: String, familyName: String, faceURL: NSURL?, tradecraftEmail: String, personalEmail: String, track: Track, cohort: Int) {
		self.givenName = givenName
		self.familyName = familyName

		self.tradecraftEmail = tradecraftEmail
		self.personalEmail = personalEmail
		self.track = track
		self.cohort = cohort

		self.faceURL = faceURL
	}
}

extension Person {
	var equivalentCNContact : CNContact {
		get {
			let contact = CNMutableContact()

			contact.givenName = self.givenName ?? ""
			contact.familyName = self.familyName ?? ""

			contact.emailAddresses = [
				CNLabeledValue(label: "Tradecraft", value: self.tradecraftEmail),
				CNLabeledValue(label: "Personal", value: self.personalEmail)
			]

			return contact
		}
	}
}

extension Person { // Networking helpers
	func getFace(completion: (success: Bool) -> Void) {
		guard let faceURL = self.faceURL else {
			completion(success: true)
			return
		}

		let session = NSURLSession.sharedSession()
		let task = session.dataTaskWithURL(faceURL) { (imageData, response, error) -> Void in
			NSOperationQueue.mainQueue().addOperationWithBlock {
				if let error = error {
					print("Network error: \(error)")
					completion(success:false)
				} else if let imageData = imageData, image = UIImage(data: imageData) {
					self.face = image
					completion(success:true)
				} else {
					completion(success:false)
				}
			}
		}

		task.resume()
	}

	enum JSONError : ErrorType {
		case MalformedInput
	}

	static func arrayFromJSON(JSON: String) throws -> [Person] {

		guard let JSONData = JSON.dataUsingEncoding(NSUTF8StringEncoding) else {
			throw JSONError.MalformedInput
		}

		let JSONObject = try NSJSONSerialization.JSONObjectWithData(JSONData, options: NSJSONReadingOptions(rawValue:0))

		guard let personDicts = JSONObject as? [[String : String]] else {
			throw JSONError.MalformedInput
		}

		var persons = [Person]()

		for personDict in personDicts {
			guard let givenName = personDict["firstName"],
				familyName = personDict["lastName"],
				tradecraftEmail = personDict["emailTradecraft"],
				personalEmail = personDict["emailPersonal"],
				trackName = personDict["track"],
				track = Track(name: trackName)

				else {
				throw JSONError.MalformedInput
			}

			let faceString = personDict["photoLink"]
			let faceURL = (faceString != nil) ? NSURL(string: faceString!) : nil

			let person = Person(
				givenName: givenName,
				familyName: familyName,
				faceURL: faceURL,
				tradecraftEmail: tradecraftEmail,
				personalEmail: personalEmail,
				track: track,
				cohort: 18
			)

			persons.append(person)
		}

		return persons
	}
}
