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

    func distanceCellModels(_ formatter: MeasurementFormatter) -> [SettingsCellViewModel] {
        switch distance {
        case let .imperial(currentlySelectedDistance):
            return buildModels(currentlySelectedDistance, formatter: formatter) { .imperial($0) }
        case let .metric(currentlySelectedDistance):
            return buildModels(currentlySelectedDistance, formatter: formatter) { .metric($0) }
        }
    }

    private func buildModels<T: SearchDistanceType>(_ currentlySelectedDistance: T,
                                                    formatter: MeasurementFormatter,
                                                    distanceBlock: (T) -> SearchDistance) -> [SettingsCellViewModel] {
        return T.allCases.map {
            SettingsCellViewModel(
                title: formatter.string(from: $0.measurement),
                hasCheckmark: currentlySelectedDistance == $0,
                action: IgnoredHashable(SearchPreferencesAction.setDistance(distanceBlock($0)))
            )
        }
    }

}

extension SearchPreferencesState {

    func sortingCellModels(_ copyContent: SettingsSortPreferenceCopyContent) -> [SettingsCellViewModel] {
        return PlaceLookupSorting.allCases.map {
            SettingsCellViewModel(
                title: copyContent.title($0),
                hasCheckmark: sorting == $0,
                action: IgnoredHashable(SearchPreferencesAction.setSorting($0))
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
