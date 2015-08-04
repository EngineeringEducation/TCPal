//
//  AppDelegate.swift
//  TCPal
//
//  Created by Wren on 7/28/15.
//  Copyright © 2015 Janardan Yri. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    // Override point for customization after application launch.

    // Google SignIn pasted initialization goop
    var configureError: NSError?
    GGLContext.sharedInstance().configureWithError(&configureError)
    assert(configureError == nil, "Error configuring Google services: \(configureError)")

    // Standard programmatic interface setup
    self.window = UIWindow()
    self.window!.rootViewController = LoginViewController() {
      self.window!.rootViewController = FaceGameViewController()
    }
    self.window!.makeKeyAndVisible()

    return true
  }

  func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
    return GIDSignIn.sharedInstance().handleURL(url,
      sourceApplication: sourceApplication,
      annotation: annotation
    )
  }
}
