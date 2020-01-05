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
    private let detailsActionPrism: SearchDetailsActionPrismProtocol
    private let refreshAction: Action
    private var nextRequestAction: Action?
    private var allEntities: NonEmptyArray<SearchEntityModel> {
        didSet {
            guard allEntities != oldValue else { return }
            tableView.reloadData()
        }
    }
    private let colorings: SearchResultsViewColorings
    private let copyFormatter: SearchCopyFormatterProtocol

    private let tableView: UITableView
    private var previousContentOffsetY: CGFloat = 0.0

    init(delegate: SearchResultsViewControllerDelegate,
         store: DispatchingStoreProtocol,
         detailsActionPrism: SearchDetailsActionPrismProtocol,
         refreshAction: Action,
         nextRequestAction: Action?,
         allEntities: NonEmptyArray<SearchEntityModel>,
         colorings: SearchResultsViewColorings,
         copyFormatter: SearchCopyFormatterProtocol) {
        self.delegate = delegate
        self.store = store
        self.detailsActionPrism = detailsActionPrism
        self.refreshAction = refreshAction
        self.nextRequestAction = nextRequestAction
        self.allEntities = allEntities
        self.colorings = colorings
        self.copyFormatter = copyFormatter
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

    func configure(_ allEntities: NonEmptyArray<SearchEntityModel>,
                   nextRequestAction: Action?) {
        self.allEntities = allEntities
        self.nextRequestAction = nextRequestAction
    }

    private func entityModels(for indexPath: IndexPath) -> SearchEntityModel {
        return allEntities.value[indexPath.row]
    }

}

extension SearchResultsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allEntities.value.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withCellType: SearchResultCell.self, for: indexPath)

        AssertionHandler.assertIfErrorThrown {
            let resultCell: SearchResultCell = try CastingFunctions.cast(cell)
            let fields = entityModels(for: indexPath)
            let cellModel = SearchResultCellModel(model: fields.summaryModel,
                                                  copyFormatter: copyFormatter)

            resultCell.configure(cellModel,
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
        return indexPaths.contains { $0.row >= allEntities.value.count - 30 }
    }

}

extension SearchResultsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let fields = entityModels(for: indexPath)
        let detailEntityAction = detailsActionPrism.detailEntityAction(fields.detailsModel)
        store.dispatch(detailEntityAction)
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
