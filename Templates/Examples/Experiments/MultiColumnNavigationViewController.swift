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
	
	private struct Constants {
		static let animationDuration: TimeInterval = 0.5
	}
	
	override func viewDidLoad() {
		view.backgroundColor = .white
		super.viewDidLoad()
		
		setupView()
		add(ColumnViewController(style: .insetGrouped))
	}
	
	
	let numberOfColumns: Int = 5
	
	
	// MARK: - Add
	
	private var columnNavs: [ColumnNavigationController] = []
	
	func add(_ viewController: UIViewController, from indexFrom: Int? = nil) {
		let index = indexFrom ?? 0
		guard index <= columnNavs.count else {
			fatalError()
		}
		removeColumns(after: index)
		viewController.title = "Column \(columnNavs.count)"
		append(createColumn(with: viewController))
		collapse()
    }
	
    private func append(_ column: ColumnNavigationController) {
		columnNavs.append(column)
		column.columnIndex = columnNavs.count
		
        addChild(column)
		addToContainer(column)
        column.didMove(toParent: self)
    }
	
	
	// MARK: - Collapse
	
	private func collapse() {
		guard columnNavs.count >= numberOfColumns else { return }
		guard let column = columnNavs.first else { return }
//		removeFromContainer(column)
	}
	
	
	// MARK: - Remove
	
	private func removeColumns(after index: Int) {
		if index < columnNavs.count {
			for column in columnNavs[index...] {
				pop(column)
			}
		}
	}

    private func pop(_ column: ColumnNavigationController) {
		guard column.parent != nil,
			let index = columnNavs.firstIndex(of: column)
			else { return }

		columnNavs.remove(at: index)
		
		column.willMove(toParent: nil)
		removeFromContainer(column)
		column.removeFromParent()
    }
	
	
	// MARK: - Container
	
	private func addToContainer(_ column: ColumnNavigationController, animated: Bool = true) {
		if animated {
			column.view.isHidden = true
			containerStack.addArrangedSubview(column.view)
			containerStack.layoutIfNeeded()
			UIView.animate(withDuration: Constants.animationDuration, animations: {
				column.view.isHidden = false
				self.containerStack.layoutIfNeeded()
			})
		} else {
			containerStack.addArrangedSubview(column.view)
		}
	}
	
	private func removeFromContainer(_ column: ColumnNavigationController, animated: Bool = true) {
		if animated {
			UIView.animate(withDuration: Constants.animationDuration, animations: {
				column.view.isHidden = true
				self.containerStack.layoutIfNeeded()
			}) { _ in
				self.containerStack.removeArrangedSubview(column.view)
			}
		} else {
			containerStack.removeArrangedSubview(column.view)
		}
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
