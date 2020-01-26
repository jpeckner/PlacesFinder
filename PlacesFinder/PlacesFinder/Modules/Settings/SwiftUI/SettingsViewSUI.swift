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
            ForEach(viewModel.viewModel.sections.value) { sectionViewModel in
                Section(header: self.header(sectionViewModel)) {
                    ForEach(sectionViewModel.cells) { cellViewModel in
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
        .padding(.top, 20.0)
    }

    private func header(_ sectionViewModel: SettingsSectionViewModel) -> some View {
        switch sectionViewModel.headerType {
        case let .plain(viewModel):
            return AnyView(Text(viewModel.title))
        case let .measurementSystem(viewModel):
            return AnyView(SettingsMeasurementSystemHeaderViewSUI(viewModel: viewModel,
                                                                  store: store))
        }
    }

}

@available(iOS 13.0.0, *)
private struct SettingsMeasurementSystemHeaderViewSUI: View {

    let viewModel: SettingsMeasurementSystemHeaderViewModel
    let store: DispatchingStoreProtocol

    var body: some View {
        HStack {
            Text(viewModel.title)

            Spacer()

            measurementSystemStack
        }
    }

    private var measurementSystemStack: some View {
        HStack {
            ForEach(0..<viewModel.systemOptions.count) { idx -> AnyView in
                switch self.viewModel.systemOptions[idx] {
                case let .selectable(title, selectionAction):
                    return AnyView(Group {
                        if idx > 0 {
                            self.delimeter
                        }

                        AnyView(Button(title) {
                            self.store.dispatch(selectionAction)
                        })
                    })
                case let .nonSelectable(title):
                    return AnyView(Group {
                        if idx > 0 {
                            self.delimeter
                        }

                        AnyView(Text(title))
                    })
                }
            }
        }
    }

    private var delimeter: AnyView {
        return AnyView(Text("|"))
    }

}

@available(iOS 13.0.0, *)
private struct SettingsCell: View {

    private enum Constants {
        static let image = #imageLiteral(resourceName: "checkmark").withRenderingMode(.alwaysTemplate)
        static let imageHeight: CGFloat = 24.0
    }

    let viewModel: SettingsCellViewModel

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
