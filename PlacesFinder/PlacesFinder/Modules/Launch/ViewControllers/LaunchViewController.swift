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

    private enum StyleContent {
        static let viewColoring = ViewColoring(backgroundColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
    }

    private let launchView: LaunchViewProtocol

    init(colorings: LaunchViewColorings) {
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
