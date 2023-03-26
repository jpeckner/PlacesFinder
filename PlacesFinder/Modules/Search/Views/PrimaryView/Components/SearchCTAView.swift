//
//  SearchCTAView.swift
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

import Shared
import SwiftUI

struct SearchCTAView: View {

    @ObservedObject var viewModel: ValueObservable<SearchCTAViewModel>

    init(viewModel: SearchCTAViewModel) {
        self.viewModel = ValueObservable(viewModel)
    }

    var body: some View {
        VStack {
            StaticInfoView(viewModel: viewModel.value.infoViewModel)

            if let action = viewModel.value.ctaBlock {
                Button(
                    viewModel.value.ctaTitle,
                    action: action.value
                )
                .modifier(
                    textStyleClass: .ctaButton,
                    textColoring: viewModel.value.infoViewModel.colorings.ctaTextColoring
                )
            }
        }
    }

}

#if DEBUG

struct SearchCTAView_Previews: PreviewProvider {

    static var previews: some View {
        // swiftlint:disable:next force_try
        let appCopyContent = AppCopyContent(displayName: try! NonEmptyString("stub"))
        let appColorings = AppColorings.defaultColorings

        return SearchCTAView(
            // swiftlint:disable:next trailing_closure
            viewModel: appCopyContent.searchRetry.ctaViewModel(
                colorings: appColorings.searchCTA,
                ctaBlock: {}
            )
        )
    }

}

#endif
