//
//  TodayViewController.swift
//  TCPal
//
//  Created by Wren on 8/4/15.
//  Copyright © 2015 Janardan Yri. All rights reserved.
//

import UIKit

class TodayViewController: UIViewController {

	init() {
		super.init(nibName: nil, bundle: nil)

		self.tabBarItem = UITabBarItem(title: "Today", image: nil, selectedImage: nil)
	}

	required init?(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}

	// MARK: - View Lifecycle

	override func loadView() {
		self.view = UIView()
		self.view.backgroundColor = UIColor.whiteColor()

		let infoLabel = UILabel(frame: CGRectMake(20, 50, 300, 50))
		infoLabel.text = "today at tc... lots is happening"
		self.view.addSubview(infoLabel)
	}

}
