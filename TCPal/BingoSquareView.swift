//
//  BingoSquareView.swift
//  TCPal
//
//  Created by Wren on 8/7/15.
//  Copyright © 2015 Janardan Yri. All rights reserved.
//

import UIKit

class BingoSquareView: UIView {

	init(title: String = "Persuasive Title", icon: UIImage = UIImage(named: "star")! ) {
		super.init(frame: CGRectZero)

		self.backgroundColor = UIColor.whiteColor()
		self.layer.borderColor = UIColor.blackColor().CGColor
		self.layer.borderWidth = 2

		self.iconView.image = icon
		self.addSubview(self.iconView)

		self.titleLabel.text = title
		self.addSubview(self.titleLabel)

		self.setNeedsUpdateConstraints()
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}


	// MARK: - Views

	lazy var titleLabel : UILabel = {
		let label = UILabel()
		label.font = UIFont.preferredFontForTextStyle(UIFontTextStyleTitle2)
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

		self.titleLabel.snp_makeConstraints { (make) -> Void in
			make.centerX.equalTo(0)
			make.leading.equalTo(20)
			make.top.equalTo(20)
		}

		super.updateConstraints()
	}

}
