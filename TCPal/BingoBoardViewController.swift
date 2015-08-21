//
//  BingoBoardViewController.swift
//  TCPal
//
//  Created by Wren on 8/6/15.
//  Copyright © 2015 Janardan Yri. All rights reserved.
//

import UIKit

class BingoBoardViewController: UIViewController {

	init() {
		super.init(nibName: nil, bundle: nil)

		self.tabBarItem = UITabBarItem(title: "Design Bingo", image: UIImage(named: "first"), selectedImage: nil)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Model


	// MARK: - View

	lazy var bingoBoardView = BingoBoardView()

	var currentSquareView: BingoSquareView?

	// MARK: - View Lifecycle

	override func loadView() {
		self.view = self.bingoBoardView
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		for squareControlRow in self.bingoBoardView.squareControls {
			for squareControl in squareControlRow {
				squareControl.addTarget(self, action: "didTapSquare:", forControlEvents: .TouchUpInside)
			}
		}

		self.bingoBoardView.maskingView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "didTapToExit:"))
	}

	// MARK: - Transitions

	// TODO: Use formal transitioning API

	func didTapSquare(square: BingoSquareControl) {

		let squareView = BingoSquareView()
		squareView.bounds = CGRect(
			x: 0,
			y: 0,
			width: 4 * square.bounds.width,
			height: 4 * square.bounds.height
		)
		squareView.center = square.center
		squareView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.25, 0.25)
		squareView.titleLabel.alpha = 0

		self.view.addSubview(squareView)
		self.currentSquareView = squareView

		UIView.animateWithDuration(0.25,
			delay: 0,
			usingSpringWithDamping: 0.8,
			initialSpringVelocity: 0,
			options: UIViewAnimationOptions.BeginFromCurrentState,
			animations: { () -> Void in
				squareView.center = CGPoint(
					x: squareView.superview!.bounds.width / 2,
					y: squareView.superview!.bounds.height / 2
				)

				squareView.transform = CGAffineTransformIdentity

				squareView.titleLabel.alpha = 1

				self.bingoBoardView.maskingView.alpha = 0.2
			},
			completion: nil
		)
	}

	func didTapToExit(maskingView: UIView) {
		UIView.animateWithDuration(0.2, animations: { () -> Void in
			self.currentSquareView?.alpha = 0
			self.bingoBoardView.maskingView.alpha = 0
			}, completion:{ (finished) -> Void in
				self.currentSquareView?.removeFromSuperview()
				self.currentSquareView = nil
		})
	}
}
