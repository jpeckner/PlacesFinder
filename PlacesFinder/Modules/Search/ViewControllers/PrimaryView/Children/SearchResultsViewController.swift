//
//  SearchResultsViewController.swift
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
import UIKit

protocol SearchResultsViewControllerDelegate: AnyObject {
    // periphery:ignore:parameters viewController
    func viewController(_ viewController: SearchResultsViewController,
                        didScroll deltaY: CGFloat)
}

class SearchResultsViewController: SingleContentViewController {

    weak var delegate: SearchResultsViewControllerDelegate?
    private var viewModel: SearchResultsViewModel
    private var colorings: SearchResultsViewColorings
    private let tableView: UITableView
    private let refreshControl: UIRefreshControl

    private var previousContentOffsetY: CGFloat = 0.0

    init(viewModel: SearchResultsViewModel,
         colorings: SearchResultsViewColorings) {
        self.viewModel = viewModel
        self.colorings = colorings
        self.tableView = UITableView()
        self.refreshControl = UIRefreshControl()

        super.init(contentView: tableView,
                   viewColoring: colorings.viewColoring)

        setupTableView()
        configure(viewModel,
                  colorings: colorings)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupTableView() {
        tableView.performStandardSetup(
            cellTypes: [
                SearchResultCell.self,
            ],
            dataSource: self,
            delegate: self
        )

        tableView.prefetchDataSource = self
        tableView.allowsSelection = true
        tableView.refreshControl = refreshControl
    }

}

extension SearchResultsViewController {

    func configure(_ viewModel: SearchResultsViewModel,
                   colorings: SearchResultsViewColorings) {
        self.viewModel = viewModel
        self.colorings = colorings

        refreshControl.tintColor = colorings.refreshControlTint.color

        tableView.reloadData()
    }

}

extension SearchResultsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cellViewModelCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withCellType: SearchResultCell.self, for: indexPath)

        AssertionHandler.assertIfErrorThrown {
            let resultCell: SearchResultCell = try CastingFunctions.cast(cell)
            let cellViewModel = viewModel.cellViewModel(rowIndex: indexPath.row)
            resultCell.configure(cellViewModel,
                                 colorings: colorings)
        }

        cell.makeTransparent()

        return cell
    }

}

extension SearchResultsViewController: UITableViewDataSourcePrefetching {

    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        guard viewModel.hasNextRequestAction,
            isCloseEnoughToBottomForNextRequest(indexPaths)
        else { return }

        viewModel.dispatchNextRequestAction()
    }

    private func isCloseEnoughToBottomForNextRequest(_ indexPaths: [IndexPath]) -> Bool {
        return indexPaths.contains { $0.row >= viewModel.cellViewModelCount - 30 }
    }

}

extension SearchResultsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        viewModel.dispatchDetailsAction(rowIndex: indexPath.row)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard !scrollView.isBouncingTop,
            !scrollView.isBouncingBottom
        else { return }

        let yOffset = scrollView.contentOffset.y
        delegate?.viewController(self, didScroll: yOffset - previousContentOffsetY)
        previousContentOffsetY = yOffset
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard refreshControl.isRefreshing else { return }

        tableView.setContentOffset(.zero, animated: true)
        refreshControl.endRefreshing()

        viewModel.dispatchRefreshAction()
    }

}
