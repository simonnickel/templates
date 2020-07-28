//
//  DiffTVDataSource.swift
//  Templates
//
//  Created by simonnickel on 22.06.20.
//  Copyright © 2020 simonnickel. All rights reserved.
//

import Foundation
import UIKit

protocol DiffTVDataSourceItem: Hashable {

	static func registerCells(in tableView: UITableView)
	
	func cell(in tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell

}

// Provide default implementation to allow customisation by overriding the cell provider.
extension DiffTVDataSourceItem {
	func cell(in tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell { return UITableViewCell() }
}


class DiffTVDataSource<SectionIdentifierType: Hashable, ItemIdentifierType: DiffTVDataSourceItem>: UITableViewDiffableDataSource<SectionIdentifierType, ItemIdentifierType> {

	override init(tableView: UITableView, cellProvider: UITableViewDiffableDataSource<SectionIdentifierType, ItemIdentifierType>.CellProvider? = nil) {
		let provider = cellProvider ?? { (tableview: UITableView, indexPath: IndexPath, item: ItemIdentifierType) -> UITableViewCell? in
			item.cell(in: tableView, for: indexPath)
		}
		super.init(tableView: tableView, cellProvider: provider)
	}

	private var _snapshotCurrent: NSDiffableDataSourceSnapshot<SectionIdentifierType, ItemIdentifierType>?
	var snapshotCurrent: NSDiffableDataSourceSnapshot<SectionIdentifierType, ItemIdentifierType> {
		get {
			if _snapshotCurrent == nil {
				_snapshotCurrent = snapshot()
			}
			return _snapshotCurrent!
		}
		set { _snapshotCurrent = newValue}
	}

	func reload(animated: Bool = true) {
		snapshotCurrent = snapshot()
		apply(snapshotCurrent, animatingDifferences: animated)
	}

}
