//
//  UIImage+Definitions.swift
//  Templates
//
//  Created by Simon Nickel on 20.07.20.
//  Copyright © 2020 simonnickel. All rights reserved.
//

import Foundation
import UIKit

enum Icon: String {
    case add
	case create

	/// Override for multiple semantic icons using the same SF Symbol.
	var systemName: String {
		switch self {
//			case .add, .create: return "plus.circle.fill"
			default: return self.rawValue
		}
	}
	
	/// Override for semantic Icon using different SF Symbol based on config.
	func systemName(for config: IconConfig?) -> String {
		switch self {
			case .add: return config == .contextMenu ? "plus.circle" : "plus.circle.fill"
			default: return self.systemName
		}
	}
}

enum IconConfig {
    case list, navigationItem, tableCellAccessory, contextMenu

    var symbolConfig: UIImage.SymbolConfiguration? {
        switch self {
//			case .list: return UIImage.SymbolConfiguration(textStyle: .body, scale: .large)
//			case .navigationItem: return UIImage.SymbolConfiguration(textStyle: .title2, scale: .large)
//			case .tableCellAccessory: return UIImage.SymbolConfiguration(font: UIFontMetrics.default.scaledFont(for: UIFont.systemFont(ofSize: 14, weight: .semibold)))
//			case .contextMenu: return nil
			default: return nil
        }
    }
}

extension UIImage {
    static func icon(_ icon: Icon, config: IconConfig? = nil) -> UIImage? {
        return UIImage(systemName: icon.systemName(for: config), withConfiguration: config?.symbolConfig)
    }
}
