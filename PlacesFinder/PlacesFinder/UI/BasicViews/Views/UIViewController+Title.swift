//
//  UIViewController+Title.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import SwiftUI
import UIKit

extension UIViewController {

    func configureTitleView(_ viewModel: NavigationBarTitleViewModel,
                            appSkin: AppSkin) {
        let colorings = appSkin.colorings.navBar
        let titleView = NavigationBarTitleViewSUI(viewModel: viewModel,
                                                  colorings: colorings)

        let hostingView = UIHostingController(rootView: titleView).view
        hostingView?.backgroundColor = .clear
        navigationItem.titleView = hostingView
    }

}