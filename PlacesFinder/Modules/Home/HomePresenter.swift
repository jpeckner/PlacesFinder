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

protocol HomePresenterDelegate: AnyObject {
    func homePresenter(_ homePresenter: HomePresenterProtocol,
                       didSelectChildCoordinator index: Int,
                       previousChildIndex: Int)
}

protocol HomePresenterProtocol: AnyObject, AutoMockable {
    var delegate: HomePresenterDelegate? { get set }
    var rootViewController: UIViewController { get }

    func setSelectedViewController(_ controller: UIViewController)
}

class HomePresenter: HomePresenterProtocol {

    weak var delegate: HomePresenterDelegate?
    private let tabSelectionViewController: TabSelectionViewController

    var rootViewController: UIViewController {
        return tabSelectionViewController
    }

    init(orderedChildViewControllers: [UIViewController]) {
        self.tabSelectionViewController = TabSelectionViewController(viewControllers: orderedChildViewControllers)

        tabSelectionViewController.tabSelectionViewControllerDelegate = self
    }

    func setSelectedViewController(_ controller: UIViewController) {
        tabSelectionViewController.selectedViewController = controller
    }

}

extension HomePresenter: TabSelectionViewControllerDelegate {

    func viewController(_ tabSelectionViewController: TabSelectionViewController,
                        didSelectIndex index: Int,
                        previousIndex: Int) {
        delegate?.homePresenter(self,
                                didSelectChildCoordinator: index,
                                previousChildIndex: previousIndex)
    }

}
