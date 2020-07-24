//
//  UIViewController+KeyboardAdjustable.swift
//  Templates
//
//  Created by Simon Nickel on 23.07.20.
//  Copyright © 2020 simonnickel. All rights reserved.
//

import Foundation
import UIKit
import Combine

/*
	Helps adjusting views when the keyboard opens.
	Not necessary for UITableViewController, it handles insets on its own.

	Usage for a UIViewControlelr:
		- Conform to protocol KeyboardAdjustable
		- Call setupAdjustingToKeyboard() in viewDidLoad()
*/

protocol KeyboardAdjustable where Self: UIViewController {
    var publisherKeyboardWillShow: AnyCancellable? { get set }
    var publisherKeyboardWillHide: AnyCancellable? { get set }

    func handleKeyboardUpdate(frameHeight: CGFloat?, animationDuration: TimeInterval)
}

extension KeyboardAdjustable {
    func setupAdjustingToKeyboard() {
        publisherKeyboardWillShow = NotificationCenter.default.publisher(for: UIControl.keyboardWillShowNotification, object: nil).sink(receiveValue: { [weak self] (notification) in
            guard let strongSelf = self,
				let keyboardValue = notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
				let animationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval
                else { return }

            let keyboardViewEndFrame = strongSelf.view.convert(keyboardValue.cgRectValue, from: strongSelf.view.window)
			strongSelf.handleKeyboardUpdate(frameHeight: keyboardViewEndFrame.height, animationDuration: animationDuration)
        })

        publisherKeyboardWillHide = NotificationCenter.default.publisher(for: UIControl.keyboardWillHideNotification, object: nil).sink(receiveValue: { [weak self] (notification) in
			guard let strongSelf = self,
				let animationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval
				else { return }
			
			strongSelf.handleKeyboardUpdate(frameHeight: nil, animationDuration: animationDuration)
        })
    }
}
