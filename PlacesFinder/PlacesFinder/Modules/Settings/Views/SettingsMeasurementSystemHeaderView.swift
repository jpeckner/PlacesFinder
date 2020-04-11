//
//  SettingsMeasurementSystemHeaderView.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

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
                                            textColoring: colorings.headerColorings.textColoring)
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
                                textColoring: colorings.headerColorings.textColoring,
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
        button.applyTextColoring(colorings.headerColorings.activeButtonTextColoring, for: .normal)
        button.constrainHeightToTitleLabel()
        return button
    }

    private func delimeterLabel(_ colorings: SettingsViewColorings) -> StyledLabel {
        let label = StyledLabel(textStyleClass: .tableHeaderNonSelectableOption,
                                textColoring: colorings.headerColorings.textColoring,
                                numberOfLines: 1)
        label.text = "|"
        return label
    }

}
