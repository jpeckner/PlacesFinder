//
//  SearchPresenterProtocol.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2020 Justin Peckner. All rights reserved.
//

import Shared
import UIKit

protocol SearchPresenterProtocol: AutoMockable {
    var rootViewController: UIViewController { get }

    func loadNoInternetViews(_ viewModel: SearchNoInternetViewModel,
                             titleViewModel: NavigationBarTitleViewModel,
                             appSkin: AppSkin)

    func loadLocationServicesDisabledViews(_ viewModel: SearchLocationDisabledViewModel,
                                           titleViewModel: NavigationBarTitleViewModel,
                                           appSkin: AppSkin)

    func loadSearchBackgroundView(_ viewModel: SearchBackgroundViewModel,
                                  titleViewModel: NavigationBarTitleViewModel,
                                  appSkin: AppSkin)

    func loadSearchViews(_ viewModel: SearchLookupViewModel,
                         detailsViewContext: SearchDetailsViewContext?,
                         titleViewModel: NavigationBarTitleViewModel,
                         appSkin: AppSkin)
}
