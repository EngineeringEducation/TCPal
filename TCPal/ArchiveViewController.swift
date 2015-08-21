//
//  ArchiveViewController.swift
//  TCPal
//
//  Created by Wren on 8/13/15.
//  Copyright © 2015 Janardan Yri. All rights reserved.
//

import UIKit

class ArchiveViewController: UITableViewController {

	init() {
		super.init(nibName: nil, bundle: nil)

		self.tabBarItem = UITabBarItem(title: "Archive", image: UIImage(named: "first"), selectedImage: nil)
		self.title = "Archive"

		self.navigationItem.title = "Learn more about..."
	}

	required init?(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Model

	let entries = [ "Mentors", "Projects" ]

	// MARK: - View Lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()

		self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
	}

	// MARK: - UITableViewDataSource

	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.entries.count
	}

	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)

		cell.textLabel!.text = self.entries[indexPath.row]

		return cell
	}

	// MARK: - UITableViewDelegate

	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		// TODO: Handle selection
		self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
	}

}
