//
//  SettingsMeasurementSystemHeaderView.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Shared
import SwiftDux
import UIKit

class SettingsMeasurementSystemHeaderView: UIView {

    private let store: DispatchingStoreProtocol
    private let copyContent: SettingsMeasurementSystemCopyContent
    private let sectionNameLabel: StyledLabel
    private let systemsStackView: UIStackView

    init(store: DispatchingStoreProtocol,
         copyContent: SettingsMeasurementSystemCopyContent,
         currentSystemInState: MeasurementSystem,
         title: String,
         colorings: SettingsHeaderViewColorings) {
        self.store = store
        self.copyContent = copyContent
        self.sectionNameLabel = StyledLabel(textStyleClass: .tableHeader,
                                            textColoring: colorings.textColoring)
        self.systemsStackView = UIStackView()

        super.init(frame: .zero)

        setupSubviews()
        setupConstraints()
        setupTitleLabel(title)
        setupStackView(currentSystemInState,
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

    private func setupStackView(_ currentSystemInState: MeasurementSystem,
                                colorings: SettingsHeaderViewColorings) {
        systemsStackView.axis = .horizontal
        systemsStackView.spacing = 8.0
        systemsStackView.alignment = .bottom
        systemsStackView.distribution = .fill

        for system in MeasurementSystem.allCases {
            if system != MeasurementSystem.allCases[0] {
                systemsStackView.addArrangedSubview(delimeterLabel(colorings))
            }

            let subview = system == currentSystemInState ?
                label(for: system, colorings: colorings)
                : button(for: system, colorings: colorings)
            systemsStackView.addArrangedSubview(subview)
        }
    }

    private func label(for system: MeasurementSystem,
                       colorings: SettingsHeaderViewColorings) -> StyledLabel {
        let label = StyledLabel(textStyleClass: .tableHeaderSelectedButton,
                                textColoring: colorings.textColoring,
                                numberOfLines: 1)
        label.text = copyContent.title(system)
        return label
    }

    private func button(for system: MeasurementSystem,
                        colorings: SettingsHeaderViewColorings) -> ActionableButton {
        let button = ActionableButton { [weak self] in
            self?.store.dispatch(SearchPreferencesActionCreator.setMeasurementSystem(system))
        }

        button.setTitle(copyContent.title(system), for: .normal)
        button.applyTextStyle(.tableHeaderButton)
        button.applyTextColoring(colorings.activeButtonTextColoring, for: .normal)
        button.constrainHeightToTitleLabel()

        return button
    }

    private func delimeterLabel(_ colorings: SettingsHeaderViewColorings) -> StyledLabel {
        let label = StyledLabel(textStyleClass: .tableHeaderButton,
                                textColoring: colorings.textColoring,
                                numberOfLines: 1)
        label.text = copyContent.delimeter
        return label
    }

}

private extension SettingsMeasurementSystemCopyContent {

    func title(_ measurementSystem: MeasurementSystem) -> String {
        switch measurementSystem {
        case .imperial:
            return imperial
        case .metric:
            return metric
        }
    }

}
