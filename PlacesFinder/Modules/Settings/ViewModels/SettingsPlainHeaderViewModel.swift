//
//  SettingsPlainHeaderViewModel.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2020 Justin Peckner. All rights reserved.
//

import Foundation
import Shared

struct SettingsPlainHeaderViewModel: Equatable {
    let title: String
}

// MARK: SettingsPlainHeaderViewModelBuilder

protocol SettingsPlainHeaderViewModelBuilderProtocol: AutoMockable {
    func buildViewModel(_ title: String) -> SettingsPlainHeaderViewModel
}

class SettingsPlainHeaderViewModelBuilder: SettingsPlainHeaderViewModelBuilderProtocol {

    func buildViewModel(_ title: String) -> SettingsPlainHeaderViewModel {
        return SettingsPlainHeaderViewModel(title: title)
    }

}
