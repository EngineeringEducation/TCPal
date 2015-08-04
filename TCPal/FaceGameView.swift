//
//  FaceGameView.swift
//  TCPal
//
//  Created by Wren on 8/4/15.
//  Copyright © 2015 Janardan Yri. All rights reserved.
//

import SnapKit
import UIKit

class FaceGameView: UIView {

  init() {
    super.init(frame: CGRectZero)

    self.backgroundColor = UIColor.whiteColor()

    self.addSubview(self.faceView)
    self.addSubview(self.confirmationLabel)

    for button in self.buttons {
      self.addSubview(button)
    }
  }

  required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Views

  lazy var faceView : UIImageView = {
    let imageView = UIImageView()
    imageView.clipsToBounds = true
    imageView.contentMode = .ScaleAspectFill
    imageView.layer.cornerRadius = 100
    return imageView
    }()

  lazy var buttons : [UIButton] = {
    return (0...1).map { index in
      let button = UIButton()
      button.setTitleColor(UIColor.blackColor(), forState:.Normal)
      return button
    }
    }()

  lazy var confirmationLabel : UILabel = {
    let label = UILabel()
    label.textColor = UIColor.blackColor()
    return label
    }()

  override func updateConstraints() {
    self.faceView.snp_updateConstraints { (make) -> Void in
      make.centerX.equalTo(0)
      make.top.equalTo(50)
      make.height.equalTo(200)
      make.width.equalTo(200)
    }

    for i in 0..<self.buttons.count {
      self.buttons[i].snp_updateConstraints { (make) -> Void in
        if i == 0 {
          make.top.equalTo(self.faceView.snp_bottom).offset(50)
        } else {
          make.top.equalTo(self.buttons[i-1].snp_bottom).offset(20)
        }

        make.centerX.equalTo(0)
        make.leading.equalTo(20)
      }
    }

    super.updateConstraints()
  }

}
