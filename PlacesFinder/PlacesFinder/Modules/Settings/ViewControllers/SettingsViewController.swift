//
//  SettingsViewController.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

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
                                  textColoring: colorings.cellColorings.textColoring)

        cell.makeSeparatorFullWidth()
        cell.makeTransparent()
        cell.tintColor = colorings.cellColorings.checkmarkTint.color
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        viewModel.dispatchCellAction(sectionIndex: indexPath.section,
                                     rowIndex: indexPath.row)
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
