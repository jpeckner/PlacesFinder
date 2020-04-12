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

struct SettingsCellViewModel: Equatable, Identifiable {
    let id: Int
    let title: String
    let isSelected: Bool
    private let store: IgnoredEquatable<DispatchingStoreProtocol>
    private let action: IgnoredEquatable<Action>

    init(id: Int,
         title: String,
         isSelected: Bool,
         store: DispatchingStoreProtocol,
         action: Action) {
        self.id = id
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
            return buildModels(currentlySelectedDistance) { .imperial($0) }
        case let .metric(currentlySelectedDistance):
            return buildModels(currentlySelectedDistance) { .metric($0) }
        }
    }

    private func buildModels<T: SearchDistanceType>(_ currentlySelectedDistance: T,
                                                    distanceBlock: (T) -> SearchDistance) -> [SettingsCellViewModel] {
        return T.allCases.enumerated().map {
            SettingsCellViewModel(id: $0.offset,
                                  title: measurementFormatter.string(from: $0.element.measurement),
                                  isSelected: currentlySelectedDistance == $0.element,
                                  store: store,
                                  action: SearchPreferencesAction.setDistance(distanceBlock($0.element)))
        }
    }

    func buildSortingCellModels(_ sorting: PlaceLookupSorting,
                                copyContent: SettingsSortPreferenceCopyContent) -> [SettingsCellViewModel] {
        return PlaceLookupSorting.allCases.enumerated().map {
            SettingsCellViewModel(id: $0.offset,
                                  title: copyContent.title($0.element),
                                  isSelected: sorting == $0.element,
                                  store: store,
                                  action: SearchPreferencesAction.setSorting($0.element))
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
