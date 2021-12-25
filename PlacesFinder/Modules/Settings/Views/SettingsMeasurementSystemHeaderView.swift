//
//  SettingsMeasurementSystemHeaderView.swift
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
import UIKit

class SettingsMeasurementSystemHeaderView: UIView {

    private let viewModel: SettingsUnitsHeaderViewModel
    private let sectionNameLabel: StyledLabel
    private let systemsStackView: UIStackView

    init(viewModel: SettingsUnitsHeaderViewModel,
         colorings: SettingsViewColorings) {
        self.viewModel = viewModel

        self.sectionNameLabel = StyledLabel(textStyleClass: .tableHeader,
                                            textColoring: colorings.headerTextColoring)
        self.systemsStackView = UIStackView()

        super.init(frame: .zero)

        setupSubviews()
        setupConstraints()
        setupTitleLabel(viewModel.title)
        setupStackView(viewModel.systemOptions,
                       colorings: colorings)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupSubviews() {
        addSubview(sectionNameLabel)
        addSubview(systemsStackView)
    }

    private func setupConstraints() {
        configureMargins(top: 8.0,
                         leading: 8.0,
                         bottom: 8.0,
                         trailing: 8.0)

        sectionNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(snp.leadingMargin)
            make.trailing.lessThanOrEqualTo(snp.trailingMargin)
            make.top.greaterThanOrEqualTo(snp.topMargin)
            make.bottom.equalTo(snp.bottomMargin)
        }

        systemsStackView.snp.makeConstraints { make in
            make.leading.greaterThanOrEqualTo(sectionNameLabel.snp.trailing).offset(8.0)
            make.trailing.equalTo(snp.trailingMargin)
            make.top.greaterThanOrEqualTo(snp.topMargin)
            make.bottom.equalTo(snp.bottomMargin)
        }
    }

    private func setupTitleLabel(_ title: String) {
        sectionNameLabel.text = title
    }

    private func setupStackView(_ systemOptions: [SettingsUnitsHeaderViewModel.SystemOption],
                                colorings: SettingsViewColorings) {
        systemsStackView.axis = .horizontal
        systemsStackView.spacing = 8.0
        systemsStackView.alignment = .bottom
        systemsStackView.distribution = .fill

        for idx in 0..<systemOptions.count {
            if idx != 0 {
                systemsStackView.addArrangedSubview(delimeterLabel(colorings))
            }

            switch systemOptions[idx] {
            case let .selectable(title, selectionCallback):
                systemsStackView.addArrangedSubview(button(title,
                                                           colorings: colorings,
                                                           selectionCallback: selectionCallback.value))
            case let .nonSelectable(title):
                systemsStackView.addArrangedSubview(label(title,
                                                          colorings: colorings))
            }
        }
    }

    private func label(_ title: String,
                       colorings: SettingsViewColorings) -> StyledLabel {
        let label = StyledLabel(textStyleClass: .tableHeaderSelectableOption,
                                textColoring: colorings.headerTextColoring,
                                numberOfLines: 1)
        label.text = title
        return label
    }

    private func button(_ title: String,
                        colorings: SettingsViewColorings,
                        selectionCallback: @escaping () -> Void) -> ActionableButton {
        let button = ActionableButton(touchUpInsideCallback: selectionCallback)
        button.setTitle(title, for: .normal)
        button.applyTextStyle(.tableHeaderNonSelectableOption)
        button.applyTextColoring(colorings.activeButtonTextColoring, for: .normal)
        button.constrainHeightToTitleLabel()
        return button
    }

    private func delimeterLabel(_ colorings: SettingsViewColorings) -> StyledLabel {
        let label = StyledLabel(textStyleClass: .tableHeaderNonSelectableOption,
                                textColoring: colorings.headerTextColoring,
                                numberOfLines: 1)
        label.text = "|"
        return label
    }

}
