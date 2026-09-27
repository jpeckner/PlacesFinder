//
//  HomePresenter.swift
//  PlacesFinder
//
//  Copyright (c) 2019 Justin Peckner
//  
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//  
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//  
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import CoordiNode
import Shared
import UIKit

protocol HomePresenterDelegate: AnyObject {
    // periphery:ignore:parameters homePresenter
    @MainActor
    func homePresenter(_ homePresenter: HomePresenterProtocol,
                       didSelectChildCoordinator index: Int)
}

// sourcery: AutoMockable
@MainActor protocol HomePresenterProtocol: AnyObject {
    var delegate: HomePresenterDelegate? { get set }
    var rootViewController: UIViewController { get }

    func setSelectedViewController(_ controller: UIViewController)
}

@MainActor
class HomePresenter: HomePresenterProtocol {

    weak var delegate: HomePresenterDelegate?
    private let tabSelectionViewController: TabSelectionViewController

    var rootViewController: UIViewController {
        return tabSelectionViewController
    }

    init(orderedChildViewControllers: [UIViewController]) {
        self.tabSelectionViewController = TabSelectionViewController(viewControllers: orderedChildViewControllers)

        tabSelectionViewController.tabSelectionViewControllerDelegate = self

        tabSelectionViewController.registerForTraitChanges(
            [UITraitHorizontalSizeClass.self]
        ) { (controller: TabSelectionViewController, _) in
            controller.adjustSafeAreaForTopTabBar()
        }
        tabSelectionViewController.adjustSafeAreaForTopTabBar()
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
                                didSelectChildCoordinator: index)
    }

}

private extension TabSelectionViewController {

    // On iPad (regular width) iOS 18+ places the tab bar at the top, where it overlays the child navigation bars'
    // titles. Extend the top safe area so child content sits below it.
    func adjustSafeAreaForTopTabBar() {
        let isTopTabBar = traitCollection.userInterfaceIdiom == .pad
            && traitCollection.horizontalSizeClass == .regular

        // Applied to the children, not the tab controller itself, since the tab bar is laid out within the tab
        // controller's own safe area.
        // Plain navigation controllers (e.g. Settings) already lay their bar out below the tab bar.
        viewControllers?
            .filter { !($0 is UINavigationController) }
            .forEach { $0.additionalSafeAreaInsets.top = isTopTabBar ? 48.0 : 0.0 }
    }

}
