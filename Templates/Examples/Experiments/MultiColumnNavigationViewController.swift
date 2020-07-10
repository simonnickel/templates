//
//  MultiColumnNavigationViewController.swift
//  Templates
//
//  Created by Simon Nickel on 09.07.20.
//  Copyright © 2020 simonnickel. All rights reserved.
//

import Foundation
import UIKit

class MultiColumnNavigationViewController: UIViewController, ColumnNavigationDelegate {
	
	override func viewDidLoad() {
		view.backgroundColor = .white
		super.viewDidLoad()
		
		setupView()
		
		add(ColumnViewController())
	}
	
	
	// MARK: - Add / Remove
	
	func add(_ viewController: UIViewController) {
		let navigation = ColumnNavigationController(rootViewController: viewController)
		navigation.columnDelegate = self
        add(child: navigation)
    }
	
    private func add(child: UIViewController) {
        addChild(child)
		containerStack.addArrangedSubview(child.view)
        child.didMove(toParent: self)
    }

    func remove() {
        guard parent != nil else {
            return
        }

        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
	
	
	// MARK: - Setup View
	
	private lazy var containerStack: UIStackView = {
		let view = UIStackView()
		view.axis = .horizontal
		view.alignment = .fill
		view.distribution = .fillEqually
		
		return view
	}()
	
	private func setupView() {
		containerStack.embed(in: view)
	}
}

protocol ColumnNavigationDelegate: class {
	func add(_ viewController: UIViewController)
}

class ColumnNavigationController: UINavigationController {
	
	weak var columnDelegate: ColumnNavigationDelegate?
	
	override func pushViewController(_ viewController: UIViewController, animated: Bool) {
		if let delegate = columnDelegate {
			// TODO: Handle animated == false
			delegate.add(viewController)
		} else {
			super.pushViewController(viewController, animated: animated)
		}
	}

}
