//
//  FaceGameViewController.swift
//  TCPal
//
//  Created by Wren on 8/4/15.
//  Copyright © 2015 Janardan Yri. All rights reserved.
//

import UIKit

class FaceGameViewController: UIViewController {

  override func loadView() {
    self.view = {
      let view = UIView()
      view.backgroundColor = UIColor.whiteColor()
      return view
    }()

    self.view.addSubview({
      let label = UILabel(frame: CGRect(x: 100, y: 100, width: 200, height: 100))
      label.text = "hi this is the game"
      return label
    }())
  }
}
