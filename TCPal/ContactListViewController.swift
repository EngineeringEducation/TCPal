//
//  ContactListViewController.swift
//  TCPal
//
//  Created by Wren on 8/4/15.
//  Copyright © 2015 Janardan Yri. All rights reserved.
//

import ContactsUI
import UIKit

class ContactListViewController: UIViewController {

	init() {
		super.init(nibName: nil, bundle: nil)

		self.tabBarItem = UITabBarItem(tabBarSystemItem: UITabBarSystemItem.Contacts, tag: 0)
		self.navigationItem.title = NSLocalizedString("contactList.title", value: "you have many friends", comment: "witticism about friendness")
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

		let button = UIButton(frame: CGRect(x: 20, y: 200, width: 200, height: 50))
		button.setTitle("try this", forState: .Normal)
		button.setTitleColor(UIColor.purpleColor(), forState: .Normal)
		button.addTarget(self, action: "didTapButton", forControlEvents: .TouchUpInside)
		self.view.addSubview(button)
	}

	func didTapButton() {
		let testContact = CNMutableContact()
		testContact.givenName = "Liz"
		testContact.familyName = "Howard"
		testContact.emailAddresses = [CNLabeledValue(label: "email", value: "liz@tradecrafted.com")]

		let contactVC = CNContactViewController(forUnknownContact: testContact)
		self.navigationController!.pushViewController(contactVC, animated: true)
	}
}
