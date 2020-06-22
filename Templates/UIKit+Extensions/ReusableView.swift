//
//  ReusableView.swift
//  Templates
//
//  Created by simonnickel on 22.06.20.
//  Copyright © 2020 simonnickel. All rights reserved.
//

import Foundation
import UIKit

protocol ReusableView: class {
	static var defaultReuseIdentifier: String { get }
}

extension ReusableView where Self: UIView {
	static var defaultReuseIdentifier: String {
		return NSStringFromClass(self)
	}
}

extension UITableViewCell: ReusableView {}

extension UITableView {
	func dequeueReusableCell<T: ReusableView>(_ class: T.Type, for indexPath: IndexPath) -> T {
		return self.dequeueReusableCell(withIdentifier: T.defaultReuseIdentifier, for: indexPath) as! T
	}

	func register(_ type: ReusableView.Type) {
		self.register(type.self, forCellReuseIdentifier: type.defaultReuseIdentifier)
	}

	func registerHeaderFooterView(_ type: ReusableView.Type) {
		self.register(type.self, forHeaderFooterViewReuseIdentifier: type.defaultReuseIdentifier)
	}
}
