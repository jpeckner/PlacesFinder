//
//  SearchDetailsViewController.swift
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

class SearchDetailsViewController: SingleContentViewController {

    private let tableView: UITableView
    private let titleLabel: StyledLabel
    private let actionTriggered: (Search.Action) -> Void
    private var props: SearchDetailsProps

    init(props: SearchDetailsProps,
         appSkin: AppSkin,
         actionTriggered: @escaping (Search.Action) -> Void) {
        self.tableView = UITableView()
        self.titleLabel = StyledLabel(numberOfLines: 1)
        self.props = props
        self.actionTriggered = actionTriggered

        super.init(contentView: tableView,
                   viewColoring: props.colorings.viewColoring)

        setupTitleView()
        setupTableView()
        configure(props,
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

    func configure(_ props: SearchDetailsProps,
                   appSkin: AppSkin) {
        self.props = props

        viewColoring = props.colorings.viewColoring

        titleLabel.configure(.navBarTitle,
                             textColoring: appSkin.colorings.navBar.titleTextColoring)
        titleLabel.text = props.placeName
        titleLabel.sizeToFit()

        tableView.reloadData()
        tableView.scrollToTop(animated: true)
    }

}

extension SearchDetailsViewController: PopCallbackViewController {

    func viewControllerWasPopped() {
        actionTriggered(props.removeDetailedEntityAction.value)
    }

}

extension SearchDetailsViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return props.sectionsCount
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return props.cellViewModels(sectionIndex: section).count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellViewModel = props.cellViewModel(sectionIndex: indexPath.section,
                                                rowIndex: indexPath.row)
        let cell = tableView.dequeueReusableCell(withCellType: cellViewModel.cellType,
                                                 for: indexPath)

        AssertionHandler.assertIfErrorThrown {
            try cellViewModel.configureCell(cell,
                                            colorings: props.colorings)
        }

        cell.selectionStyle = cellViewModel.isSelectable ? .default : .none
        cell.makeTransparent()

        return cell
    }

}

extension SearchDetailsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        let cellViewModel = props.cellViewModel(sectionIndex: indexPath.section,
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
        switch props.section(sectionIndex: section) {
        case .info,
             .location:
            return 0.0
        }
    }

}
