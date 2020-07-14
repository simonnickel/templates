//
//  MainListDataSource.swift
//  Templates
//
//  Created by simonnickel on 22.06.20.
//  Copyright © 2020 simonnickel. All rights reserved.
//

import Foundation
import UIKit
import Combine

enum MainListItem: DiffTVDataSourceItem {
	
	// This as static var is just a dirty workaround to keep the enum simple.
	static var publisherSelectedIndex = CurrentValueSubject<Int, Never>(0)
	
	case fixed, dynamic(_: String)

	func cell(in tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell {
		switch self {
			case .fixed:
				let cell = tableView.dequeueReusableCell(MainListCell.self, for: indexPath)
				cell.title = "Empty"
				return cell
			case .dynamic(let title):
				let cell = tableView.dequeueReusableCell(MainListCell.self, for: indexPath)
				
				CurrentValueSubject<String?, Never>(title).assign(to: \.title, on: cell).store(in: &cell.subscriptions)
				MainListItem.publisherSelectedIndex.map({ "\($0)" }).assign(to: \.subtitle, on: cell).store(in: &cell.subscriptions)
				
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
		snapshot.appendItems([.fixed], toSection: "Section 1")
		for i in 0...100 {
			snapshot.appendItems([.dynamic("Entry \(i)")], toSection: "Section 1")
		}

		return snapshot
	}


	// MARK: - Header

	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		let sections = snapshotCurrent.sectionIdentifiers
		guard section < sections.count else { return nil }
		return sections[section]
	}
	
	
	// MARK: - Update
	
	func updateSelected(to indexPath: IndexPath) {
		MainListItem.publisherSelectedIndex.send(indexPath.row)
	}

}
