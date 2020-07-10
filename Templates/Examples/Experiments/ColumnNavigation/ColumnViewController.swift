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
		
		ColumnListItem.registerCells(in: tableView)
		dataSource = ColumnListDataSource(tableView: tableView)
		dataSource?.reload()
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard let item = dataSource?.itemIdentifier(for: indexPath)
			else { return }
		
		let viewController = ColumnViewController()
		switch item {
			case .openModal: present(viewController, animated: true)
			case .openDetail: navigationController?.pushViewController(viewController, animated: true)
		}
	}
	
}


// MARK: - Data Source

enum ColumnListItem: DiffTVDataSourceItem {
	case openModal, openDetail
	
	var title: String {
		switch self {
			case .openModal: return "Open Modal"
			case .openDetail: return "Open Detail"
		}
	}

	func cell(in tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(MainListCell.self, for: indexPath)
		cell.textLabel?.text = title
		
		if self == .openDetail {
			cell.accessoryType = .disclosureIndicator
		}
		return cell
	}

	static func registerCells(in tableView: UITableView) {
		tableView.register(MainListCell.self)
	}
}

typealias ColumnListDataSourceSnapshot = NSDiffableDataSourceSnapshot<String, ColumnListItem>
class ColumnListDataSource: DiffTVDataSource<String, ColumnListItem> {


	// MARK: - Snapshot

	override func snapshot() -> ColumnListDataSourceSnapshot {
		var snapshot = ColumnListDataSourceSnapshot()
		snapshot.appendSections(["Section 1"])
		snapshot.appendItems([.openDetail, .openModal], toSection: "Section 1")

		return snapshot
	}

}
