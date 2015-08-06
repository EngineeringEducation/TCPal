//
//  ContactCell.swift
//  TCPal
//
//  Created by Wren on 8/5/15.
//  Copyright © 2015 Janardan Yri. All rights reserved.
//

import QuartzCore
import UIKit

class ContactCell: UITableViewCell {

	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)

		self.contentView.addSubview(self.nameLabel)
		self.contentView.addSubview(self.cohortLabel)
		self.contentView.addSubview(self.trackLabel)

		self.setNeedsUpdateConstraints()
	}

	required init?(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Views

	lazy var nameLabel : UILabel = {
		let label = UILabel()
		return label
	}()

	lazy var cohortLabel : UILabel = {
		let label = UILabel()
		return label
	}()

	lazy var trackLabel : UILabel = {
		let label = UILabel()
		label.font = UIFont.boldSystemFontOfSize(UIFont.systemFontSize())
		label.textAlignment = .Center
		return label
	}()

	// MARK: - Constraints

	override func updateConstraints() {
		self.nameLabel.snp_updateConstraints { (make) -> Void in
			make.leading.equalTo(20)
			make.centerY.equalTo(0)
		}

		self.cohortLabel.snp_updateConstraints { (make) -> Void in
			make.leading.equalTo(self.nameLabel.snp_trailing).offset(10)
			make.width.equalTo(30)
			make.centerY.equalTo(0)
		}

		self.trackLabel.snp_updateConstraints { (make) -> Void in
			make.leading.equalTo(self.cohortLabel.snp_trailing).offset(10)
			make.width.equalTo(30)
			make.centerY.equalTo(0)
			make.trailing.equalTo(-20)
		}



		super.updateConstraints()
	}

}
