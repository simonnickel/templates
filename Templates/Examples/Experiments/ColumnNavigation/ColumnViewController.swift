//
//  ColumnViewController.swift
//  Templates
//
//  Created by Simon Nickel on 10.07.20.
//  Copyright © 2020 simonnickel. All rights reserved.
//

import Foundation
import UIKit

class ColumnViewController: UITableViewController {
	
	var dataSource: ColumnListDataSource?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		clearsSelectionOnViewWillAppear = false
		
		dataSource = ColumnListDataSource(tableView: tableView)
		dataSource?.column = (navigationController as? ColumnNavigationController)?.columnIndex ?? 0
		dataSource?.reload()
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard let item = dataSource?.itemIdentifier(for: indexPath)
			else { return }
		
		let viewController = ColumnViewController(style: .insetGrouped)
		switch item {
			case .openModal: present(viewController, animated: true)
			case .openDetail(let i):
				viewController.title = "\(title ?? "")\(i)"
				navigationController?.pushViewController(viewController, animated: true)
		}
	}
	
}


// MARK: - Data Source

enum ColumnListItem: DiffTVDataSourceItem {
	case openModal(i: Int), openDetail(i: Int)
	
	var title: String {
		switch self {
			case .openModal(let i): return "Column \(i)"
			case .openDetail(let i): return "Detail \(i)"
		}
	}

	func cell(in tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell {
		let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
		cell.textLabel?.text = "\(title)"
		cell.contentView.heightAnchor.constraint(equalToConstant: 260).isActive = true
		
		switch self {
			case .openDetail(_): cell.accessoryType = .disclosureIndicator
			default: break
		}
		return cell
	}

	static func registerCells(in tableView: UITableView) {
		
	}
}

typealias ColumnListDataSourceSnapshot = NSDiffableDataSourceSnapshot<String, ColumnListItem>
class ColumnListDataSource: DiffTVDataSource<String, ColumnListItem> {

	var column: Int = 0

	// MARK: - Snapshot

	override func snapshot() -> ColumnListDataSourceSnapshot {
		var snapshot = ColumnListDataSourceSnapshot()
		snapshot.appendSections(["Section 1"])
		snapshot.appendItems([.openDetail(i: 1),
							  .openDetail(i: 2),
							  .openDetail(i: 3),
							  .openDetail(i: 4),
							  .openDetail(i: 5),
							  .openDetail(i: 6),
							  .openDetail(i: 7)
		], toSection: "Section 1")
		
		snapshot.appendSections(["Section 2"])
		snapshot.appendItems([.openModal(i: column)], toSection: "Section 2")


		return snapshot
	}

}
