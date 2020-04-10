//
//  SettingsCellViewModel.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2020 Justin Peckner. All rights reserved.
//

import Foundation
import Shared
import SwiftDux

struct SettingsCellViewModel: Equatable {
    let title: String
    let isSelected: Bool
    private let store: IgnoredEquatable<DispatchingStoreProtocol>
    private let action: IgnoredEquatable<Action>

    init(title: String,
         isSelected: Bool,
         store: DispatchingStoreProtocol,
         action: Action) {
        self.title = title
        self.isSelected = isSelected
        self.store = IgnoredEquatable(store)
        self.action = IgnoredEquatable(action)
    }
}

extension SettingsCellViewModel {

    func dispatchAction() {
        store.value.dispatch(action.value)
    }

}

// MARK: SettingsCellViewModelBuilder

protocol SettingsCellViewModelBuilderProtocol: AutoMockable {
    func buildDistanceCellModels(_ distance: SearchDistance) -> [SettingsCellViewModel]

    func buildSortingCellModels(_ sorting: PlaceLookupSorting,
                                copyContent: SettingsSortPreferenceCopyContent) -> [SettingsCellViewModel]
}

class SettingsCellViewModelBuilder {

    private typealias SearchDistanceType = SearchDistanceTypeProtocol & CaseIterable & Equatable

    private let store: DispatchingStoreProtocol
    private let measurementFormatter: MeasurementFormatterProtocol

    init(store: DispatchingStoreProtocol,
         measurementFormatter: MeasurementFormatterProtocol) {
        self.store = store
        self.measurementFormatter = measurementFormatter
    }

}

extension SettingsCellViewModelBuilder: SettingsCellViewModelBuilderProtocol {

    func buildDistanceCellModels(_ currentSearchDistance: SearchDistance) -> [SettingsCellViewModel] {
        switch currentSearchDistance {
        case let .imperial(currentlySelectedDistance):
            return buildModels(currentlySelectedDistance,
                               store: store,
                               measurementFormatter: measurementFormatter) { .imperial($0) }
        case let .metric(currentlySelectedDistance):
            return buildModels(currentlySelectedDistance,
                               store: store,
                               measurementFormatter: measurementFormatter) { .metric($0) }
        }
    }

    private func buildModels<T: SearchDistanceType>(_ currentlySelectedDistance: T,
                                                    store: DispatchingStoreProtocol,
                                                    measurementFormatter: MeasurementFormatterProtocol,
                                                    distanceBlock: (T) -> SearchDistance) -> [SettingsCellViewModel] {
        return T.allCases.map {
            SettingsCellViewModel(title: measurementFormatter.string(from: $0.measurement),
                                  isSelected: currentlySelectedDistance == $0,
                                  store: store,
                                  action: SearchPreferencesAction.setDistance(distanceBlock($0)))
        }
    }

    func buildSortingCellModels(_ sorting: PlaceLookupSorting,
                                copyContent: SettingsSortPreferenceCopyContent) -> [SettingsCellViewModel] {
        return PlaceLookupSorting.allCases.map {
            SettingsCellViewModel(title: copyContent.title($0),
                                  isSelected: sorting == $0,
                                  store: store,
                                  action: SearchPreferencesAction.setSorting($0))
        }
    }

}

extension SettingsSortPreferenceCopyContent {

    func title(_ sorting: PlaceLookupSorting) -> String {
        switch sorting {
        case .bestMatch:
            return bestMatchTitle
        case .distance:
            return distanceTitle
        case .rating:
            return ratingTitle
        case .reviewCount:
            return reviewCountTitle
        }
    }

}
