//
//  AboutAppView.swift
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

struct AboutAppView: View {

    private let props: AboutAppViewProps

    init(props: AboutAppViewProps) {
        self.props = props
    }

    var body: some View {
        VStack {
            Spacer()
                .frame(height: 8)

            RoundedRectangle(cornerRadius: 4, style: .continuous)
                .frame(width: 32, height: 4)

            Spacer()
                .frame(height: 120)

            StaticInfoView(props: props.props)

            Spacer()
        }
    }

}

#if DEBUG

// swiftlint:disable force_try
#Preview {
    let appColorings = AppColorings.defaultColorings

    return AboutAppView(
        props: AboutAppViewProps(
            colorings: appColorings.aboutApp,
            appDisplayName: try! NonEmptyString("PlacesFinder"),
            appVersion: try! NonEmptyString("1.2.3")
        )
    )
}
// swiftlint:enable force_try

#endif
