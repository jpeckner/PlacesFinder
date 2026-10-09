//
//  SearchRetryProps.swift
//  PlacesFinder
//
//  Copyright (c) 2019 Justin Peckner
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

import Foundation
import Shared

struct SearchRetryProps: Equatable {
    let ctaViewProps: SearchCTAViewProps
    let retryAction: IgnoredEquatable<Search.Action>

    init(ctaViewProps: SearchCTAViewProps,
         retryAction: Search.Action) {
        self.ctaViewProps = ctaViewProps
        self.retryAction = IgnoredEquatable(retryAction)
    }
}

// MARK: SearchRetryPropsBuilder

// sourcery: AutoMockable
protocol SearchRetryPropsBuilderProtocol {
    func buildProps(colorings: SearchCTAViewColorings,
                    retryAction: Search.Action) -> SearchRetryProps
}

class SearchRetryPropsBuilder: SearchRetryPropsBuilderProtocol {

    func buildProps(colorings: SearchCTAViewColorings,
                    retryAction: Search.Action) -> SearchRetryProps {
        let ctaViewProps = SearchCTAViewProps(
            props: StaticInfoViewProps(
                image: Asset.error,
                title: L10n.SearchRetry.title,
                description: L10n.SearchRetry.description,
                colorings: colorings
            ),
            ctaTitle: L10n.SearchRetry.ctaTitle
        )

        return SearchRetryProps(ctaViewProps: ctaViewProps,
                                retryAction: retryAction)
    }

}
