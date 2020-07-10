//
//  MultiColumnNavigationViewController.swift
//  Templates
//
//  Created by Simon Nickel on 09.07.20.
//  Copyright © 2020 simonnickel. All rights reserved.
//

import Foundation
import UIKit

// TODO: Keep ScrollView State on collapse and expand. State Restoration?
// TODO: Handle back navigation.

class MultiColumnNavigationViewController: UIViewController, ColumnNavigationDelegate {
	
	private struct Constants {
		static let animationDuration: TimeInterval = 0.5
		static let maxColumns: Int = 4
		static let minColumnWidth: CGFloat = 300
	}
	
	override func viewDidLoad() {
		view.backgroundColor = .white
		super.viewDidLoad()
		
		setupView()
		add(ColumnViewController(style: .insetGrouped))
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		updateVisibility()
	}
	
	
	// MARK: - ColumnNavigationDelegate
	
	func add(_ viewController: UIViewController, from indexFrom: Int? = nil) {
		let index = indexFrom ?? 0
		guard index <= columnsAll.count else {
			fatalError()
		}
		removeColumns(after: index)
		append(createColumn(with: viewController))
		updateVisibility()
    }
	
	func pop() {
		guard let columnTop = columnsVisible.last else { return }
		pop(columnTop)
		updateVisibility()
	}
	
	
	// MARK: - Column Handling
	
	private var columnsAll: [ColumnNavigationController] = []
	private var columnsVisible: [ColumnNavigationController] = []
	private var columnsHidden: [ColumnNavigationController] = []
	
	
	// MARK: Add
	
    private func append(_ column: ColumnNavigationController) {
		columnsAll.append(column)
		column.columnIndex = columnsAll.count
		
        addChild(column)
		addToContainer(column)
        column.didMove(toParent: self)
    }
	
	
	// MARK: Remove
	
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
	
	
	// MARK: - Collapse / Expand
	
	var maxColumns: Int {
		let fittingWidth: Double = Double(view.bounds.width / Constants.minColumnWidth)
		return min(Constants.maxColumns, Int(fittingWidth.rounded(.down)))
	}
	
	private func updateVisibility() {
		let maxColumns = self.maxColumns
		while columnsVisible.count > maxColumns || (columnsVisible.count < maxColumns && columnsHidden.count != 0) {
			if columnsVisible.count < maxColumns {
				expandFirst()
			} else {
				collapseFirst()
			}
		}
		buildNavigationStack()
	}
	
	private func collapseFirst() {
		guard let column = columnsVisible.first else { return }
		columnsHidden.append(column)
		removeFromContainer(column)
	}
	
	private func expandFirst() {
		guard let columnToShow = columnsHidden.last else { return }
		columnsHidden.removeLast()
		moveNavigationStack(to: columnToShow)
		addToContainer(columnToShow, at: .first)
	}
	
	
	// MARK: - Navigation
	
	private func buildNavigationStack() {
		guard let firstVisible = columnsVisible.first else { return }
		let viewControllers: [UIViewController] = columnsHidden.flatMap({ $0.viewControllers }) + firstVisible.viewControllers
		viewControllers.last?.navigationItem.hidesBackButton = false
		firstVisible.setViewControllers(viewControllers, animated: false)
	}
	
	private func moveNavigationStack(to column: ColumnNavigationController) {
		guard let columnVisibleFirst = columnsVisible.first else { return }
		
		var navigationStack = columnVisibleFirst.viewControllers
		let navigationStackFirst = navigationStack.removeLast()
		navigationStack.last?.navigationItem.hidesBackButton = false
		
		column.setViewControllers(navigationStack, animated: false)
		
		navigationStackFirst.navigationItem.hidesBackButton = true
		columnVisibleFirst.setViewControllers([navigationStackFirst], animated: false)
	}
	
	
	// MARK: - Container
	enum ContainerPosition {
		case first, last
	}
	
	private func addToContainer(_ column: ColumnNavigationController, at position: ContainerPosition = .last, animated: Bool = true) {
		switch position {
			case .first: columnsVisible.insert(column, at: 0)
			case .last: columnsVisible.append(column)
		}
		
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
	func pop()
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

	override func popViewController(animated: Bool) -> UIViewController? {
//		super.popViewController(animated: animated)
		
		columnDelegate?.pop()
		
		return nil
	}
}
