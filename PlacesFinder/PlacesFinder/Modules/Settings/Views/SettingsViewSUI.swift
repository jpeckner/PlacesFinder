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
    @ObservedObject var colorings: ValueObservable<SettingsViewColorings>

    init(viewModel: SettingsViewModel,
         colorings: SettingsViewColorings) {
        self.viewModel = ValueObservable(value: viewModel)
        self.colorings = ValueObservable(value: colorings)
    }

    var body: some View {
        List {
            ForEach(viewModel.value.sections.value) { sectionViewModel in
                Section(header: self.header(sectionViewModel)) {
                    ForEach(sectionViewModel.cells) { cellViewModel in
                        SettingsCell(viewModel: cellViewModel,
                                     colorings: self.colorings.value.cellColorings)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            cellViewModel.dispatchAction()
                        }
                    }
                }
            }
        }
        .listStyle(GroupedListStyle())
        .background(Color(colorings.value.viewColoring.backgroundColor))
    }

    private func header(_ sectionViewModel: SettingsSectionViewModel) -> some View {
        switch sectionViewModel.headerType {
        case let .plain(viewModel):
            return AnyView(SettingsPlainSystemHeaderViewSUI(viewModel: viewModel,
                                                            colorings: colorings.value.headerColorings))
        case let .measurementSystem(viewModel):
            return AnyView(SettingsMeasurementSystemHeaderViewSUI(viewModel: viewModel,
                                                                  colorings: colorings.value.headerColorings))
        }
    }

}

@available(iOS 13.0.0, *)
extension SettingsViewSUI {

    func configure(_ viewModel: SettingsViewModel,
                   colorings: SettingsViewColorings) {
        self.viewModel.value = viewModel
        self.colorings.value = colorings
    }

}

@available(iOS 13.0.0, *)
private struct SettingsPlainSystemHeaderViewSUI: View {

    let viewModel: SettingsPlainHeaderViewModel
    let colorings: SettingsHeaderViewColorings

    var body: some View {
        Text(viewModel.title)
            .configure(.tableHeader,
                       textColoring: colorings.textColoring)
    }

}

@available(iOS 13.0.0, *)
private struct SettingsMeasurementSystemHeaderViewSUI: View {

    let viewModel: SettingsUnitsHeaderViewModel
    let colorings: SettingsHeaderViewColorings

    var body: some View {
        HStack {
            Text(viewModel.title)
                .configure(.tableHeader,
                           textColoring: colorings.textColoring)

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
            return AnyView(
                Button(action: {
                    selectionAction.value()
                }, label: {
                    Text(title)
                        .configure(.tableHeaderSelectableOption,
                                   textColoring: colorings.activeButtonTextColoring)
                })

            )
        case let .nonSelectable(title):
            return AnyView(
                Text(title)
                    .configure(.tableHeaderNonSelectableOption,
                               textColoring: colorings.textColoring)
            )
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
    let colorings: SettingsCellColorings

    var body: some View {
        HStack {
            Text(viewModel.title)
                .configure(.cellText,
                           textColoring: colorings.textColoring)

            Spacer()

            if viewModel.isSelected {
                Image(uiImage: Constants.image)
                    .resizable()
                    .frame(width: Constants.imageHeight * Constants.image.widthToHeightRatio,
                           height: Constants.imageHeight)
                    .aspectRatio(contentMode: .fit)
                    .colorMultiply(Color(colorings.checkmarkTint.color))
            }
        }
    }

}
