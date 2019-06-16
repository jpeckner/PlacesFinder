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

    private enum StyleContent {
        static let viewColoring = ViewColoring(backgroundColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
    }

    private let launchView: LaunchView

    init(colorings: LaunchViewColorings) {
        self.launchView = LaunchView(colorings: colorings)

        super.init(contentView: launchView,
                   viewColoring: StyleContent.viewColoring)
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
