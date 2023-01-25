//
//  SearchProgressViewController.swift
//  PlacesFinder
//
//  Copyright (c) 2019 Justin Peckner
//  
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//  
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//  
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

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
