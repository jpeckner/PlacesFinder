//
//  SearchResultsViewProps.swift
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

import Shared
import SwiftDux

struct SearchResultsViewProps: Equatable {
    let resultProps: NonEmptyArray<SearchResultProps>
    let refreshAction: IgnoredEquatable<Search.Action>
    let nextRequestAction: IgnoredEquatable<SingleReadBox<Search.Action>>

    init(resultProps: NonEmptyArray<SearchResultProps>,
         refreshAction: Search.Action,
         nextRequestAction: Search.Action?) {
        self.resultProps = resultProps
        self.refreshAction = IgnoredEquatable(refreshAction)
        self.nextRequestAction = IgnoredEquatable(SingleReadBox(nextRequestAction))
    }
}

// MARK: SearchResultsViewPropsBuilder

// sourcery: AutoMockable
protocol SearchResultsViewPropsBuilderProtocol {
    // swiftlint:disable:next function_parameter_count
    func buildProps(submittedParams: SearchParams,
                    allEntities: NonEmptyArray<SearchEntityModel>,
                    colorings: SearchResultsViewColorings,
                    numPagesReceived: Int,
                    tokenContainer: PlaceLookupTokenAttemptsContainer?,
                    locationUpdateRequestBlock: @escaping LocationUpdateRequestBlock) -> SearchResultsViewProps
}

class SearchResultsViewPropsBuilder: SearchResultsViewPropsBuilderProtocol {

    private let actionPrism: SearchActivityActionPrismProtocol
    private let resultPropsBuilder: SearchResultPropsBuilderProtocol

    init(actionPrism: SearchActivityActionPrismProtocol,
         resultPropsBuilder: SearchResultPropsBuilderProtocol) {
        self.actionPrism = actionPrism
        self.resultPropsBuilder = resultPropsBuilder
    }

    // swiftlint:disable:next function_parameter_count
    func buildProps(submittedParams: SearchParams,
                    allEntities: NonEmptyArray<SearchEntityModel>,
                    colorings: SearchResultsViewColorings,
                    numPagesReceived: Int,
                    tokenContainer: PlaceLookupTokenAttemptsContainer?,
                    locationUpdateRequestBlock: @escaping LocationUpdateRequestBlock) -> SearchResultsViewProps {
        let resultProps: NonEmptyArray<SearchResultProps> = allEntities.withTransformation {
            resultPropsBuilder.buildProps(model: $0,
                                          colorings: colorings)
        }

        let refreshAction = actionPrism.initialRequestAction(searchParams: submittedParams,
                                                             locationUpdateRequestBlock: locationUpdateRequestBlock)

        let nextRequestAction = tokenContainer.flatMap {
            try? actionPrism.subsequentRequestAction(searchParams: submittedParams,
                                                     allEntities: allEntities,
                                                     numPagesReceived: numPagesReceived,
                                                     tokenContainer: $0)
        }

        return SearchResultsViewProps(resultProps: resultProps,
                                      refreshAction: .searchActivity(refreshAction),
                                      nextRequestAction: nextRequestAction.map { .searchActivity($0) })
    }

}
