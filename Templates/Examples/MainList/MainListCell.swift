//
//  MainListCell.swift
//  Templates
//
//  Created by simonnickel on 22.06.20.
//  Copyright © 2020 simonnickel. All rights reserved.
//

import Foundation
import UIKit
import Combine

class MainListCell: UITableViewCell {

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		setupView()
	}

	required init?(coder: NSCoder) {
		super.init(coder: coder)
		setupView()
	}
	
	override func prepareForReuse() {
		subscriptions.removeAll()
		title = nil
		subtitle = nil
	}


	// MARK: - Values
	
	var subscriptions = Set<AnyCancellable>()

	var title: String? {
		set { labelTitle.text = newValue }
		get { labelTitle.text }
	}

	var subtitle: String? {
		set { labelSubtitle.text = newValue }
		get { labelSubtitle.text }
	}


	// MARK: - Setup View

	private func setupView() {
		containerStack.embed(in: contentView, using: contentView.layoutMarginsGuide)
	}


	// MARK: Views
	
	private lazy var containerStack: UIStackView = {
		let view = UIStackView(arrangedSubviews: [labelTitle, labelSubtitle])
		view.axis = .vertical
		view.alignment = .leading
		view.spacing = 5
		return view
	}()

	private lazy var labelTitle: UILabel = {
		let view = UILabel()
		view.font = UIFont.dynamic(.text)
		view.textColor = UIColor.dynamic(.accent)
		return view
	}()

	private lazy var labelSubtitle: UILabel = {
		let view = UILabel()
		view.font = UIFont.dynamic(.subtext)
		view.textColor = UIColor.dynamic(.text)
		return view
	}()

}
