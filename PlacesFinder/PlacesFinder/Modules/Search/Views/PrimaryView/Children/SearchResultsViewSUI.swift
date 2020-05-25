//
//  SearchResultsViewSUI.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2020 Justin Peckner. All rights reserved.
//

import Shared
import SwiftUI

// NOTE: SearchResultsViewSUI is unused until SwiftUI has better APIs for the following:
//   - Pre-fetching for endless scrolling (can be approximated with something like this in the meantime):
//     https://callistaenterprise.se/blogg/teknik/2020/04/20/swiftui-lists/
//   - Pull-to-refresh
//   - Collapsible search bar
//   - Hiding scroll indicators
struct SearchResultsViewSUI: View {

    @ObservedObject private var viewModel: ValueObservable<SearchResultsViewModel>
    @ObservedObject private var colorings: ValueObservable<SearchResultsViewColorings>

    init(viewModel: SearchResultsViewModel,
         colorings: SearchResultsViewColorings) {
        self.viewModel = ValueObservable(viewModel)
        self.colorings = ValueObservable(colorings)
    }

    var body: some View {
        List {
            ForEach(viewModel.value.resultViewModels.value) { resultViewModel in
                SearchResultCellSUI(cellModel: resultViewModel.cellModel,
                                    colorings: self.colorings.value)
                    .contentShape(Rectangle())
                    .listRowInsets(EdgeInsets(uniformInset: 8.0))
                    .onTapGesture {
                        resultViewModel.dispatchDetailEntityAction()
                    }
            }
        }
        .listStyle(PlainListStyle())
    }

}

private struct SearchResultCellSUI: View {

    private enum Constants {
        static let disclosureImage = #imageLiteral(resourceName: "right_arrow").withRenderingMode(.alwaysTemplate)
    }

    let cellModel: SearchResultCellModel
    let colorings: SearchResultsViewColorings

    var body: some View {
        HStack {
            DownloadedImageViewSUI(viewModel: cellModel.image)
                .frame(width: 64.0,
                       height: 64.0,
                       alignment: .leading)
                .fixedSize()
                .cornerRadius(4.0)

            VStack(alignment: .leading) {
                Text(cellModel.name.value)
                    .configure(.cellText,
                               textColoring: colorings.bodyTextColoring)

                HStack {
                    Image(uiImage: cellModel.ratingsAverage.starsImage)

                    cellModel.pricing.map {
                        Text($0)
                            .configure(.pricingLabel,
                                       textColoring: colorings.bodyTextColoring)
                    }
                }
            }

            Spacer()

            Image(uiImage: Constants.disclosureImage)
                .resizable()
                .frame(height: 24.0,
                       widthToHeightRatio: Constants.disclosureImage.widthToHeightRatio)
                .cornerRadius(4.0)
                .colorMultiply(Color(colorings.disclosureArrowTint.color))
        }
    }

}

#if DEBUG

// swiftlint:disable force_try
// swiftlint:disable force_unwrapping
struct SearchResultsViewSUI_Previews: PreviewProvider {

    static var previews: some View {
        Group {
            SearchResultsViewSUI(viewModel: stubViewModel,
                                 colorings: AppColorings.defaultColorings.searchResults)
                .previewDisplayName("iPhone SE")

            SearchResultsViewSUI(viewModel: stubViewModel,
                                 colorings: AppColorings.defaultColorings.searchResults)
                .previewDisplayName("iPhone 11 Pro Max")
        }
    }

    private static var stubViewModel: SearchResultsViewModel {
        let store = StubDispatchingStore()

        return SearchResultsViewModel(
            resultViewModels: NonEmptyArray<SearchResultViewModel>(with:
                SearchResultViewModel(
                    id: try! NonEmptyString("stubID_0"),
                    cellModel: SearchResultCellModel(
                        name: try! NonEmptyString("My Favorite Restaurant"),
                        ratingsAverage: .threeAndAHalf,
                        pricing: "$$$",
                        image: DownloadedImageViewModel(url: URL(string: "https://picsum.photos/200")!)
                    ),
                    store: store,
                    detailEntityAction: StubAction.genericAction
                )
            ),
            store: store,
            refreshAction: StubAction.genericAction,
            nextRequestAction: nil
        )
    }

}
// swiftlint:enable force_try
// swiftlint:enable force_unwrapping

#endif
