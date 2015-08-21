//
//  AnnouncementViewController.swift
//  TCPal
//
//  Created by Wren on 8/19/15.
//  Copyright © 2015 Janardan Yri. All rights reserved.
//

import SnapKit
import UIKit

class AnnouncementViewController: UIViewController {

	init(announcement: Announcement) {
		self.announcement = announcement

		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Model

	let announcement : Announcement

	// MARK: - View

	lazy var textView = UITextView()

	override func loadView() {
		self.view = UIView()

		self.view.addSubview(self.textView)

		self.textView.snp_updateConstraints { (make) -> Void in
			make.edges.equalTo(0)
		}
	}

	// MARK: - View Lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()

		self.textView.editable = false
		self.textView.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
		self.textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)

		self.textView.text = "\(self.announcement.title)\n\n\(self.announcement.body)"
	}
}
