//
//  ColumnNavigationViewController.swift
//  Templates
//
//  Created by Simon Nickel on 09.07.20.
//  Copyright © 2020 simonnickel. All rights reserved.
//

import Foundation
import UIKit

class ColumnNavigationViewController: UIViewController {
	
	override func viewDidLoad() {
		view.backgroundColor = .white
		super.viewDidLoad()
		
		setupView()
		
		let vc1 = ColumnViewController()
		vc1.view.backgroundColor = .yellow
		add(vc1)
		
		let vc2 = ColumnViewController()
		vc2.view.backgroundColor = .orange
		add(vc2)
		
		let vc3 = ColumnViewController()
		vc3.view.backgroundColor = .red
		add(vc3)
	}
	
	
	// MARK: - Add / Remove
	
    func add(_ child: UIViewController) {
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
