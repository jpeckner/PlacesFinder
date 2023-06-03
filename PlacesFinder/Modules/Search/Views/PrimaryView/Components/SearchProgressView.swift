//
//  SearchProgressView.swift
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
import SkeletonUI
import SwiftUI

struct SearchProgressView: View {

    @ObservedObject var viewModel: ValueObservable<SearchProgressViewModel>

    init(viewModel: SearchProgressViewModel) {
        self.viewModel = ValueObservable(viewModel)
    }

    var body: some View {
        SkeletonList(with: [EmptyProgressItem](), quantity: 10) { loading, _ in
            HStack {
                Rectangle()
                    .skeleton(with: loading)
                    .shape(type: .rectangle)
                    .appearance(type: appearanceType)
                    .frame(idealWidth: 64)
                    .aspectRatio(1, contentMode: .fit)
                    .cornerRadius(4)

                VStack(alignment: .leading) {
                    Text("")
                        .skeleton(with: loading)
                        .shape(type: .rectangle)
                        .appearance(type: appearanceType)
                        .cornerRadius(4)

                    HStack {
                        Rectangle()
                            .skeleton(with: loading)
                            .shape(type: .rectangle)
                            .appearance(type: appearanceType)
                            .frame(width: 120)
                            .cornerRadius(4)

                        Spacer()

                        Text("")
                            .skeleton(with: loading)
                            .shape(type: .rectangle)
                            .appearance(type: appearanceType)
                            .frame(width: 44)
                            .cornerRadius(4)
                    }
                }
            }
            .frame(height: 68)
        }
        .listStyle(PlainListStyle())
        .showVerticalScrollIndicatorsiOS16Min(false)
    }

    private var appearanceType: AppearanceType {
        .gradient(
            color: Color(viewModel.value.colorings.gradientFill.color),
            background: Color(viewModel.value.colorings.gradientBackground.color)
        )
    }

}

// MARK: - Helper components

private struct EmptyProgressItem: Identifiable {
    // swiftlint:disable:next identifier_name
    let id = UUID()
}
