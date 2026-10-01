//
//  SearchLookupProps.swift
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

import Foundation
import Shared
import SwiftDux

struct SearchLookupProps: Equatable {
    let inputProps: SearchInputProps
    let child: SearchLookupChild
}

// sourcery: AutoMockable
protocol SearchLookupPropsBuilderProtocol {
    func buildProps(searchActivityState: Search.ActivityState,
                    appCopyContent: AppCopyContent,
                    appSkin: AppSkin,
                    locationUpdateRequestBlock: @escaping LocationUpdateRequestBlock) -> SearchLookupProps
}

class SearchLookupPropsBuilder: SearchLookupPropsBuilderProtocol {

    private let inputPropsBuilder: SearchInputPropsBuilderProtocol
    private let childBuilder: SearchLookupChildBuilderProtocol

    init(inputPropsBuilder: SearchInputPropsBuilderProtocol,
         childBuilder: SearchLookupChildBuilderProtocol) {
        self.inputPropsBuilder = inputPropsBuilder
        self.childBuilder = childBuilder
    }

    func buildProps(searchActivityState: Search.ActivityState,
                    appCopyContent: AppCopyContent,
                    appSkin: AppSkin,
                    locationUpdateRequestBlock: @escaping LocationUpdateRequestBlock) -> SearchLookupProps {
        let inputProps = inputPropsBuilder.buildProps(
            inputParams: searchActivityState.inputParams,
            copyContent: appCopyContent.searchInput
        )

        let child = childBuilder.buildChild(loadState: searchActivityState.loadState,
                                            appCopyContent: appCopyContent,
                                            appSkin: appSkin,
                                            locationUpdateRequestBlock: locationUpdateRequestBlock)

        return SearchLookupProps(inputProps: inputProps,
                                 child: child)
    }

}
