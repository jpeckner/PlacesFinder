//
//  SearchNoInternetViewController.swift
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

// MARK: - SearchNoInternetView

struct SearchNoInternetView: View {

    typealias ViewModel = SinglePropsViewModel<SearchNoInternetViewProps>

    private let viewModel: ViewModel

    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        StaticInfoView(props: viewModel.props.messageViewProps.props)
    }

}

// MARK: - SearchNoInternetViewController

class SearchNoInternetViewController: UIHostingController<SearchNoInternetView>,
                                      SearchPrimaryViewControllerProtocol {

    private let viewModel: SearchNoInternetView.ViewModel

    init(props: SearchNoInternetViewProps) {
        let viewModel = SearchNoInternetView.ViewModel(props: props)
        self.viewModel = viewModel

        super.init(rootView: SearchNoInternetView(viewModel: viewModel))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension SearchNoInternetViewController {

    func configure(props: SearchNoInternetViewProps) {
        viewModel.props = props
    }

}
