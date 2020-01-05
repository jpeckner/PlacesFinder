//
//  SearchResultsViewController.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Shared
import SwiftDux
import UIKit

protocol SearchResultsViewControllerDelegate: AnyObject {
    func viewController(_ viewController: SearchResultsViewController,
                        didScroll deltaY: CGFloat)
}

class SearchResultsViewController: SingleContentViewController {

    private weak var delegate: SearchResultsViewControllerDelegate?

    private let store: DispatchingStoreProtocol
    private let refreshAction: Action
    private let colorings: SearchResultsViewColorings

    private var nextRequestAction: Action?
    private var resultViewModels: NonEmptyArray<SearchResultViewModel> {
        didSet {
            tableView.reloadData()
        }
    }

    private let tableView: UITableView
    private var previousContentOffsetY: CGFloat = 0.0

    init(delegate: SearchResultsViewControllerDelegate,
         store: DispatchingStoreProtocol,
         refreshAction: Action,
         colorings: SearchResultsViewColorings,
         nextRequestAction: Action?,
         resultViewModels: NonEmptyArray<SearchResultViewModel>) {
        self.delegate = delegate
        self.store = store
        self.refreshAction = refreshAction
        self.nextRequestAction = nextRequestAction
        self.resultViewModels = resultViewModels
        self.colorings = colorings
        self.tableView = UITableView()

        super.init(contentView: tableView,
                   viewColoring: colorings.viewColoring)

        setupTableView()
        setupRefreshControl(colorings)
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
    }

    private func setupRefreshControl(_ colorings: SearchResultsViewColorings) {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = colorings.refreshControlTint.color
        tableView.refreshControl = refreshControl
    }

}

extension SearchResultsViewController {

    func configure(_ resultViewModels: NonEmptyArray<SearchResultViewModel>,
                   nextRequestAction: Action?) {
        self.resultViewModels = resultViewModels
        self.nextRequestAction = nextRequestAction
    }

    private func resultViewModel(for indexPath: IndexPath) -> SearchResultViewModel {
        return resultViewModels.value[indexPath.row]
    }

}

extension SearchResultsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultViewModels.value.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withCellType: SearchResultCell.self, for: indexPath)

        AssertionHandler.assertIfErrorThrown {
            let resultCell: SearchResultCell = try CastingFunctions.cast(cell)
            let viewModel = resultViewModel(for: indexPath)
            resultCell.configure(viewModel.cellModel,
                                 colorings: colorings)
        }

        cell.makeTransparent()

        return cell
    }

}

extension SearchResultsViewController: UITableViewDataSourcePrefetching {

    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        guard let nextRequestAction = nextRequestAction,
            isCloseEnoughToBottomForNextRequest(indexPaths)
        else { return }

        self.nextRequestAction = nil
        store.dispatch(nextRequestAction)
    }

    private func isCloseEnoughToBottomForNextRequest(_ indexPaths: [IndexPath]) -> Bool {
        return indexPaths.contains { $0.row >= resultViewModels.value.count - 30 }
    }

}

extension SearchResultsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let viewModel = resultViewModel(for: indexPath)
        store.dispatch(viewModel.detailEntityAction)
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
        guard tableView.refreshControl?.isRefreshing ?? false else { return }

        tableView.setContentOffset(.zero, animated: true)
        tableView.refreshControl?.endRefreshing()
        store.dispatch(refreshAction)
    }

}
