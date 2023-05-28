//
//  SettingsChildView.swift
//  PlacesFinder
//
//  Copyright (c) 2022 Justin Peckner
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

struct SettingsChildView: View {

    private let viewModel: SettingsChildViewModel

    init(viewModel: SettingsChildViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack(spacing: 16) {
            StaticInfoView(viewModel: viewModel.infoViewModel)

            Button(
                viewModel.ctaTitle,
                action: viewModel.ctaBlock
            )
            .modifier(
                textStyleClass: .ctaButton,
                textColoring: viewModel.infoViewModel.colorings.ctaTextColoring
            )

            Spacer()
                .frame(height: 120)
        }
    }

}

#if DEBUG

struct SettingsChildView_Previews: PreviewProvider {

    static var previews: some View {
        // swiftlint:disable:next force_try
        let appCopyContent = AppCopyContent(displayName: try! NonEmptyString("stub"))
        let appColorings = AppColorings.defaultColorings

        return SettingsChildView(
            // swiftlint:disable:next trailing_closure
            viewModel: SettingsChildViewModel(
                infoViewModel: appCopyContent.settingsChildView.staticInfoViewModel(
                    colorings: appColorings.settingsChild
                ),
                ctaTitle: "Dismiss",
                ctaBlock: {}
            )
        )
    }

}

#endif
