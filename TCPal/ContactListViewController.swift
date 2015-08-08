//
//  ContactListViewController.swift
//  TCPal
//
//  Created by Wren on 8/4/15.
//  Copyright © 2015 Janardan Yri. All rights reserved.
//

import ContactsUI
import UIKit

class ContactListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

	init() {
		super.init(nibName: nil, bundle: nil)

		self.tabBarItem = UITabBarItem(tabBarSystemItem: UITabBarSystemItem.Contacts, tag: 0)

		let titleOptions = [
			NSLocalizedString("contactList.title0", value: "you have many friends", comment: "witticism about friendness"),
			NSLocalizedString("contactList.title1", value: "so many opportunities to say hi", comment: "remark on the multiplicities of communications"),
			NSLocalizedString("contactList.title2", value: "we think you are so interesting", comment: "affirmation of interestingness"),
			NSLocalizedString("contactList.title3", value: "have you met someone neat today", comment: "gentle prod to make friends"),
			NSLocalizedString("contactList.title4", value: "send someone a nice thought", comment: "suggestion to reach out")
		]

		self.navigationItem.title = titleOptions[Int(arc4random_uniform(UInt32(titleOptions.count)))]
		self.navigationItem.backBarButtonItem = UIBarButtonItem(
			title: NSLocalizedString("contactList.backText", value: "friends", comment: "text for the back button from contacts to the contact list"),
			style: .Plain,
			target: nil,
			action: nil
		)

		self.loadPersons()
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Model

	// Outer elements per section, inner elements per row
	var contacts : [[Person]]!

	// MARK: - View

	lazy var contactListView = ContactListView()
	
	// MARK: - View Lifecycle

	override func loadView() {
		self.view = self.contactListView
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		self.contactListView.tableView.registerClass(ContactCell.self, forCellReuseIdentifier: "contactCell")
		self.contactListView.tableView.delegate = self
		self.contactListView.tableView.dataSource = self
	}

	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)

		if let selectedIndexPath = self.contactListView.tableView.indexPathForSelectedRow {
			self.contactListView.tableView.deselectRowAtIndexPath(selectedIndexPath, animated: animated)
		}
	}

	// MARK: - Data

	func cohortCount() -> Int {
		return self.contacts.count
	}

	func personsForSection(section: Int) -> [Person] {
		return self.contacts[section]
	}

	func personForIndexPath(indexPath: NSIndexPath) -> Person {
		return self.personsForSection(indexPath.section)[indexPath.row]
	}

	// MARK: - UITableViewDataSource

	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return self.cohortCount()
	}

	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.personsForSection(section).count
	}

	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let person = self.personForIndexPath(indexPath)

		let cell = tableView.dequeueReusableCellWithIdentifier("contactCell", forIndexPath: indexPath) as! ContactCell

		cell.nameLabel.text = "\(person.givenName) \(person.familyName)"
		cell.trackLabel.text = person.track.abbreviation()
		cell.trackLabel.textColor = person.track.color()

		return cell
	}

	func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
		return (1...self.cohortCount()).map({ String($0) }).reverse()
	}

	func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return String(self.cohortCount() - section)
	}

	// MARK: - UITableViewDelegate

	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		if #available(iOS 9.0, *) {
			let person = self.personForIndexPath(indexPath)
		    let contact = person.equivalentCNContact
			let contactVC = CNContactViewController(forUnknownContact: contact)
			self.navigationController!.pushViewController(contactVC, animated: true)
		} else {
		    let alert = UIAlertController(title: "Nuh-uh!", message: "Contact sheets currently only available in bleeding-edge iOS9 betas.", preferredStyle: .Alert)
			alert.addAction(UIAlertAction(title: "Aw man!", style: .Cancel, handler: nil))
			self.presentViewController(alert, animated: true, completion: nil)
				tableView.deselectRowAtIndexPath(indexPath, animated: true)
		}
	}

	// MARK: - Unsorted

	func loadPersons() {
		// TODO: Get real data

		let tc18JSONURL = NSBundle.mainBundle().URLForResource("tc-18", withExtension: "json")!
		let tc17JSONURL = NSBundle.mainBundle().URLForResource("tc-17", withExtension: "json")!
		do {
			let tc18JSON = try String(contentsOfURL: tc18JSONURL)
			let tc17JSON = try String(contentsOfURL: tc17JSONURL)
			let tc18 = try Person.arrayFromJSON(tc18JSON, cohort: 18)
			let tc17 = try Person.arrayFromJSON(tc17JSON, cohort: 17)

			// TODO: Is on-demand photo loading plausible with CNContact?
			Person.loadFaces(persons:tc18, completion: { (success) -> Void in /* !! */ })
			Person.loadFaces(persons:tc17, completion: { (success) -> Void in /* !! */ })

			var contacts = [[Person]](count: 18, repeatedValue: [Person]())
			contacts[0] = tc18
			contacts[1] = tc17

			self.contacts = contacts

		} catch let error {
			print("oh no, contact json error: \(error)")
		}
		
	}
}
