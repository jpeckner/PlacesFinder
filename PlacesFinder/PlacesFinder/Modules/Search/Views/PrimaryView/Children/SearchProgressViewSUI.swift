//
//  SearchProgressViewSUI.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2020 Justin Peckner. All rights reserved.
//

import Shared
import SkeletonUI
import SwiftUI

struct SearchProgressViewSUI: View {

    private struct ListViewModel: Identifiable {
        let id: Int
    }

    @ObservedObject private var colorings: ValueObservable<SearchProgressViewColorings>
    private let viewModels: [ListViewModel]

    init(colorings: SearchProgressViewColorings) {
        self.colorings = ValueObservable(colorings)
        self.viewModels = (0..<10).map { ListViewModel(id: $0) }
    }

    var body: some View {
        SkeletonList(with: viewModels, quantity: viewModels.count) { _, _ in
            SearchProgressCellSUI(colorings: self.colorings.value)
        }
        .listRowInsets(EdgeInsets(uniformInset: 8.0))
    }

}

extension SearchProgressViewSUI {

    func configure(_ colorings: SearchProgressViewColorings) {
        self.colorings.value = colorings
    }

}

private struct SearchProgressCellSUI: View {

    let colorings: SearchProgressViewColorings

    var body: some View {
        HStack(alignment: .center) {
            animatedView(Color(.clear))
                .frame(width: 64.0,
                       height: 64.0)
                .cornerRadius(4.0)

            GeometryReader { metrics in
                VStack(alignment: .leading) {
                    self.animatedView(Color(.clear))
                        .frame(width: metrics.size.width * 0.9,
                               height: 24.0)

                    Spacer()

                    self.animatedView(Color(.clear))
                        .frame(width: metrics.size.width * 0.5,
                               height: 24.0)
                }

                Spacer()
            }
        }
    }

    private func animatedView<TView: View>(_ view: TView) -> ModifiedContent<TView, SkeletonModifier> {
        return view
            .skeleton(with: true)
            .shape(type: .rectangle)
            .appearance(type: .gradient(.linear,
                                        color: Color(colorings.gradientFill.color),
                                        background: Color(colorings.gradientBackground.color)))
            .animation(type: .linear(delay: 0))
    }

}

#if DEBUG

struct SearchProgressViewSUI_Previews: PreviewProvider {

    static var previews: some View {
        SearchProgressViewSUI(colorings: AppColorings.defaultColorings.searchProgress)
            .previewDisplayName("iPhone SE")
    }

}

#endif
