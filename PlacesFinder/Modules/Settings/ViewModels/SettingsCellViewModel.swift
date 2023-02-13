//
//  SettingsCellViewModel.swift
//  PlacesFinder
//
//  Copyright (c) 2020 Justin Peckner
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

import Combine
import Foundation
import Shared
import SwiftDux

struct SettingsCellViewModel: Equatable {
    let title: String
    let isSelected: Bool
    private let actionSubscriber: IgnoredEquatable<AnySubscriber<SearchPreferencesAction, Never>>
    private let action: IgnoredEquatable<SearchPreferencesAction>

    init(title: String,
         isSelected: Bool,
         actionSubscriber: AnySubscriber<SearchPreferencesAction, Never>,
         action: SearchPreferencesAction) {
        self.title = title
        self.isSelected = isSelected
        self.actionSubscriber = IgnoredEquatable(actionSubscriber)
        self.action = IgnoredEquatable(action)
    }
}

extension SettingsCellViewModel {

    func dispatchAction() {
        _ = actionSubscriber.value.receive(action.value)
    }

}

// MARK: SettingsCellViewModelBuilder

// sourcery: AutoMockable
protocol SettingsCellViewModelBuilderProtocol {
    func buildDistanceCellModels(currentDistanceType: SearchDistance) -> [SettingsCellViewModel]

    func buildSortingCellModels(currentSorting: PlaceLookupSorting,
                                copyContent: SettingsSortPreferenceCopyContent) -> [SettingsCellViewModel]
}

class SettingsCellViewModelBuilder {

    private typealias SearchDistanceType = SearchDistanceTypeProtocol & CaseIterable & Equatable

    private let actionSubscriber: AnySubscriber<SearchPreferencesAction, Never>
    private let measurementFormatter: MeasurementFormatterProtocol

    init(actionSubscriber: AnySubscriber<SearchPreferencesAction, Never>,
         measurementFormatter: MeasurementFormatterProtocol) {
        self.actionSubscriber = actionSubscriber
        self.measurementFormatter = measurementFormatter
    }

}

extension SettingsCellViewModelBuilder: SettingsCellViewModelBuilderProtocol {

    func buildDistanceCellModels(currentDistanceType: SearchDistance) -> [SettingsCellViewModel] {
        switch currentDistanceType {
        case let .imperial(currentlySelectedDistance):
            return buildModels(currentlySelectedDistance: currentlySelectedDistance) { .imperial($0) }
        case let .metric(currentlySelectedDistance):
            return buildModels(currentlySelectedDistance: currentlySelectedDistance) { .metric($0) }
        }
    }

    private func buildModels<T: SearchDistanceType>(currentlySelectedDistance: T,
                                                    distanceBlock: (T) -> SearchDistance) -> [SettingsCellViewModel] {
        return T.allCases.map { distance in
            SettingsCellViewModel(title: measurementFormatter.string(from: distance.measurement),
                                  isSelected: currentlySelectedDistance == distance,
                                  actionSubscriber: actionSubscriber,
                                  action: .setDistance(distanceBlock(distance)))
        }
    }

    func buildSortingCellModels(currentSorting: PlaceLookupSorting,
                                copyContent: SettingsSortPreferenceCopyContent) -> [SettingsCellViewModel] {
        return PlaceLookupSorting.allCases.map { sorting in
            SettingsCellViewModel(title: copyContent.title(sorting),
                                  isSelected: currentSorting == sorting,
                                  actionSubscriber: actionSubscriber,
                                  action: .setSorting(sorting))
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
