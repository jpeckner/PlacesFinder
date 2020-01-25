//
//  SearchPreferencesState+Settings.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Foundation
import Shared

extension SearchPreferencesState {

    private typealias SearchDistanceType = SearchDistanceTypeProtocol & CaseIterable & Equatable

    func distanceCellModels(_ measurementFormatter: MeasurementFormatterProtocol) -> [SettingsCellViewModel] {
        switch distance {
        case let .imperial(currentlySelectedDistance):
            return buildModels(currentlySelectedDistance,
                               measurementFormatter: measurementFormatter) { .imperial($0) }
        case let .metric(currentlySelectedDistance):
            return buildModels(currentlySelectedDistance,
                               measurementFormatter: measurementFormatter) { .metric($0) }
        }
    }

    private func buildModels<T: SearchDistanceType>(_ currentlySelectedDistance: T,
                                                    measurementFormatter: MeasurementFormatterProtocol,
                                                    distanceBlock: (T) -> SearchDistance) -> [SettingsCellViewModel] {
        return T.allCases.enumerated().map {
            SettingsCellViewModel(
                id: $0.offset,
                title: measurementFormatter.string(from: $0.element.measurement),
                hasCheckmark: currentlySelectedDistance == $0.element,
                action: SearchPreferencesAction.setDistance(distanceBlock($0.element))
            )
        }
    }

}

extension SearchPreferencesState {

    func sortingCellModels(_ copyContent: SettingsSortPreferenceCopyContent) -> [SettingsCellViewModel] {
        return PlaceLookupSorting.allCases.enumerated().map {
            SettingsCellViewModel(
                id: $0.offset,
                title: copyContent.title($0.element),
                hasCheckmark: sorting == $0.element,
                action: SearchPreferencesAction.setSorting($0.element)
            )
        }
    }

}

private extension SettingsSortPreferenceCopyContent {

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
