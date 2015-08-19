//
//  TodayViewController.swift
//  TCPal
//
//  Created by Wren on 8/4/15.
//  Copyright © 2015 Janardan Yri. All rights reserved.
//

import UIKit

class TodayViewController: UITableViewController {


	init() {
		super.init(nibName: nil, bundle: nil)

		self.tabBarItem = UITabBarItem(title: "Announcements", image: nil, selectedImage: nil)
		// The above doesn't filter into the navigation controller...
		self.title = "Announcements"
	}

	required init?(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Model

	var firstAppearance = true

	var announcements = [Announcement]() {
		didSet {
			self.tableView.reloadData()
		}
	}

	// MARK: - View Lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()

		self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")

		self.refreshControl = UIRefreshControl()
		self.refreshControl!.addTarget(self, action: "refresh", forControlEvents: .ValueChanged)
	}

	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)

		if self.firstAppearance {
			self.firstAppearance = false
			self.refreshControl!.beginRefreshing()
			self.refresh()
		}
	}

	// MARK: - UITableViewDataSource

	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}

	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.announcements.count
	}

	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let announcement = self.announcements[indexPath.row]

		let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)

		cell.textLabel!.text = announcement.title

		return cell
	}

	// MARK: - UITableViewDelegate

	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		let announcement = self.announcements[indexPath.row]

		let announcementVC = AnnouncementViewController(announcement: announcement)

		self.navigationController!.pushViewController(announcementVC, animated: true)
	}

	// MARK: - Actions

	func refresh() {
		self.dynamicType.getAnnouncements { (announcements, error) -> Void in
			self.refreshControl!.endRefreshing()
			if let announcements = announcements {
				self.announcements = announcements
			} else {
				let alert = UIAlertController(title: "Rut roh", message: "Couldn't get announcements for some reason.", preferredStyle: .Alert)
				alert.addAction(UIAlertAction(title: "That's too bad", style: .Default, handler: nil))
				self.presentViewController(alert, animated: true, completion: nil)
			}
		}
	}

	// MARK: - Networking

	static func getAnnouncements(completion: ([Announcement]?, NSError?) -> Void) {
		// FIXME: provide proper errors in place of completion(nil, nil)

		let session = NSURLSession.sharedSession()
		let task = session.dataTaskWithURL(NSURL(string: "http://tc-internal-dev.herokuapp.com/api/announcements")!) { (data, response, error) -> Void in
			NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
				guard error == nil else {
					completion(nil, error!)
					return
				}

				guard let data = data else {
					completion(nil, nil)
					return
				}

				let JSONObject : AnyObject!
				do {
					JSONObject = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(rawValue:0))
				} catch {
					completion(nil, nil)
					return
				}

				guard let announcementDicts = JSONObject as? [[String : AnyObject]] else {
					completion(nil, nil)
					return
				}

				var announcements = [Announcement]()

				for dict in announcementDicts {
					guard let title = dict["title"] as? String, body = dict["body"] as? String else {
						// If there's _any_ unexpectedly formed data, bail out
						completion(nil, nil)
						return
					}

					let announcement = Announcement(title: title, body: body)
					announcements.append(announcement)
				}

				completion(announcements, nil)

			}
		}

		task.resume()
	}

}
