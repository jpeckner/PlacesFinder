//
//  SearchInstructionsView.swift
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

struct SearchInstructionsView: View {

    @ObservedObject var viewModel: ValueObservable<SearchInstructionsViewModel>

    init(viewModel: SearchInstructionsViewModel) {
        self.viewModel = ValueObservable(viewModel)
    }

    var body: some View {
        VStack {
            StaticInfoView(viewModel: viewModel.value.infoViewModel)

            HStack(spacing: .zero) {
                Text(viewModel.value.resultsSource)
                    .modifier(
                        textStyleClass: .sourceAPILabel,
                        textColoring: viewModel.value.infoViewModel.colorings.bodyTextColoring
                    )
                    // Padding is needed to align this text with image text
                    .padding([.top], 4)

                APILogoView(viewColoring: viewModel.value.infoViewModel.colorings.viewColoring)
            }
        }
    }

}

#if DEBUG

struct SearchInstructionsView_Previews: PreviewProvider {

    static var previews: some View {
        // swiftlint:disable:next force_try
        let appCopyContent = AppCopyContent(displayName: try! NonEmptyString("stub"))
        let appColorings = AppColorings.defaultColorings
        return SearchInstructionsView(
            viewModel: SearchInstructionsViewModel(
                infoViewModel: appCopyContent.searchInstructions.staticInfoViewModel(colorings: appColorings.standard),
                resultsSource: appCopyContent.searchInstructions.resultsSource
            )
        )
    }

}

#endif
