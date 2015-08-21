//
//  Appeal.swift
//  TCPal
//
//  Created by Wren on 8/20/15.
//  Copyright © 2015 Janardan Yri. All rights reserved.
//

import UIKit

struct Appeal {
	let authorFullName : String
	let need : String
	let track : Track

	init?(JSONObject : [String:AnyObject]) {
		guard let author = JSONObject["author"] as? [String:AnyObject],
			authorFullName = author["displayName"] as? String,
			need = JSONObject["need"] as? String,
			trackToken = JSONObject["track"] as? String,
			track = Track(APIToken: trackToken) else {
				return nil
		}

		self.authorFullName = authorFullName
		self.need = need
		self.track = track
	}
}

extension Appeal {
	var subtitleAttributedText : NSAttributedString {
		get {
			let subtitleFontDescriptor = UIFontDescriptor.preferredFontDescriptorWithTextStyle(UIFontTextStyleCaption1)
			let subtitleFont = UIFont(descriptor: subtitleFontDescriptor, size: /*ignore*/ 0)
			let subtitleBoldFontDescriptor = subtitleFontDescriptor.fontDescriptorWithSymbolicTraits(.TraitBold)
			let subtitleBoldFont = UIFont(descriptor: subtitleBoldFontDescriptor, size: /*ignore*/ 0)

			let attributedAuthor = NSAttributedString(string: self.authorFullName, attributes: [NSFontAttributeName: subtitleBoldFont])
			let stitching = NSAttributedString(string: " to ", attributes: [NSFontAttributeName: subtitleFont])
			let attributedTrackDescription = NSAttributedString(string: self.track.description(), attributes: [NSFontAttributeName: subtitleFont, NSForegroundColorAttributeName: self.track.color()])

			return attributedAuthor + stitching + attributedTrackDescription
		}
	}
}