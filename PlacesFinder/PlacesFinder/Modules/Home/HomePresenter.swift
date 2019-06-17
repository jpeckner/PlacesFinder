//
//  HomePresenter.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import CoordiNode
import Shared
import UIKit

protocol HomePresenterProtocol: AnyObject, AutoMockable {
    var delegate: HomeViewControllerDelegate? { get set }
    var rootViewController: UIViewController { get }

    func setSelectedViewController(_ controller: UIViewController)
}

class HomePresenter: HomePresenterProtocol {

    weak var delegate: HomeViewControllerDelegate?
    private let homeViewController: HomeViewController

    var rootViewController: UIViewController {
        return homeViewController
    }

    init(childContainer: HomeCoordinatorChildContainer) {
        self.homeViewController = HomeViewController(viewControllers: childContainer.orderedChildViewControllers)

        homeViewController.homeViewControllerDelegate = self
    }

    func setSelectedViewController(_ controller: UIViewController) {
        homeViewController.selectedViewController = controller
    }

}

extension HomePresenter: HomeViewControllerDelegate {

    func viewController(_ homeViewController: HomeViewController,
                        didSelectIndex index: Int,
                        previousIndex: Int) {
        delegate?.viewController(homeViewController,
                                 didSelectIndex: index,
                                 previousIndex: previousIndex)
    }

}
