//
//  MainListViewController.swift
//  Templates
//
//  Created by simonnickel on 22.06.20.
//  Copyright © 2020 simonnickel. All rights reserved.
//

import UIKit

class MainListViewController: UITableViewController {

	var dataSource: MainListDataSource?

	override func viewDidLoad() {
		super.viewDidLoad()

		MainListItem.registerCells(in: tableView)
		dataSource = MainListDataSource(tableView: tableView)
		dataSource?.reload()
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		dataSource?.updateSelected(to: indexPath)
	}
}

