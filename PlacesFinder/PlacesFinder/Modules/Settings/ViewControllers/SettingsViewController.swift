//
//  SettingsViewController.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Shared
import SwiftDux
import UIKit

// sourcery: fieldName = "settings"
struct SettingsViewColorings: AppColoringProtocol {
    let viewColoring: ViewColoring
    let activeButtonTextColoring: TextColoring
    let cellTextColoring: TextColoring
    let cellCheckmarkTint: FillColoring
    let headerTextColoring: TextColoring
}

class SettingsViewController: SingleContentViewController {

    private let store: DispatchingStoreProtocol
    private let formatter: MeasurementFormatter
    private let colorings: SettingsViewColorings
    private let tableView: GroupedTableView

    private var viewModel = SettingsViewModel(sections: []) {
        didSet {
            tableView.configure(viewModel.tableModel)
        }
    }

    init(store: DispatchingStoreProtocol,
         formatter: MeasurementFormatter,
         appSkin: AppSkin) {
        self.store = store
        self.formatter = formatter
        self.colorings = appSkin.colorings.settings
        self.tableView = GroupedTableView(tableModel: viewModel.tableModel)

        super.init(contentView: tableView,
                   viewColoring: appSkin.colorings.settings.viewColoring)

        tableView.delegate = self
        tableView.bounces = false
        tableView.sectionFooterHeight = 8.0
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension SettingsViewController: UITableViewDelegate {

    // MARK: Configure cells

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.textLabel?.configure(.cellText, textColoring: colorings.cellTextColoring)

        cell.makeSeparatorFullWidth()
        cell.makeTransparent()
        cell.tintColor = colorings.cellCheckmarkTint.color
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let action = viewModel.sections[indexPath.section].cells[indexPath.row].action
        store.dispatch(action)
    }

    // MARK: Configure headers/footers

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionViewModel = viewModel.sections[section]
        let title = sectionViewModel.title

        switch sectionViewModel.headerType {
        case .plain:
            return SettingsSectionHeaderView(title: title,
                                             colorings: colorings)
        case let .measurementSystem(currentSystemInState, copyContent):
            return SettingsMeasurementSystemHeaderView(store: store,
                                                       copyContent: copyContent,
                                                       currentSystemInState: currentSystemInState,
                                                       title: title,
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

extension SettingsViewController {

    func configure(state: AppState) {
        viewModel = SettingsViewModel(searchPreferencesState: state.searchPreferencesState,
                                      formatter: formatter,
                                      appCopyContent: state.appCopyContentState.copyContent)
    }

}
