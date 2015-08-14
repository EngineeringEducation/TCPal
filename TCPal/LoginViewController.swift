//
//  LoginViewController.swift
//  TCPal
//
//  Created by Wren on 7/30/15.
//  Copyright © 2015 Janardan Yri. All rights reserved.
//

import SnapKit
import UIKit

// TODO: Having this be the sign in delegate "works" right now because the login is the root view controller; ultimately we'll want to move it somewhere more appropriate to improve the app launch experience
class LoginViewController: UIViewController, GIDSignInDelegate {

	init(completion:(Void -> Void)) {
		self.completion = completion

		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	let completion : (Void -> Void)

	lazy var signInButton = GIDSignInButton()

	lazy var establishingStatusSpinnerView : UIActivityIndicatorView = {
		let spinner = UIActivityIndicatorView()
		spinner.autoresizingMask = [.FlexibleHeight, .FlexibleWidth] // LOVE this new Swift 2 syntax
		return spinner
  }()

	override func loadView() {
		self.view = {
			let view = UIView()
			view.backgroundColor = UIColor.whiteColor()
			return view
			}()

		self.view.addSubview(establishingStatusSpinnerView)

		// This button will be revealed (and the spinner hidden) if auto-signon fails.
		self.view.addSubview(self.signInButton)
		self.signInButton.hidden = true

		self.signInButton.snp_updateConstraints { (make) -> Void in
			make.width.equalTo(200)
			make.height.equalTo(100)
			make.centerX.equalTo(0)
			make.top.equalTo(100)
		}
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		let gSignIn = GIDSignIn.sharedInstance()
		gSignIn.allowsSignInWithWebView = false // Apparently this is necessary because we aren't using uidelegate, even though we don't care.
		gSignIn.delegate = self
		gSignIn.signInSilently()
	}

	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)

		if (GIDSignIn.sharedInstance().currentUser != nil) {
			// This is intended to handle explicit logins.
			self.completion()
		}
	}

	// MARK: - GIDSignInDelegate

	func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!,
		withError error: NSError!) {
			if (error == nil) {
				// Perform any operations on signed in user here.
				let userId = user.userID                  // For client-side use only!
				let idToken = user.authentication.idToken // Safe to send to the server
				let name = user.profile.name
				let email = user.profile.email
				// ...

				print("Did sign in, userID:\(userId) idToken:\(idToken) accesstoken:\(user.authentication.accessToken) refreshtoken:\(user.authentication.refreshToken) name: \(name) email:\(email)")

				if (self.presentedViewController == nil) {
					// This is intended to handle implicit logins.
					self.completion()
				}

			} else {
				print("\(error.localizedDescription)")
				self.signInButton.hidden = false
				self.establishingStatusSpinnerView.hidden = true
			}
	}

	func signIn(signIn: GIDSignIn!, didDisconnectWithUser user:GIDGoogleUser!, withError error: NSError!) {
		// Perform any operations when the user disconnects from app here.
		// ...
		print("Did disconnect, user: \(user) error: \(error)")
	}
}
