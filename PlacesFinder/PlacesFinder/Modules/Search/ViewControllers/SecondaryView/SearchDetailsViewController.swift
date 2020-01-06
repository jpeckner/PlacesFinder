//
//  SearchDetailsViewController.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Shared
import SwiftDux
import UIKit

class SearchDetailsViewController: SingleContentViewController {

    private let store: DispatchingStoreProtocol
    private let actionPrism: SearchSubsequentActionPrismProtocol & SearchDetailsActionPrismProtocol
    private let urlOpenerService: URLOpenerServiceProtocol
    private let copyFormatter: SearchCopyFormatterProtocol
    private let colorings: SearchDetailsViewColorings
    private let tableView: UITableView
    private let titleLabel: StyledLabel

    var viewModel: SearchDetailsViewModel = .init(placeName: "", sections: []) {
        didSet {
            guard viewModel != oldValue else { return }

            titleLabel.text = viewModel.placeName
            titleLabel.sizeToFit()

            UIView.animate(
                withDuration: 0,
                animations: {
                    self.tableView.reloadData()
                }, completion: { _ in
                    self.tableView.scrollToTop(animated: true)
                }
            )
        }
    }

    init(store: DispatchingStoreProtocol,
         actionPrism: SearchSubsequentActionPrismProtocol & SearchDetailsActionPrismProtocol,
         urlOpenerService: URLOpenerServiceProtocol,
         copyFormatter: SearchCopyFormatterProtocol,
         appSkin: AppSkin) {
        self.store = store
        self.actionPrism = actionPrism
        self.urlOpenerService = urlOpenerService
        self.copyFormatter = copyFormatter
        self.colorings = appSkin.colorings.searchDetails
        self.tableView = UITableView()
        self.titleLabel = StyledLabel(textStyleClass: .navBarTitle,
                                      textColoring: appSkin.colorings.navBar.titleTextColoring,
                                      numberOfLines: 1)

        super.init(contentView: tableView,
                   viewColoring: colorings.viewColoring)

        setupTitleView()
        setupTableView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupTitleView() {
        titleLabel.adjustFontSizeToFitWidth()
        titleLabel.setContentHuggingPriority(.required, for: .horizontal)
        navigationItem.titleView = titleLabel
    }

    private func setupTableView() {
        tableView.performStandardSetup(
            cellTypes: allDetailsSectionTypes.flatMap { $0.allCellTypes },
            dataSource: self,
            delegate: self
        )
    }

}

extension SearchDetailsViewController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        tableView.scrollToTop(animated: false)
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        tableView.scrollToTop(animated: false)
    }

}

extension SearchDetailsViewController {

    func viewWasPopped() {
        store.dispatch(actionPrism.removeDetailedEntityAction)
    }

}

extension SearchDetailsViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cellViewModels(for: section).count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellViewModel = viewModel.cellViewModel(for: indexPath)
        let cell = tableView.dequeueReusableCell(withCellType: cellViewModel.cellType, for: indexPath)

        AssertionHandler.assertIfErrorThrown {
            try cellViewModel.configureCell(cell,
                                            colorings: colorings)
        }

        cell.selectionStyle = cellViewModel.isSelectable ? .default : .none
        cell.makeTransparent()

        return cell
    }

}

extension SearchDetailsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return viewModel.cellViewModel(for: indexPath).isSelectable ? indexPath : nil
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        switch tableView.cellForRow(at: indexPath) {
        case let phoneCell as SearchDetailsPhoneNumberCell:
            phoneCell.executeTapCallback()
        default:
            break
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return self.tableView(tableView, heightForHeaderInSection: section) > 0 ? UIView() : nil
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch viewModel.sections[section] {
        case .info, .location:
            return 0.0
        }
    }

}

private extension SearchDetailsViewModel {

    func cellViewModels(for section: Int) -> [SearchDetailsSectionProtocol] {
        switch sections[section] {
        case let .info(viewModels as [SearchDetailsSectionProtocol]),
             let .location(viewModels as [SearchDetailsSectionProtocol]):
            return viewModels
        }
    }

    func cellViewModel(for indexPath: IndexPath) -> SearchDetailsSectionProtocol {
        return cellViewModels(for: indexPath.section)[indexPath.row]
    }

}
