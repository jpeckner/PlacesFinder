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
    private let actionSubscriber: IgnoredEquatable<AnySubscriber<AppAction, Never>>
    private let action: IgnoredEquatable<AppAction>

    init(title: String,
         isSelected: Bool,
         actionSubscriber: AnySubscriber<AppAction, Never>,
         action: AppAction) {
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

protocol SettingsCellViewModelBuilderProtocol: AutoMockable {
    func buildDistanceCellModels(_ distance: SearchDistance) -> [SettingsCellViewModel]

    func buildSortingCellModels(_ sorting: PlaceLookupSorting,
                                copyContent: SettingsSortPreferenceCopyContent) -> [SettingsCellViewModel]
}

class SettingsCellViewModelBuilder {

    private typealias SearchDistanceType = SearchDistanceTypeProtocol & CaseIterable & Equatable

    private let actionSubscriber: AnySubscriber<AppAction, Never>
    private let measurementFormatter: MeasurementFormatterProtocol

    init(actionSubscriber: AnySubscriber<AppAction, Never>,
         measurementFormatter: MeasurementFormatterProtocol) {
        self.actionSubscriber = actionSubscriber
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
        return T.allCases.map {
            SettingsCellViewModel(title: measurementFormatter.string(from: $0.measurement),
                                  isSelected: currentlySelectedDistance == $0,
                                  actionSubscriber: actionSubscriber,
                                  action: AppAction.searchPreferences(.setDistance(distanceBlock($0))))
        }
    }

    func buildSortingCellModels(_ sorting: PlaceLookupSorting,
                                copyContent: SettingsSortPreferenceCopyContent) -> [SettingsCellViewModel] {
        return PlaceLookupSorting.allCases.map {
            SettingsCellViewModel(title: copyContent.title($0),
                                  isSelected: sorting == $0,
                                  actionSubscriber: actionSubscriber,
                                  action: AppAction.searchPreferences(.setSorting($0)))
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
