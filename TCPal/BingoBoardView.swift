//
//  BingoBoardView.swift
//  TCPal
//
//  Created by Wren on 8/6/15.
//  Copyright © 2015 Janardan Yri. All rights reserved.
//

//  TODO: Opportunity: factor out a generic TileView?

import UIKit

class BingoBoardView: UIView {

	init() {
		super.init(frame: CGRectZero)
		self.backgroundColor = UIColor.whiteColor()

		let infoLabel = UILabel(frame: CGRectMake(20, 50, 300, 50))
		infoLabel.text = "soon this will be design bingo, ok?"
		self.addSubview(infoLabel)

		for group in self.squareControls {
			for squareControl in group {
				self.addSubview(squareControl)
			}
		}

		self.addSubview(self.maskingView)

	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Views

	// [row][column]
	lazy var squareControls : [[BingoSquareControl]] = {
		return (0..<5).map { (row) -> [BingoSquareControl] in
			return (0..<5).map { (column) -> BingoSquareControl in
				return BingoSquareControl()
			}
		}
	}()

	lazy var maskingView : UIView = {
		let view = UIView()
		view.alpha = 0
		view.backgroundColor = UIColor.blackColor()
		return view
	}()

	// MARK: - Constraints

	override func updateConstraints() {

		let firstSquareControl = self.squareControls[0][0]

		firstSquareControl.snp_updateConstraints { (make) -> Void in
			make.top.greaterThanOrEqualTo(0) // This can supersede the latter in landscape
			make.leading.equalTo(0).priority(900)
			make.height.equalTo(firstSquareControl.snp_width)
		}

		let lastSquareControl = self.squareControls[4][4]

		lastSquareControl.snp_updateConstraints { (make) -> Void in
			make.trailing.equalTo(0)
			make.bottom.equalTo(-50) // TODO: Actually use bottom layout guide here :(
		}


		for row in 0..<5 {
			for column in 0..<5 {
				let squareControl = self.squareControls[row][column]

				squareControl.snp_updateConstraints { (make) -> Void in

					guard row > 0 || column > 0 else {
						return
					}

					make.width.equalTo(firstSquareControl.snp_width)
					make.height.equalTo(firstSquareControl.snp_height)

					if row == 0 {
						make.top.equalTo(self.squareControls[0][column-1].snp_bottom)
					} else {
						make.top.equalTo(self.squareControls[0][column].snp_top)
					}

					if column == 0 {
						make.leading.equalTo(self.squareControls[row-1][0].snp_trailing)
					} else {
						make.leading.equalTo(self.squareControls[row][0].snp_leading)
					}

				}
			}
		}

		self.maskingView.snp_updateConstraints { (make) -> Void in
			make.edges.equalTo(0)
		}

		super.updateConstraints()
	}

}
