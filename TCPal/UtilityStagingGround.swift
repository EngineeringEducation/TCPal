//
//  UtilityStagingGround.swift
//  TCPal
//
//  Created by Wren on 8/4/15.
//  Copyright © 2015 Janardan Yri. All rights reserved.
//

// This is intended as a lightweight place for putting convenience categories and such before they've grown to the point where they're worth organizing properly.

import Foundation

// Below adapted from http://stackoverflow.com/questions/24026510/how-do-i-shuffle-an-array-in-swift

extension CollectionType where Index == Int {
	/// Return a copy of `self` with its elements shuffled
	func wk_shuffled() -> [Generator.Element] {
		var list = Array(self)
		list.wk_shuffle()
		return list
	}
}

extension MutableCollectionType where Index == Int {
	/// Shuffle the elements of `self` in-place.
	mutating func wk_shuffle() {
		// empty and single-element collections don't shuffle
		if count < 2 { return }

		for i in 0..<count - 1 {
			let j = Int(arc4random_uniform(UInt32(count - i))) + i
			swap(&self[i], &self[j])
		}
	}
}