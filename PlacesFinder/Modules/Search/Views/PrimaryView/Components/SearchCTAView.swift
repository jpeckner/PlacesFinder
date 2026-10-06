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

typealias SearchCTABlock = () -> Void

struct SearchCTAView: View {

    private let props: SearchCTAViewProps
    private let ctaBlock: SearchCTABlock?

    init(
        props: SearchCTAViewProps,
        ctaBlock: SearchCTABlock?
    ) {
        self.props = props
        self.ctaBlock = ctaBlock
    }

    var body: some View {
        ScrollView(.vertical) {
            StaticInfoView(props: props.props)
                .ignoresSafeArea(.keyboard, edges: .bottom)

            if let ctaBlock {
                Button(
                    props.ctaTitle,
                    action: ctaBlock
                )
                .modifier(
                    textStyleClass: .ctaButton,
                    textColoring: props.props.colorings.ctaTextColoring
                )
            }
        }
        .centeredWhenFitting()
    }

}

#if DEBUG

#Preview {
    // swiftlint:disable:next force_try
    let appCopyContent = AppCopyContent(displayName: try! NonEmptyString("stub"))
    let appColorings = AppColorings.defaultColorings

    return SearchCTAView(
        props: appCopyContent.searchRetry.ctaViewProps(colorings: appColorings.searchCTA)
    ) {}
}

#endif
