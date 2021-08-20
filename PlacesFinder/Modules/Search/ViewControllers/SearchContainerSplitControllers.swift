//
//  SearchContainerSplitControllers.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import UIKit

typealias SearchPrimaryViewController = UIViewController & SearchPrimaryViewControllerProtocol

struct SearchContainerSplitControllers {
    enum SecondaryController {
        case anySizeClass(SearchDetailsViewController)
        case regularOnly(SearchDetailsViewController)

        var detailsController: SearchDetailsViewController {
            switch self {
            case let .anySizeClass(controller),
                 let .regularOnly(controller):
                return controller
            }
        }
    }

    let primaryController: SearchPrimaryViewController
    let secondaryController: SecondaryController?
}
