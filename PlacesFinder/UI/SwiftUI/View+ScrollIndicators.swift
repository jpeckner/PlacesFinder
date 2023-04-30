//
//  View+ScrollIndicators.swift
//  PlacesFinder
//
//  Copyright (c) 2023 Justin Peckner
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

import SwiftUI

// NOTE: once the minimum iOS version for this app is set to iOS 16, delete `ListVerticalScrollIndicatorsModifier` and
// `func showVerticalScrollIndicators()` , and use `scrollIndicators()` directly instead

@available(iOS 16, *)
struct ListVerticalScrollIndicatorsModifier: ViewModifier {
    let showsVerticalScrollIndicators: Bool

    func body(content: Content) -> some View {
        content
            .scrollIndicators(
                showsVerticalScrollIndicators ? .visible : .hidden,
                axes: [.vertical]
            )
    }
}

// Need to extend `View` itself; extending `List` results in build errors due to the type of `some View` not being known
extension View {

    @ViewBuilder
    func showVerticalScrollIndicators(_ showIndicators: Bool) -> some View {
        if #available(iOS 16, *) {
            self.modifier(ListVerticalScrollIndicatorsModifier(showsVerticalScrollIndicators: showIndicators))
        } else {
            self
        }
    }

}
