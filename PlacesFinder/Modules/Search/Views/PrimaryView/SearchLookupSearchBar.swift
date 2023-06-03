//
//  SearchLookupSearchBar.swift
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

import Shared
import SwiftUI

// SwiftUI's `.searchable()` view modifier currently (as of May 2023) doesn't appear to have all of the capabilities
// needed by PlacesFinder, such as detecting when editing has begun or ended. Rather than creating a custom SwiftUI
// component with all of the capabilities of `UISearchBar`, `SearchLookupSearchBar` is a great example of using
// `UIViewRepresentable`.
struct SearchLookupSearchBar: UIViewRepresentable {

    @ObservedObject var viewModel: ValueObservable<SearchInputContentViewModel>

    private let searchBar: UISearchBar

    init(viewModel: SearchInputContentViewModel,
         searchBar: UISearchBar) {
        self.viewModel = ValueObservable(viewModel)
        self.searchBar = searchBar
    }

    func makeUIView(context: Context) -> UISearchBar {
        searchBar
    }

    func updateUIView(_ searchBar: UISearchBar, context: Context) {
        searchBar.text = viewModel.value.keywords?.value
        searchBar.placeholder = viewModel.value.placeholder

        // This is a bit of a hack, but doing an async dispatch is necessary to prevent "AttributeGraph: cycle detected"
        // warnings from arising here. This is likely a quirk of using UIViewRepresentable.
        // More info: https://stackoverflow.com/a/63142687/1342984
        DispatchQueue.main.async {
            searchBar.safelySetFirstResponder(makeFirstResponder: viewModel.value.barState.isEditing)
        }
    }

}
