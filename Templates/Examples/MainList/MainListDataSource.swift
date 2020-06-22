//
//  MainListDataSource.swift
//  Templates
//
//  Created by simonnickel on 22.06.20.
//  Copyright © 2020 simonnickel. All rights reserved.
//

import Foundation
import UIKit

enum MainListItem: DiffTVDataSourceItem {
	case empty, entry(_: String)

	func cell(in tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell {
		switch self {
			case .empty:
				let cell = tableView.dequeueReusableCell(MainListCell.self, for: indexPath)
				cell.textLabel?.text = "Empty"
				return cell
			case .entry(let title):
				let cell = tableView.dequeueReusableCell(MainListCell.self, for: indexPath)
				cell.textLabel?.text = title
				return cell
		}
	}

	static func registerCells(in tableView: UITableView) {
		tableView.register(MainListCell.self)
	}
}

typealias MainListDataSourceSnapshot = NSDiffableDataSourceSnapshot<String, MainListItem>
class MainListDataSource: DiffTVDataSource<String, MainListItem> {


	// MARK: - Snapshot

	override func snapshot() -> MainListDataSourceSnapshot {
		var snapshot = MainListDataSourceSnapshot()
		snapshot.appendSections(["Section 1"])
		snapshot.appendItems([.entry("Entry A"), .entry("Entry B")], toSection: "Section 1")

		return snapshot
	}


	// MARK: - Header

	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		let sections = snapshotCurrent.sectionIdentifiers
		guard section < sections.count else { return nil }
		return sections[section]
	}

}
