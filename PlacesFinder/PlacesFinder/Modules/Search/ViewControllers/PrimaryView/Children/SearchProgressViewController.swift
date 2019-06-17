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
    private let gradient: SkeletonGradient

    init(colorings: SearchProgressViewColorings) {
        self.tableView = UITableView()
        self.gradient = SkeletonGradient(baseColor: colorings.gradientFill.color)

        super.init(contentView: tableView,
                   viewColoring: colorings.viewColoring)

        setupTableView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        tableView.visibleCells.forEach {
            $0.hideSkeleton()
            $0.showAnimatedGradientSkeleton(usingGradient: gradient)
        }
    }

    private func setupTableView() {
        tableView.performStandardSetup(
            cellTypes: [
                SearchProgressCell.self
            ],
            dataSource: self
        )

        tableView.isScrollEnabled = false
        tableView.allowsSelection = false
    }

}

extension SearchProgressViewController: SkeletonTableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withCellType: SearchProgressCell.self, for: indexPath)
        cell.showGradientSkeleton(usingGradient: gradient)
        cell.makeTransparent()
        return cell
    }

    func collectionSkeletonView(_ skeletonView: UITableView,
                                cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return SearchProgressCell.cellIdentifier
    }

}
