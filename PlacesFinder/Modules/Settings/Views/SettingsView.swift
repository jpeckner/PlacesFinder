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

    typealias ViewModel = SinglePropsViewModel<SettingsViewProps>

    private let viewModel: ViewModel
    private let actionTriggered: (SearchPreferencesAction) -> Void

    init(
        viewModel: ViewModel,
        actionTriggered: @escaping (SearchPreferencesAction) -> Void
    ) {
        self.viewModel = viewModel
        self.actionTriggered = actionTriggered
    }

    var body: some View {
        List {
            ForEach(viewModel.props.sections.value) { sectionProps in
                Section(header: header(sectionProps)) {
                    ForEach(sectionProps.cells) { cellProps in
                        SettingsCell(
                            props: cellProps
                        )
                        .contentShape(Rectangle())  // Necessary for `onTapGesture` to work on the entire cell
                        .onTapGesture {
                            actionTriggered(cellProps.action.value)
                        }
                    }
                }
            }
        }
        .listStyle(.grouped)
        .background(Color(viewModel.props.colorings.viewColoring.backgroundColor))
        .scrollIndicators(
            .hidden,
            axes: [.vertical]
        )
        .scrollBounceBasedOnSize()
    }

    @ViewBuilder
    private func header(_ sectionProps: SettingsSectionProps) -> some View {
        switch sectionProps.headerType {
        case let .plain(props):
            SettingsPlainSystemHeaderView(
                props: props
            )

        case let .measurementSystem(props):
            SettingsMeasurementSystemHeaderView(
                props: props,
                actionTriggered: actionTriggered
            )

        case .none:
            EmptyView()
        }
    }

}

// MARK: - SettingsPlainSystemHeaderView

private struct SettingsPlainSystemHeaderView: View {

    let props: SettingsPlainHeaderProps

    var body: some View {
        Text(props.title)
            .modifier(
                textStyleClass: .tableHeader,
                textColoring: props.colorings.textColoring
            )
    }

}

// MARK: - SettingsMeasurementSystemHeaderView

private struct SettingsMeasurementSystemHeaderView: View {

    let props: SettingsUnitsHeaderProps
    let actionTriggered: (SearchPreferencesAction) -> Void

    var body: some View {
        HStack {
            Text(props.title)
                .modifier(
                    textStyleClass: .tableHeader,
                    textColoring: props.colorings.textColoring
                )

            Spacer()

            HStack {
                ForEach(0..<props.systemOptions.count, id: \.self) { index in
                    Group {
                        if index > 0 {
                            Text("|")
                        }

                        systemOptionElement(index: index)
                    }
                }
            }
        }
    }

    @ViewBuilder
    private func systemOptionElement(index: Int) -> some View {
        switch props.systemOptions[index] {
        case let .selectable(title, selectionAction):
            Button(
                action: {
                    actionTriggered(selectionAction.value)
                },
                label: {
                    Text(title)
                        .modifier(
                            textStyleClass: .tableHeaderSelectableOption,
                            textColoring: props.colorings.activeButtonTextColoring
                        )
                }
            )

        case let .nonSelectable(title):
            Text(title)
                .modifier(
                    textStyleClass: .tableHeaderNonSelectableOption,
                    textColoring: props.colorings.textColoring
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

    let props: SettingsCellProps

    var body: some View {
        HStack {
            Text(props.title)
                .modifier(
                    textStyleClass: .cellText,
                    textColoring: props.colorings.textColoring
                )

            Spacer()

            if props.isSelected {
                Image(uiImage: Constants.image)
                    .resizable()
                    .frame(width: Constants.imageHeight * Constants.image.widthToHeightRatio,
                           height: Constants.imageHeight)
                    .aspectRatio(contentMode: .fit)
                    .colorMultiply(Color(props.colorings.checkmarkTint.color))
            }
        }
        .listRowBackground(Color(props.colorings.viewColoring.backgroundColor))
    }

}
