//
//  SettingsViewSUI.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Shared
import SwiftDux
import SwiftUI

@available(iOS 13.0.0, *)
struct SettingsViewSUI: View {

    @ObservedObject private var viewModel: SettingsViewModelObservable
    private let store: DispatchingStoreProtocol

    init(viewModel: SettingsViewModelObservable,
         store: DispatchingStoreProtocol) {
        self._viewModel = ObservedObject(wrappedValue: viewModel)
        self.store = store
    }

    var body: some View {
        List {
            ForEach(viewModel.viewModel.sections) { section in
                Section(header: Text(section.title)) {
                    ForEach(section.cells) { cellViewModel in
                        SettingsCell(viewModel: cellViewModel)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                self.store.dispatch(cellViewModel.action)
                            }
                    }
                }
            }
        }
        .listStyle(GroupedListStyle())
    }

}

@available(iOS 13.0.0, *)
private struct SettingsCell: View {

    private enum Constants {
        static let image = #imageLiteral(resourceName: "checkmark").withRenderingMode(.alwaysTemplate)
        static let imageHeight: CGFloat = 24.0
    }

    var viewModel: SettingsCellViewModel

    var body: some View {
        HStack {
            Text(viewModel.title)

            Spacer()

            if viewModel.hasCheckmark {
                Image(uiImage: Constants.image)
                    .resizable()
                    .frame(width: Constants.imageHeight * Constants.image.widthToHeightRatio,
                           height: Constants.imageHeight)
                    .aspectRatio(contentMode: .fit)
                    .colorMultiply(Color(.label))
            }
        }
    }

}
