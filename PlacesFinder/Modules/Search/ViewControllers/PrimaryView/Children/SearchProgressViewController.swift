//
//  SearchProgressViewController.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Shared
import SkeletonView
import UIKit

class SearchProgressViewController: SingleContentViewController {

    private let tableView: UITableView
    private var gradient: SkeletonGradient

    init(colorings: SearchProgressViewColorings) {
        self.tableView = UITableView()
        self.gradient = SkeletonGradient(baseColor: colorings.gradientFill.color)

        super.init(contentView: tableView,
                   viewColoring: colorings.viewColoring)

        setupTableView()
        configure(colorings)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupTableView() {
        tableView.performStandardSetup(
            cellTypes: [
                SearchProgressCell.self
            ],
            dataSource: self,
            delegate: self
        )

        tableView.isScrollEnabled = false
        tableView.allowsSelection = false
    }

}

extension SearchProgressViewController {

    func configure(_ colorings: SearchProgressViewColorings) {
        self.gradient = SkeletonGradient(baseColor: colorings.gradientFill.color)

        tableView.reloadData()
    }

}

extension SearchProgressViewController: SkeletonTableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withCellType: SearchProgressCell.self, for: indexPath)
        cell.makeTransparent()
        return cell
    }

    func collectionSkeletonView(_ skeletonView: UITableView,
                                cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return SearchProgressCell.cellIdentifier
    }

}

extension SearchProgressViewController: SkeletonTableViewDelegate {

    func tableView(_ tableView: UITableView,
                   willDisplay cell: UITableViewCell,
                   forRowAt indexPath: IndexPath) {
        cell.showAnimatedGradientSkeleton(usingGradient: gradient)
    }

}
