//
//  SettingsView.swift
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

struct SettingsView: View {

    @ObservedObject var viewModel: ValueObservable<SettingsViewModel>

    init(viewModel: SettingsViewModel) {
        self.viewModel = ValueObservable(viewModel)
    }

    var body: some View {
        List {
            ForEach(viewModel.value.sections.value) { sectionViewModel in
                Section(header: header(sectionViewModel)) {
                    ForEach(sectionViewModel.cells) { cellViewModel in
                        SettingsCell(
                            viewModel: cellViewModel
                        )
                        .contentShape(Rectangle())  // Necessary for `onTapGesture` to work on the entire cell
                        .onTapGesture {
                            cellViewModel.dispatchAction()
                        }
                    }
                }
            }
        }
        .listStyle(.grouped)
        .background(Color(viewModel.value.colorings.viewColoring.backgroundColor))
        .showVerticalScrollIndicatorsiOS16Min(false)
        .scrollBounceBasedOnSizeiOS16_4Min()
    }

    private func header(_ sectionViewModel: SettingsSectionViewModel) -> some View {
        switch sectionViewModel.headerType {
        case let .plain(headerViewModel):
            return AnyView(
                SettingsPlainSystemHeaderView(
                    viewModel: headerViewModel
                )
            )
        case let .measurementSystem(headerViewModel):
            return AnyView(
                SettingsMeasurementSystemHeaderView(
                    viewModel: headerViewModel
                )
            )
        }
    }

}

// MARK: - SettingsPlainSystemHeaderView

private struct SettingsPlainSystemHeaderView: View {

    let viewModel: SettingsPlainHeaderViewModel

    var body: some View {
        Text(viewModel.title)
            .modifier(
                textStyleClass: .tableHeader,
                textColoring: viewModel.colorings.textColoring
            )
    }

}

// MARK: - SettingsMeasurementSystemHeaderView

private struct SettingsMeasurementSystemHeaderView: View {

    let viewModel: SettingsUnitsHeaderViewModel

    var body: some View {
        HStack {
            Text(viewModel.title)
                .modifier(
                    textStyleClass: .tableHeader,
                    textColoring: viewModel.colorings.textColoring
                )

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
                        .modifier(
                            textStyleClass: .tableHeaderSelectableOption,
                            textColoring: viewModel.colorings.activeButtonTextColoring
                        )
                })
            )
        case let .nonSelectable(title):
            return AnyView(
                Text(title)
                    .modifier(
                        textStyleClass: .tableHeaderNonSelectableOption,
                        textColoring: viewModel.colorings.textColoring
                    )
            )
        }
    }

}

// MARK: - SettingsCell

private struct SettingsCell: View {

    private enum Constants {
        static let image = #imageLiteral(resourceName: "checkmark").withRenderingMode(.alwaysTemplate)
        static let imageHeight: CGFloat = 24.0
    }

    let viewModel: SettingsCellViewModel

    var body: some View {
        HStack {
            Text(viewModel.title)
                .modifier(
                    textStyleClass: .cellText,
                    textColoring: viewModel.colorings.textColoring
                )

            Spacer()

            if viewModel.isSelected {
                Image(uiImage: Constants.image)
                    .resizable()
                    .frame(width: Constants.imageHeight * Constants.image.widthToHeightRatio,
                           height: Constants.imageHeight)
                    .aspectRatio(contentMode: .fit)
                    .colorMultiply(Color(viewModel.colorings.checkmarkTint.color))
            }
        }
        .listRowBackground(Color(viewModel.colorings.viewColoring.backgroundColor))
    }

}
