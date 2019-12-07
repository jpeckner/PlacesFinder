//
//  LaunchViewController.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Shared
import SwiftUI
import UIKit

class LaunchViewController: SingleContentViewController {

    private let launchView: LaunchViewProtocol

    init(appSkin: AppSkin) {
        let colorings = appSkin.colorings.launch
        let contentView: UIView

        if #available(iOS 13.0, *) {
            let launchView = LaunchViewSUI(colorings: colorings)
            self.launchView = launchView
            contentView = UIHostingController(rootView: launchView).view
        } else {
            let launchView = LaunchView(colorings: colorings)
            self.launchView = launchView
            contentView = launchView
        }

        super.init(contentView: contentView,
                   viewColoring: colorings.viewColoring)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension LaunchViewController {

    func startSpinner() {
        launchView.startSpinner()
    }

    func animateOut(_ completion: (() -> Void)?) {
        launchView.animateOut(completion)
    }

}
