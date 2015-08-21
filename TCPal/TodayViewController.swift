//
//  TodayViewController.swift
//  TCPal
//
//  Created by Wren on 8/4/15.
//  Copyright © 2015 Janardan Yri. All rights reserved.
//

import UIKit

// TODO: Use actual coherent networking abstractions - it's becoming about that time

class TodayViewController: UITableViewController {


	init() {
		super.init(nibName: nil, bundle: nil)

		self.tabBarItem = UITabBarItem(title: "Today", image: UIImage(named: "first"), selectedImage: nil)
		self.navigationItem.title = "Today"
	}

	required init?(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Model

	var firstAppearance = true

	var announcements = [Announcement]() {
		didSet {
			self.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: .Automatic)
		}
	}

	var appeals = [Appeal]() {
		didSet {
			self.tableView.reloadSections(NSIndexSet(index: 1), withRowAnimation: .Automatic)
		}
	}

	// MARK: - View Lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()

		self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "announcementCell")
		self.tableView.registerClass(AppealCell.self, forCellReuseIdentifier: "appealCell")

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
		return 2
	}

	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		switch (section) {
		case 0:
			return self.announcements.count
		case 1:
			return self.appeals.count
		default:
			assert(false)
			return 0
		}
	}

	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		switch (indexPath.section) {
			case 0:
				let announcement = self.announcements[indexPath.row]

				let cell = tableView.dequeueReusableCellWithIdentifier("announcementCell", forIndexPath: indexPath)

				cell.accessoryType = .DisclosureIndicator

				cell.textLabel!.text = announcement.title
				
				return cell
			case 1:
				let appeal = self.appeals[indexPath.row]

				let cell = tableView.dequeueReusableCellWithIdentifier("appealCell", forIndexPath: indexPath)

				cell.textLabel!.text = appeal.need
				cell.detailTextLabel!.attributedText = appeal.subtitleAttributedText
				cell.detailTextLabel!.alpha = 0.7

				return cell
			default:
				assert(false)
				return UITableViewCell() // hurr
		}
	}

	override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		switch (section) {
		case 0:
			return "Announcements"
		case 1:
			return "Halp Requasts"
		default:
			assert(false)
			return nil
		}
	}

	// MARK: - UITableViewDelegate

	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		switch (indexPath.section) {
		case 0:
			let announcement = self.announcements[indexPath.row]

			let announcementVC = AnnouncementViewController(announcement: announcement)

			self.navigationController!.pushViewController(announcementVC, animated: true)
		case 1:
			// TODO: Implement AppealViewController
			tableView.deselectRowAtIndexPath(indexPath, animated: true)
		default:
			assert(false)
			return
		}
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
		self.dynamicType.getAppeals { (appeals, error) -> Void in
			self.refreshControl!.endRefreshing()
			if let appeals = appeals {
				self.appeals = appeals
			} else {
				let alert = UIAlertController(title: "Rut roh", message: "Couldn't get appeals for some reason.", preferredStyle: .Alert)
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


	static func getAppeals(completion: ([Appeal]?, NSError?) -> Void) {
		// FIXME: provide proper errors in place of completion(nil, nil)

		let session = NSURLSession.sharedSession()
		let task = session.dataTaskWithURL(NSURL(string: "http://tc-internal-dev.herokuapp.com/api/appeals")!) { (data, response, error) -> Void in
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

				guard let appealDicts = JSONObject as? [[String : AnyObject]] else {
					completion(nil, nil)
					return
				}

				var appeals = [Appeal]()

				for dict in appealDicts {
					guard let appeal = Appeal(JSONObject: dict) else {
						// If there's _any_ unexpectedly formed data, bail out
						completion(nil, nil)
						return
					}

					appeals.append(appeal)
				}

				completion(appeals, nil)
				
			}
		}
		
		task.resume()
	}

}
