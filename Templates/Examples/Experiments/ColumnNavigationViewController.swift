//
//  MultiColumnNavigationViewController.swift
//  Templates
//
//  Created by Simon Nickel on 09.07.20.
//  Copyright © 2020 simonnickel. All rights reserved.
//

import Foundation
import UIKit

class MultiColumnNavigationViewController: UIViewController {
	
	override func viewDidLoad() {
		view.backgroundColor = .white
		super.viewDidLoad()
		
		setupView()
		
		add(ColumnViewController())
		add(ColumnViewController())
	}
	
	
	// MARK: - Add / Remove
	
	func add(_ viewController: UIViewController) {
		let navigation = UINavigationController(rootViewController: viewController)
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

protocol SingleColumnNavigation

class SingleColumnNavigatonController: UINavigationController {
	
	var delegate:
	
	override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
		<#code#>
	}
}
