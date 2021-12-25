//
//  SettingsViewController.swift
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

class SettingsViewController: SingleContentViewController {

    private var viewModel: SettingsViewModel
    private var colorings: SettingsViewColorings
    private let tableView: GroupedTableView

    init(viewModel: SettingsViewModel,
         colorings: SettingsViewColorings) {
        self.viewModel = viewModel
        self.colorings = colorings

        self.tableView = GroupedTableView(tableModel: viewModel.tableModel)

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
        tableView.delegate = self
        tableView.bounces = false
        tableView.sectionFooterHeight = 8.0
    }

}

extension SettingsViewController {

    func configure(_ viewModel: SettingsViewModel,
                   colorings: SettingsViewColorings) {
        self.colorings = colorings
        self.viewModel = viewModel

        viewColoring = colorings.viewColoring

        tableView.configure(viewModel.tableModel)
    }

}

extension SettingsViewController: UITableViewDelegate {

    // MARK: Configure cells

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.textLabel?.configure(.cellText,
                                  textColoring: colorings.cellTextColoring)

        cell.makeSeparatorFullWidth()
        cell.makeTransparent()
        cell.tintColor = colorings.cellCheckmarkTint.color
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let cellModel = viewModel.sections.value[indexPath.section].cells[indexPath.row]
        cellModel.dispatchAction()
    }

    // MARK: Configure headers/footers

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionViewModel = viewModel.sections.value[section]

        switch sectionViewModel.headerType {
        case let .plain(viewModel):
            return SettingsSectionHeaderView(viewModel: viewModel,
                                             colorings: colorings)
        case let .measurementSystem(viewModel):
            return SettingsMeasurementSystemHeaderView(viewModel: viewModel,
                                                       colorings: colorings)
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44.0
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }

}
