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
