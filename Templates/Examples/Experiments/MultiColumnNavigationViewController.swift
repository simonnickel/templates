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
	
	private var columnsAll: [ColumnNavigationController] = []
	private var columnsVisible: [ColumnNavigationController] = []
	
	func add(_ viewController: UIViewController, from indexFrom: Int? = nil) {
		let index = indexFrom ?? 0
		guard index <= columnsAll.count else {
			fatalError()
		}
		removeColumns(after: index)
		append(createColumn(with: viewController))
		updateVisibility()
    }
	
    private func append(_ column: ColumnNavigationController) {
		columnsAll.append(column)
		column.columnIndex = columnsAll.count
		
        addChild(column)
		addToContainer(column)
        column.didMove(toParent: self)
    }
	
	
	// MARK: - Collapse / Expand
	
	private func updateVisibility() {
//		collapseFirst()
	}
	
	private func collapseFirst() {
		guard columnsAll.count >= numberOfColumns else { return }
		guard let column = columnsAll.first else { return }
		removeFromContainer(column)
	}
	
	private func expandFirst() {
		guard columnsAll.count >= numberOfColumns else { return }
		guard let column = columnsAll.first else { return }
		addToContainer(column, at: .first)
	}
	
	
	// MARK: - Remove
	
	private func removeColumns(after index: Int) {
		if index < columnsAll.count {
			for column in columnsAll[index...] {
				pop(column)
			}
		}
	}

    private func pop(_ column: ColumnNavigationController) {
		guard column.parent != nil else { return }

		columnsAll.removeAll(where: { $0 == column })
		
		column.willMove(toParent: nil)
		removeFromContainer(column)
		column.removeFromParent()
    }
	
	
	// MARK: - Container
	enum ContainerPosition {
		case first, last
	}
	
	private func addToContainer(_ column: ColumnNavigationController, at position: ContainerPosition = .last, animated: Bool = true) {
		columnsVisible.append(column)
		if animated {
			column.view.isHidden = true
			addToContainer(column.view, at: position)
			containerStack.layoutIfNeeded()
			UIView.animate(withDuration: Constants.animationDuration, animations: {
				column.view.isHidden = false
				self.containerStack.layoutIfNeeded()
			})
		} else {
			addToContainer(column.view, at: position)
		}
	}
	private func addToContainer(_ view: UIView, at position: ContainerPosition = .last) {
		switch position {
			case .first: containerStack.insertArrangedSubview(view, at: 0)
			case .last: containerStack.addArrangedSubview(view)
		}
	}
	
	private func removeFromContainer(_ column: ColumnNavigationController, animated: Bool = true) {
		columnsVisible.removeAll(where: { $0 == column })
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
