//
//  AppealCell.swift
//  TCPal
//
//  Created by Wren on 8/20/15.
//  Copyright © 2015 Janardan Yri. All rights reserved.
//

import UIKit

class AppealCell: UITableViewCell {

	// Currently this file only exists to force the style we want. Heh.
	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: .Subtitle, reuseIdentifier: reuseIdentifier)
	}

	required init?(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
}
