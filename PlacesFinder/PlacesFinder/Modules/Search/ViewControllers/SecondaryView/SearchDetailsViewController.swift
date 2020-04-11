//
//  SearchDetailsViewController.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Shared
import UIKit

class SearchDetailsViewController: SingleContentViewController {

    private let tableView: UITableView
    private let titleLabel: StyledLabel
    private var viewModel: SearchDetailsViewModel
    private var colorings: SearchDetailsViewColorings

    init(viewModel: SearchDetailsViewModel,
         appSkin: AppSkin) {
        self.tableView = UITableView()
        self.titleLabel = StyledLabel(numberOfLines: 1)
        self.viewModel = viewModel
        self.colorings = appSkin.colorings.searchDetails

        super.init(contentView: tableView,
                   viewColoring: colorings.viewColoring)

        setupTitleView()
        setupTableView()
        configure(viewModel,
                  appSkin: appSkin)
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

    func configure(_ viewModel: SearchDetailsViewModel,
                   appSkin: AppSkin) {
        self.colorings = appSkin.colorings.searchDetails
        self.viewModel = viewModel

        viewColoring = colorings.viewColoring

        titleLabel.configure(.navBarTitle,
                             textColoring: appSkin.colorings.navBar.titleTextColoring)
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

extension SearchDetailsViewController: PopCallbackViewController {

    func viewControllerWasPopped() {
        viewModel.dispatchRemoveDetailsAction()
    }

}

extension SearchDetailsViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sectionsCount
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cellViewModels(sectionIndex: section).count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellViewModel = viewModel.cellViewModel(sectionIndex: indexPath.section,
                                                    rowIndex: indexPath.row)
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
        let cellViewModel = viewModel.cellViewModel(sectionIndex: indexPath.section,
                                                    rowIndex: indexPath.row)
        return cellViewModel.isSelectable ? indexPath : nil
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
        switch viewModel.section(sectionIndex: section) {
        case .info,
             .location:
            return 0.0
        }
    }

}
