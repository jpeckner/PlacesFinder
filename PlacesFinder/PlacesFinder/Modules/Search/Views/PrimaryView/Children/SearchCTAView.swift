//
//  SearchCTAView.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Shared
import SnapKit
import SwiftUI
import UIKit

protocol SearchCTACopyProtocol: StaticInfoCopyProtocol {
    var ctaTitle: String { get }
}

extension SearchCTACopyProtocol {

    var ctaViewModel: SearchCTAViewModel {
        return SearchCTAViewModel(infoViewModel: staticInfoViewModel,
                                  ctaTitle: ctaTitle)
    }

}

typealias SearchCTARetryBlock = () -> Void

class SearchCTAView: UIView {

    private let staticInfoView: StaticInfoView
    private let ctaButton: ActionableButton

    init(viewModel: SearchCTAViewModel,
         colorings: SearchCTAViewColorings,
         retryBlock: @escaping SearchCTARetryBlock) {
        self.staticInfoView = StaticInfoView(viewModel: viewModel.infoViewModel,
                                             colorings: colorings)
        self.ctaButton = ActionableButton(touchUpInsideCallback: retryBlock)

        super.init(frame: .zero)

        setupSubviews()
        setupConstraints()
        setupContent(viewModel)
        setupStyling(colorings)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupSubviews() {
        addSubview(staticInfoView)
        addSubview(ctaButton)
    }

    private func setupConstraints() {
        configureMargins(top: 24.0,
                         leading: 16.0,
                         bottom: 8.0,
                         trailing: 16.0)

        staticInfoView.snp.makeConstraints { make in
            make.leading.equalTo(snp.leadingMargin)
            make.trailing.equalTo(snp.trailingMargin)
            make.top.equalTo(snp.topMargin)
        }

        ctaButton.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.leading.greaterThanOrEqualTo(snp.leadingMargin)
            make.trailing.lessThanOrEqualTo(snp.trailingMargin)
            make.top.equalTo(staticInfoView.snp.bottom).offset(8.0)
            make.bottom.lessThanOrEqualTo(snp.bottomMargin)
        }
    }

    private func setupContent(_ viewModel: SearchCTAViewModel) {
        ctaButton.setTitle(viewModel.ctaTitle, for: .normal)
    }

    private func setupStyling(_ colorings: SearchCTAViewColorings) {
        ctaButton.configure(.ctaButton,
                            textColoring: colorings.ctaTextColoring)
    }

}

// MARK: SearchCTAViewSUI

@available(iOS 13.0, *)
struct SearchCTAViewSUI: View {

    @State var viewModel: SearchCTAViewModelSUI
    let colorings: SearchCTAViewColorings
    let retryBlock: SearchCTARetryBlock

    var body: some View {
        VStack {
            StaticInfoViewSUI(viewModel: $viewModel.infoViewModel)
                .padding(.bottom)

            Button(action: retryBlock) {
                Text(viewModel.ctaTitle)
            }
            .configure(.ctaButton, textColoring: colorings.ctaTextColoring)
        }.padding()
    }

}
