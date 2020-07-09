//
//  UIButton+Action.swift
//  Templates
//
//  Created by Simon Nickel on 09.07.20.
//  Copyright © 2020 simonnickel. All rights reserved.
//

import Foundation
import UIKit

typealias Action = () -> Void


// MARK: - UIButton

class ActionUIButton: UIButton {
	
	open class func systemButton(with image: UIImage, action actionClosure: @escaping Action) -> ActionUIButton {
		let button = ActionUIButton.systemButton(with: image, target: self, action: #selector(touchInside))
		button.actionTouchUp = actionClosure
		return button
	}


    // MARK: - Closure Action

    private var actionTouchUp: (Action)? = nil

    @objc private func touchInside() -> Void {
        self.actionTouchUp?()
    }

}


// MARK: - UIBarButtonItem

class ActionUIBarButtonItem: UIBarButtonItem {

    convenience init(title: String?, style: UIBarButtonItem.Style, action actionClosure: @escaping Action) {
        self.init(title: title, style: style, target: nil, action: nil)

        self.actionTouchUp = actionClosure
        target = self
        action = #selector(touchInside)
    }

    convenience init(image: UIImage?, style: UIBarButtonItem.Style, action actionClosure: @escaping Action) {
        self.init(image: image, style: style, target: nil, action: nil)

        self.actionTouchUp = actionClosure
        target = self
        action = #selector(touchInside)
    }

    convenience init(barButtonSystemItem systemItem: UIBarButtonItem.SystemItem, action actionClosure: @escaping Action) {
        self.init(barButtonSystemItem: systemItem, target: nil, action: nil)

        self.actionTouchUp = actionClosure
        target = self
        action = #selector(touchInside)
    }


    // MARK: - Closure Action

    private var actionTouchUp: (Action)? = nil

    @objc private func touchInside() -> Void {
        self.actionTouchUp?()
    }

}
