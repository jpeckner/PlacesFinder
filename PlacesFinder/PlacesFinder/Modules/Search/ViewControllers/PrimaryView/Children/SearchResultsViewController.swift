//
//  SearchResultsViewController.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Shared
import UIKit

protocol SearchResultsViewControllerDelegate: AnyObject {
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
