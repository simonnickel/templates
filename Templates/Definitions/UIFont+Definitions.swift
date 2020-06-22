//
//  UIFont+Definitions.swift
//  Templates
//
//  Created by simonnickel on 22.06.20.
//  Copyright © 2020 simonnickel. All rights reserved.
//

import Foundation
import UIKit

extension UIFont {

	enum Font {
		case text, subtext
	}

	static func dynamic(_ font: Font) -> UIFont {
		switch font {
			
			case .text:
				return UIFont.preferredFont(forTextStyle: .body)

			case .subtext:
				return UIFontMetrics.default.scaledFont(for: UIFont.systemFont(ofSize: 12, weight: .light))
		}
	}
}
