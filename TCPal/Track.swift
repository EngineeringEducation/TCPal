//
//  Track.swift
//  TCPal
//
//  Created by Wren on 8/6/15.
//  Copyright © 2015 Janardan Yri. All rights reserved.
//

import Foundation

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

	func description() -> String {
		switch (self) {
		case .SalesBD:
			return "Sales & Business Development"
		case .GrowthMarketing:
			return "Growth Marketing"
		case .ProductDesign:
			return "Product Design"
		case .Engineering:
			return "Engineering"
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
