//
//  ContactListViewController.swift
//  TCPal
//
//  Created by Wren on 8/4/15.
//  Copyright © 2015 Janardan Yri. All rights reserved.
//

import UIKit

class ContactListViewController: UIViewController {

	init() {
		super.init(nibName: nil, bundle: nil)

		self.tabBarItem = UITabBarItem(tabBarSystemItem: UITabBarSystemItem.Contacts, tag: 0)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - View Lifecycle

	override func loadView() {
		self.view = UIView()
		self.view.backgroundColor = UIColor.whiteColor()

		let infoLabel = UILabel(frame: CGRectMake(20, 100, 300, 50))
		infoLabel.text = "you have many friends"
		self.view.addSubview(infoLabel)
	}
}
