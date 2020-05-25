//
//  SearchLookupViewSUI.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2020 Justin Peckner. All rights reserved.
//

import Shared
import SwiftUI

struct SearchLookupViewSUI: UIViewRepresentable {

    @ObservedObject private var viewModel: ValueObservable<SearchLookupViewModel>
    @ObservedObject private var appSkin: ValueObservable<AppSkin>
    private let childViewContainer: ChildViewContainer

    init(viewModel: SearchLookupViewModel,
         appSkin: AppSkin) {
        self.viewModel = ValueObservable(viewModel)
        self.appSkin = ValueObservable(appSkin)
        self.childViewContainer = ChildViewContainer()
    }

    func makeUIView(context: Context) -> SearchLookupView {
        let lookupView = SearchLookupView(inputViewModel: viewModel.value.searchInputViewModel,
                                          searchInputColorings: appSkin.value.colorings.searchInput)
        childViewContainer.setChildView(lookupView,
                                        viewModel: viewModel.value,
                                        appSkin: appSkin.value)
        return lookupView
    }

    func updateUIView(_ lookupView: SearchLookupView, context: Context) {
        childViewContainer.setChildView(lookupView,
                                        viewModel: viewModel.value,
                                        appSkin: appSkin.value)
        lookupView.configure(viewModel.value.searchInputViewModel,
                             colorings: appSkin.value.colorings.searchInput)
    }

}

extension SearchLookupViewSUI {

    func configure(_ viewModel: SearchLookupViewModel,
                   appSkin: AppSkin) {
        self.viewModel.value = viewModel
        self.appSkin.value = appSkin
    }

}

private enum ChildView {
    case instructions(UIHostingController<SearchInstructionsViewSUI>)
    case progress(UIHostingController<SearchProgressViewSUI>)
    case results(UIHostingController<SearchResultsWrapperSUI>)
    case noResults(UIHostingController<SearchMessageViewSUI>)
    case failure(UIHostingController<SearchCTAViewSUI>)
}

private class ChildViewContainer {

    private var currentChildView: ChildView?

    // swiftlint:disable function_body_length
    func setChildView(_ lookupView: SearchLookupView,
                      viewModel: SearchLookupViewModel,
                      appSkin: AppSkin) {
        switch viewModel.child {
        case let .instructions(viewModel):
            guard case let .instructions(existingController) = currentChildView else {
                let controller = buildInstructionsHostingController(viewModel,
                                                                    colorings: appSkin.colorings.standard)
                currentChildView = .instructions(controller)
                lookupView.setChildView(controller.view)
                return
            }

            existingController.rootView.configure(viewModel,
                                                  colorings: appSkin.colorings.standard)
        case .progress:
            guard case let .progress(existingController) = currentChildView else {
                let controller = buildProgressHostingController(appSkin.colorings.searchProgress)
                currentChildView = .progress(controller)
                lookupView.setChildView(controller.view)
                return
            }

            existingController.rootView.configure(appSkin.colorings.searchProgress)
        case let .results(viewModel):
            guard case let .results(existingController) = currentChildView else {
                let controller = buildResultsHostingController(viewModel,
                                                               colorings: appSkin.colorings.searchResults)
                currentChildView = .results(controller)
                lookupView.setChildView(controller.view)
                return
            }

            existingController.rootView.configure(viewModel,
                                                  colorings: appSkin.colorings.searchResults)
        case let .noResults(viewModel):
            guard case let .noResults(existingController) = currentChildView else {
                let controller = buildMessageHostingController(viewModel,
                                                               colorings: appSkin.colorings.standard)
                currentChildView = .noResults(controller)
                lookupView.setChildView(controller.view)
                return
            }

            existingController.rootView.configure(viewModel.messageViewModel,
                                                  colorings: appSkin.colorings.standard)
        case let .failure(viewModel):
            guard case let .failure(existingController) = currentChildView else {
                let controller = buildCTAHostingController(viewModel,
                                                           colorings: appSkin.colorings.searchCTA)
                currentChildView = .failure(controller)
                lookupView.setChildView(controller.view)
                return
            }

            existingController.rootView.configure(viewModel.ctaViewModel,
                                                  colorings: appSkin.colorings.searchCTA)
        }
    }
    // swiftlint:enable function_body_length

}

private extension ChildViewContainer {

    func buildInstructionsHostingController(
        _ viewModel: SearchInstructionsViewModel,
        colorings: AppStandardColorings
    ) -> UIHostingController<SearchInstructionsViewSUI> {
        let view = SearchInstructionsViewSUI(viewModel: viewModel,
                                             colorings: colorings)
        return UIHostingController(rootView: view)
    }

    func buildProgressHostingController(
        _ colorings: SearchProgressViewColorings
    ) -> UIHostingController<SearchProgressViewSUI> {
        let view = SearchProgressViewSUI(colorings: colorings)
        return UIHostingController(rootView: view)
    }

    func buildResultsHostingController(
        _ viewModel: SearchResultsViewModel,
        colorings: SearchResultsViewColorings
    ) -> UIHostingController<SearchResultsWrapperSUI> {
        let view = SearchResultsWrapperSUI(viewModel: viewModel,
                                           colorings: colorings)
        return UIHostingController(rootView: view)
    }

    func buildMessageHostingController(
        _ viewModel: SearchNoResultsFoundViewModel,
        colorings: AppStandardColorings
    ) -> UIHostingController<SearchMessageViewSUI> {
        let view = SearchMessageViewSUI(viewModel: viewModel.messageViewModel,
                                        colorings: colorings)
        return UIHostingController(rootView: view)
    }

    func buildCTAHostingController(
        _ viewModel: SearchRetryViewModel,
        colorings: SearchCTAViewColorings
    ) -> UIHostingController<SearchCTAViewSUI> {
        let view = SearchCTAViewSUI(viewModel: viewModel.ctaViewModel,
                                    colorings: colorings)
        return UIHostingController(rootView: view)
    }

}
