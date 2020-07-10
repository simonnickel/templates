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
		
		dataSource = ColumnListDataSource(tableView: tableView)
		dataSource?.reload()
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard let item = dataSource?.itemIdentifier(for: indexPath)
			else { return }
		
		let viewController = ColumnViewController(style: .insetGrouped)
		switch item {
			case .openModal: present(viewController, animated: true)
			case .openDetail: navigationController?.pushViewController(viewController, animated: true)
		}
	}
	
}


// MARK: - Data Source

enum ColumnListItem: DiffTVDataSourceItem {
	case openModal, openDetail(i: Int)
	
	var title: String {
		switch self {
			case .openModal: return "Modal \(Int.random(in: 0...20))"
			case .openDetail(let i): return "Detail \(i)"
		}
	}

	func cell(in tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell {
		let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
		cell.textLabel?.text = "Open \(title)"
		cell.contentView.heightAnchor.constraint(equalToConstant: 60).isActive = true
		
		if self != .openModal {
			cell.accessoryType = .disclosureIndicator
		}
		return cell
	}

	static func registerCells(in tableView: UITableView) {
		
	}
}

typealias ColumnListDataSourceSnapshot = NSDiffableDataSourceSnapshot<String, ColumnListItem>
class ColumnListDataSource: DiffTVDataSource<String, ColumnListItem> {


	// MARK: - Snapshot

	override func snapshot() -> ColumnListDataSourceSnapshot {
		var snapshot = ColumnListDataSourceSnapshot()
		snapshot.appendSections(["Section 1"])
		snapshot.appendItems([.openDetail(i: 1), .openDetail(i: 2)], toSection: "Section 1")
		
		snapshot.appendSections(["Section 2"])
		snapshot.appendItems([.openModal], toSection: "Section 2")


		return snapshot
	}

}
