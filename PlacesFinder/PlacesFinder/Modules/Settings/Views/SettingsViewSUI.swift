//
//  SettingsViewSUI.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Shared
import SwiftUI

@available(iOS 13.0.0, *)
struct SettingsViewSUI: View {

    @ObservedObject var viewModel: ValueObservable<SettingsViewModel>

    init(viewModel: SettingsViewModel) {
        self.viewModel = ValueObservable(value: viewModel)
    }

    var body: some View {
        List {
            ForEach(viewModel.value.sections.value) { sectionViewModel in
                Section(header: self.header(sectionViewModel)) {
                    ForEach(sectionViewModel.cells) { cellViewModel in
                        SettingsCell(viewModel: cellViewModel)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                cellViewModel.dispatchAction()
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
            return AnyView(SettingsMeasurementSystemHeaderViewSUI(viewModel: viewModel))
        }
    }

}

@available(iOS 13.0.0, *)
private struct SettingsMeasurementSystemHeaderViewSUI: View {

    let viewModel: SettingsUnitsHeaderViewModel

    var body: some View {
        HStack {
            Text(viewModel.title)

            Spacer()

            HStack {
                ForEach(0..<viewModel.systemOptions.count, id: \.self) { index -> AnyView in
                    AnyView(Group {
                        if index > 0 {
                            AnyView(Text("|"))
                        }

                        self.systemOptionElement(index: index)
                    })
                }
            }
        }
    }

    private func systemOptionElement(index: Int) -> some View {
        switch self.viewModel.systemOptions[index] {
        case let .selectable(title, selectionAction):
            return AnyView(Button(title) {
                selectionAction.value()
            })
        case let .nonSelectable(title):
            return AnyView(Text(title))
        }
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

            if viewModel.isSelected {
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
