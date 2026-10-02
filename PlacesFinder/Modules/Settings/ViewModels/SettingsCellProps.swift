//
//  SettingsCellProps.swift
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

struct SettingsCellProps: Equatable {
    let title: String
    let isSelected: Bool
    let colorings: SettingsCellColorings
    private let actionSubscriber: IgnoredEquatable<AnySubscriber<SearchPreferencesAction, Never>>
    private let action: IgnoredEquatable<SearchPreferencesAction>

    init(title: String,
         isSelected: Bool,
         colorings: SettingsCellColorings,
         actionSubscriber: AnySubscriber<SearchPreferencesAction, Never>,
         action: SearchPreferencesAction) {
        self.title = title
        self.isSelected = isSelected
        self.colorings = colorings
        self.actionSubscriber = IgnoredEquatable(actionSubscriber)
        self.action = IgnoredEquatable(action)
    }
}

extension SettingsCellProps: Identifiable {

    var id: String { title }

}

extension SettingsCellProps {

    func dispatchAction() {
        _ = actionSubscriber.value.receive(action.value)
    }

}

// MARK: SettingsCellPropsBuilder

// sourcery: AutoMockable
protocol SettingsCellPropsBuilderProtocol {
    func buildDistanceCellProps(currentDistanceType: SearchDistance,
                                colorings: SettingsCellColorings) -> [SettingsCellProps]

    func buildSortingCellProps(currentSorting: PlaceLookupSorting,
                               copyContent: SettingsSortPreferenceCopyContent,
                               colorings: SettingsCellColorings) -> [SettingsCellProps]
}

class SettingsCellPropsBuilder {

    private typealias SearchDistanceType = SearchDistanceTypeProtocol & CaseIterable & Equatable

    private let actionSubscriber: AnySubscriber<SearchPreferencesAction, Never>
    private let measurementFormatter: MeasurementFormatterProtocol

    init(actionSubscriber: AnySubscriber<SearchPreferencesAction, Never>,
         measurementFormatter: MeasurementFormatterProtocol) {
        self.actionSubscriber = actionSubscriber
        self.measurementFormatter = measurementFormatter
    }

}

extension SettingsCellPropsBuilder: SettingsCellPropsBuilderProtocol {

    func buildDistanceCellProps(currentDistanceType: SearchDistance,
                                colorings: SettingsCellColorings) -> [SettingsCellProps] {
        switch currentDistanceType {
        case let .imperial(currentlySelectedDistance):
            return buildProps(
                currentlySelectedDistance: currentlySelectedDistance,
                colorings: colorings
            ) {
                .imperial($0)
            }

        case let .metric(currentlySelectedDistance):
            return buildProps(
                currentlySelectedDistance: currentlySelectedDistance,
                colorings: colorings
            ) {
                .metric($0)
            }
        }
    }

    private func buildProps<T: SearchDistanceType>(currentlySelectedDistance: T,
                                                   colorings: SettingsCellColorings,
                                                   distanceBlock: (T) -> SearchDistance) -> [SettingsCellProps] {
        return T.allCases.map { distance in
            SettingsCellProps(title: measurementFormatter.string(from: distance.measurement),
                              isSelected: currentlySelectedDistance == distance,
                              colorings: colorings,
                              actionSubscriber: actionSubscriber,
                              action: .setDistance(distanceBlock(distance)))
        }
    }

    func buildSortingCellProps(currentSorting: PlaceLookupSorting,
                               copyContent: SettingsSortPreferenceCopyContent,
                               colorings: SettingsCellColorings) -> [SettingsCellProps] {
        return PlaceLookupSorting.allCases.map { sorting in
            SettingsCellProps(title: copyContent.title(sorting),
                              isSelected: currentSorting == sorting,
                              colorings: colorings,
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
