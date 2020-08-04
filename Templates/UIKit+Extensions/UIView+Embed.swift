//
//  UIView+Embed.swift
//  Templates
//
//  Created by simonnickel on 22.06.20.
//  Copyright © 2020 simonnickel. All rights reserved.
//

import Foundation
import UIKit

struct EmbedInsets {
	let top: CGFloat?
	let bottom: CGFloat?
	let leading: CGFloat?
	let trailing: CGFloat?

	init(top: CGFloat? = nil, bottom: CGFloat? = nil, leading: CGFloat? = nil, trailing: CGFloat? = nil) {
		self.top = top
		self.bottom = bottom
		self.leading = leading
		self.trailing = trailing
	}

	static let none: EmbedInsets = EmbedInsets(top: nil, bottom: nil, leading: nil, trailing: nil)
	static let zero: EmbedInsets = EmbedInsets(top: 0, bottom: 0, leading: 0, trailing: 0)
	static func all(_ spacing: CGFloat) -> EmbedInsets { EmbedInsets(top: spacing, bottom: spacing, leading: spacing, trailing: spacing) }
}

extension UIView {

	func embed(in container: UIView, using layoutGuide: UILayoutGuide? = nil, insets: EmbedInsets = .zero) {
		self.translatesAutoresizingMaskIntoConstraints = false
		container.addSubview(self)

		if let top = insets.top {
			self.topAnchor.constraint(equalTo: layoutGuide?.topAnchor ?? container.topAnchor, constant: top).isActive = true
		}
		if let bottom = insets.bottom {
			self.bottomAnchor.constraint(equalTo: layoutGuide?.bottomAnchor ?? container.bottomAnchor, constant: -bottom).isActive = true
		}
		if let leading = insets.leading {
			self.leadingAnchor.constraint(equalTo: layoutGuide?.leadingAnchor ?? container.leadingAnchor, constant: leading).isActive = true
		}
		if let trailing = insets.trailing {
			self.trailingAnchor.constraint(equalTo: layoutGuide?.trailingAnchor ?? container.trailingAnchor, constant: -trailing).isActive = true
		}
	}

}
