//
//  AppealViewController.swift
//  TCPal
//
//  Created by Wren on 8/20/15.
//  Copyright © 2015 Janardan Yri. All rights reserved.
//

import UIKit

class AppealViewController: UIViewController {

	init(appeal: Appeal) {
		self.appeal = appeal

		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Model

	let appeal: Appeal

	// MARK: - View

	// TODO: lol
	let textView = UITextView()
	override func loadView() {
		self.view = self.textView
	}

	// MARK: - View Lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()

		self.textView.editable = false
		self.textView.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
		self.textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)

		self.textView.text = "\(self.appeal.authorFullName) to \(self.appeal.track.description())\n\n\(self.appeal.need)"
	}
}
