//
//  SettingsSectionHeaderView.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Shared
import UIKit

class SettingsSectionHeaderView: UIView {

    private let label: StyledLabel

    init(viewModel: SettingsSectionHeaderViewModel,
         colorings: SettingsViewColorings) {
        self.label = StyledLabel(textStyleClass: .tableHeader,
                                 textColoring: colorings.headerTextColoring)

        super.init(frame: .zero)

        setupSubviews()
        setupConstraints()
        setupContent(viewModel)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupSubviews() {
        addSubview(label)
    }

    private func setupConstraints() {
        configureMargins(top: 8.0,
                         leading: 8.0,
                         bottom: 8.0,
                         trailing: 8.0)

        label.snp.makeConstraints { make in
            make.leading.equalTo(snp.leadingMargin)
            make.trailing.lessThanOrEqualTo(snp.trailingMargin)
            make.top.greaterThanOrEqualTo(snp.topMargin)
            make.bottom.equalTo(snp.bottomMargin)
        }
    }

    private func setupContent(_ viewModel: SettingsSectionHeaderViewModel) {
        label.text = viewModel.title
    }

}
