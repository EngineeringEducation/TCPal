//
//  BingoSquareControl.swift
//  TCPal
//
//  Created by Wren on 8/6/15.
//  Copyright © 2015 Janardan Yri. All rights reserved.
//

import UIKit

class BingoSquareControl: UIControl {

	init(abbreviation: String = "!", icon: UIImage = UIImage(named: "star")! ) {
		super.init(frame: CGRectZero)

		self.layer.borderColor = UIColor.brownColor().CGColor
		self.layer.borderWidth = 1

		self.abbreviationLabel.text = abbreviation
		self.addSubview(self.abbreviationLabel)

		self.iconView.image = icon
		self.addSubview(self.iconView)

		self.setNeedsUpdateConstraints()
	}

	required init?(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}


	// MARK: - Views

	lazy var abbreviationLabel : UILabel = {
		let label = UILabel()
		label.font = UIFont.preferredFontForTextStyle(UIFontTextStyleCaption1)
		return label
	}()

	lazy var iconView : UIImageView = {
		let imageView = UIImageView()
		return imageView
	}()

	// MARK: - Constraints

	override func updateConstraints() {

		self.iconView.snp_makeConstraints { (make) -> Void in
			make.height.equalTo(self.snp_height).multipliedBy(0.6)
			make.width.equalTo(self.iconView.snp_height)
			make.centerX.equalTo(0)
			make.centerY.equalTo(0)
		}

		self.abbreviationLabel.snp_makeConstraints { (make) -> Void in
			make.centerX.equalTo(0)
			make.bottom.equalTo(-2)
		}



		super.updateConstraints()
	}
}
