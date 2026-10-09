//
//  SearchResultProps.swift
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

struct SearchResultProps: Equatable {
    let cellProps: SearchResultCellProps
    let detailEntityAction: IgnoredEquatable<Search.Action>

    init(cellProps: SearchResultCellProps,
         detailEntityAction: Search.Action) {
        self.cellProps = cellProps
        self.detailEntityAction = IgnoredEquatable(detailEntityAction)
    }
}

// MARK: SearchResultPropsBuilder

// sourcery: AutoMockable
protocol SearchResultPropsBuilderProtocol {
    func buildProps(model: SearchEntityModel,
                    colorings: SearchResultsViewColorings) -> SearchResultProps
}

class SearchResultPropsBuilder: SearchResultPropsBuilderProtocol {

    private let actionPrism: SearchDetailsActionPrismProtocol
    private let resultCellPropsBuilder: SearchResultCellPropsBuilderProtocol

    init(actionPrism: SearchDetailsActionPrismProtocol,
         resultCellPropsBuilder: SearchResultCellPropsBuilderProtocol) {
        self.actionPrism = actionPrism
        self.resultCellPropsBuilder = resultCellPropsBuilder
    }

    func buildProps(model: SearchEntityModel,
                    colorings: SearchResultsViewColorings) -> SearchResultProps {
        let cellProps = resultCellPropsBuilder.buildProps(model: model,
                                                          colorings: colorings)
        let detailEntityAction = actionPrism.detailEntityAction(model)

        return SearchResultProps(cellProps: cellProps,
                                 detailEntityAction: .searchActivity(detailEntityAction))
    }

}
