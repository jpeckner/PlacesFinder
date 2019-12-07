//
//  LaunchViewController.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Shared
import UIKit

class LaunchViewController: SingleContentViewController {

    private let launchView: LaunchView

    init(appSkin: AppSkin) {
        self.launchView = LaunchView(colorings: appSkin.colorings.launch)

        super.init(contentView: launchView,
                   viewColoring: appSkin.colorings.launch.viewColoring)
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
