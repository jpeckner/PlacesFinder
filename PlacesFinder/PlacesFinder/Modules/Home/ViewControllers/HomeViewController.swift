//
//  HomeViewController.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import UIKit

protocol HomeViewControllerDelegate: AnyObject {
    func viewController(_ homeViewController: HomeViewController,
                        didSelectIndex index: Int,
                        previousIndex: Int)
}

class HomeViewController: UITabBarController {

    weak var homeViewControllerDelegate: HomeViewControllerDelegate?
    private var previousIndex = 0

    override var selectedViewController: UIViewController? {
        willSet {
            previousIndex = selectedIndex
        }
    }

    init(viewControllers: [UIViewController]) {
        super.init(nibName: nil, bundle: nil)

        self.viewControllers = viewControllers

        delegate = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension HomeViewController {

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        guard previousTraitCollection?.horizontalSizeClass != traitCollection.horizontalSizeClass,
            let horizontalSizeClass = horizontalSpecifiedClass
        else { return }

        adjustTabImageInsets(horizontalSizeClass)
    }

}

extension HomeViewController: UITabBarControllerDelegate {

    func tabBarController(_ tabBarController: UITabBarController,
                          didSelect viewController: UIViewController) {
        guard selectedIndex != previousIndex else { return }

        homeViewControllerDelegate?.viewController(self,
                                                   didSelectIndex: selectedIndex,
                                                   previousIndex: previousIndex)
        previousIndex = selectedIndex
    }

}
