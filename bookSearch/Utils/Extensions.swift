//
//  Extensions.swift
//  bookSearch
//
//  Created by 김지현 on 2022/11/05.
//

import UIKit

extension UITextField {
	func addLeftPadding() {
		let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: self.frame.height))
		self.leftView = paddingView
		self.leftViewMode = ViewMode.always
	}
}
