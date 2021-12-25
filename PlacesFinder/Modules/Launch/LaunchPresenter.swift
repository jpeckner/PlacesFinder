//
//  LaunchPresenter.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Shared
import UIKit

protocol LaunchPresenterProtocol: AutoMockable {
    var rootViewController: UIViewController { get }

    func startSpinner()
    func animateOut(_ completion: (() -> Void)?)
}

class LaunchPresenter: LaunchPresenterProtocol {

    private let launchViewController: LaunchViewController

    var rootViewController: UIViewController {
        return launchViewController
    }

    init(appSkin: AppSkin) {
        self.launchViewController = LaunchViewController(appSkin: appSkin)
    }

    func startSpinner() {
        launchViewController.startSpinner()
    }

    func animateOut(_ completion: (() -> Void)?) {
        launchViewController.animateOut(completion)
    }

}
