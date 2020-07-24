//
//  UIColor+Definitions.swift
//  Templates
//
//  Created by simonnickel on 22.06.20.
//  Copyright © 2020 simonnickel. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {

	enum SemanticColor {
		case background, backgroundContent, backgroundContentSecondary
		case text, accent
	}

	static func dynamic(_ color: SemanticColor) -> UIColor {
		switch color {
			
			case .background: return .systemGroupedBackground

			case .backgroundContent: return .secondarySystemGroupedBackground

			case .backgroundContentSecondary: return .tertiarySystemGroupedBackground

			case .text: return .label

			case .accent: return UIColor { (traitCollection: UITraitCollection) -> UIColor in
				switch(traitCollection.userInterfaceStyle,
					   traitCollection.accessibilityContrast)
				{
					case (.dark, .high): return UIColor(red: 0, green: 0.8, blue: 0.6, alpha: 1.0)
					case (.dark, _):     return UIColor(red: 0, green: 0.8, blue: 0.6, alpha: 0.8)
					case (_, .high):     return UIColor(red: 0, green: 0.6, blue: 0.8, alpha: 1.0)
					default:             return UIColor(red: 0, green: 0.6, blue: 0.8, alpha: 0.8)
				}
			}

		}
	}

}
