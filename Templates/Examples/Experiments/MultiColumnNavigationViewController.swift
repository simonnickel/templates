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
		add(ColumnViewController(style: .insetGrouped))
	}
	
	
	// MARK: - Add
	
	private var columnNavs: [ColumnNavigationController] = []
	
	func add(_ viewController: UIViewController, from indexFrom: Int? = nil) {
		let index = indexFrom ?? 0
		guard index <= columnNavs.count else {
			fatalError()
		}
		
		removeColumns(after: index)
		append(createColumn(with: viewController))
    }
	
    private func append(_ column: ColumnNavigationController) {
		column.topViewController?.title = "Column \(columnNavs.count)"
		
		columnNavs.append(column)
		column.columnIndex = columnNavs.count
		
        addChild(column)
		containerStack.addArrangedSubview(column.view)
        column.didMove(toParent: self)
    }
	
	
	// MARK: - Remove
	
	private func removeColumns(after index: Int) {
		if index < columnNavs.count {
			for column in columnNavs[index...] {
				remove(column)
			}
		}
	}

    private func remove(_ column: ColumnNavigationController) {
		guard column.parent != nil,
			let index = columnNavs.firstIndex(of: column)
			else { return }

		columnNavs.remove(at: index)
		
		column.willMove(toParent: nil)
		column.view.removeFromSuperview()
		column.removeFromParent()
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
	
	private func createColumn(with viewController: UIViewController) -> ColumnNavigationController {
		let navigation = ColumnNavigationController(rootViewController: viewController)
		navigation.columnDelegate = self
		
		return navigation
	}
}


// MARK: - ColumnNavigationDelegate

protocol ColumnNavigationDelegate: class {
	func add(_ viewController: UIViewController, from index: Int?)
}


// MARK: - ColumnNavigationController

class ColumnNavigationController: UINavigationController {
	
	weak var columnDelegate: ColumnNavigationDelegate?
	var columnIndex: Int = 0
	
	override func pushViewController(_ viewController: UIViewController, animated: Bool) {
		if let delegate = columnDelegate {
			// TODO: Handle animated == false
			delegate.add(viewController, from: columnIndex)
		} else {
			super.pushViewController(viewController, animated: animated)
		}
	}

}
