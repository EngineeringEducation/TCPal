//
//  ContactListView.swift
//  TCPal
//
//  Created by Wren on 8/5/15.
//  Copyright © 2015 Janardan Yri. All rights reserved.
//

import UIKit

class ContactListView: UIView {

	init() {
		super.init(frame: CGRectZero)

		self.backgroundColor = UIColor.whiteColor()

		self.addSubview(self.tableView)

		self.setNeedsUpdateConstraints()
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Views

	lazy var tableView : UITableView = {
		UITableView()
	}()

	// MARK: - Constraints

	override func updateConstraints() {

		self.tableView.snp_updateConstraints { (make) -> Void in
			make.leading.equalTo(0)
			make.trailing.equalTo(0)
			make.top.equalTo(0)
			make.bottom.equalTo(0)
		}
		
		super.updateConstraints()
	}
}
