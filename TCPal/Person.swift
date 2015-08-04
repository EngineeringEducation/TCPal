//
//  Person.swift
//  TCPal
//
//  Created by Wren on 8/4/15.
//  Copyright © 2015 Janardan Yri. All rights reserved.
//

class Person {
	var face : UIImage?
	let faceURL : NSURL
	let name : String

	init(name: String, faceURL: NSURL) {
		self.faceURL = faceURL
		self.name = name
	}

	func getFace(completion: (success: Bool) -> Void) {
		let session = NSURLSession.sharedSession()
		let task = session.dataTaskWithURL(self.faceURL) { (imageData, response, error) -> Void in
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

}
