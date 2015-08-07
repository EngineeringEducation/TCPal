//
//  Person.swift
//  TCPal
//
//  Created by Wren on 8/4/15.
//  Copyright © 2015 Janardan Yri. All rights reserved.
//

import ContactsUI

class Person {
	let givenName : String
	let familyName : String

	var fullName : String {
		get {
			return "\(self.givenName) \(self.familyName)"
		}
	}

	var face : UIImage?
	let faceURL : NSURL?

	let tradecraftEmail : String
	let personalEmail : String

	let cell : String?

	let track : Track
	let cohort : Int

	let linkedIn : String?
	let twitter : String?

	let biography : String?

	init(givenName: String, familyName: String, faceURL: NSURL?, tradecraftEmail: String, personalEmail: String, cell: String?, track: Track, cohort: Int, linkedIn: String?, twitter: String?, biography : String?) {
		self.givenName = givenName
		self.familyName = familyName

		self.faceURL = faceURL

		self.tradecraftEmail = tradecraftEmail
		self.personalEmail = personalEmail

		self.cell = cell

		self.track = track
		self.cohort = cohort

		self.linkedIn = linkedIn
		self.twitter = twitter

		self.biography = biography
	}
}

extension Person {
	var equivalentCNContact : CNContact {
		get {
			let contact = CNMutableContact()

			contact.givenName = self.givenName ?? ""
			contact.familyName = self.familyName ?? ""

			if let face = self.face {
				contact.imageData = UIImageJPEGRepresentation(face, 1)
			}

			contact.emailAddresses = [
				CNLabeledValue(label: "Tradecraft Email", value: self.tradecraftEmail),
				CNLabeledValue(label: "Personal Email", value: self.personalEmail)
			]

			if let cell = self.cell {
				contact.phoneNumbers = [
					CNLabeledValue(label: "Cell", value: CNPhoneNumber(stringValue: cell))
				]
			}

			contact.departmentName = "TC\(self.cohort) \(self.track.description())"

			if let linkedIn = self.linkedIn {
				// TODO: This is hacky
				let username = linkedIn.componentsSeparatedByString("/").last!
				let value = CNLabeledValue(label: nil, value: CNSocialProfile(
					urlString: nil,
					username: username,
					userIdentifier: nil,
					service: CNSocialProfileServiceLinkedIn
					)
				)
				contact.socialProfiles.append(value)
			}

			if let twitter = self.twitter {
				let value = CNLabeledValue(label: nil, value: CNSocialProfile(
					urlString: nil,
					username: twitter,
					userIdentifier: nil,
					service: CNSocialProfileServiceTwitter
					)
				)

				contact.socialProfiles.append(value)
			}

			if let biography = self.biography {
				contact.note = biography
			}

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

	static func arrayFromJSON(JSON: String, cohort: Int) throws -> [Person] {

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

			let cell      = personDict["cell"]
			let linkedIn  = personDict["linkedin"]
			let twitter   = personDict["twitter"]
			let biography = personDict["characterBio"]

			let person = Person(
				givenName: givenName,
				familyName: familyName,
				faceURL: faceURL,
				tradecraftEmail: tradecraftEmail,
				personalEmail: personalEmail,
				cell: cell,
				track: track,
				cohort: cohort,
				linkedIn: linkedIn,
				twitter: twitter,
				biography: biography
			)

			persons.append(person)
		}

		return persons
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

}
