//
//  SearchContainerViewController.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Shared
import UIKit

class SearchContainerViewController: UIViewController {

    var splitControllers: SearchContainerSplitControllers {
        didSet {
            configureSplitController()
        }
    }
    private let searchSplitViewController: UISplitViewController
    private let masterPaneNavController: SearchMasterPaneNavigationController
    private var lastHorizontalSpecifiedClass: SpecifiedSizeClass

    private var collapseSecondaryController: Bool {
        return splitControllers.secondaryController == nil
    }

    init() {
        self.splitControllers = SearchContainerSplitControllers(primaryController: SearchPlaceholderViewController(),
                                                                secondaryController: nil)
        self.searchSplitViewController = UISplitViewController()
        self.masterPaneNavController = SearchMasterPaneNavigationController()
        self.lastHorizontalSpecifiedClass = .compact

        super.init(nibName: nil, bundle: nil)

        setupSplitViewController()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupSplitViewController() {
        searchSplitViewController.delegate = self
        searchSplitViewController.viewControllers = [masterPaneNavController]
        searchSplitViewController.edgesForExtendedLayout = []
        searchSplitViewController.preferredDisplayMode = .allVisible
    }

}

extension SearchContainerViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setSingleChildController(searchSplitViewController) {
            view.addSubview($0)
            $0.fitFully(to: view)
        }
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        guard let newHorizontalSpecifiedClass = horizontalSpecifiedClass,
            newHorizontalSpecifiedClass != lastHorizontalSpecifiedClass
        else { return }

        self.lastHorizontalSpecifiedClass = newHorizontalSpecifiedClass
        configureSplitController()
    }

}

extension SearchContainerViewController: UISplitViewControllerDelegate {

    func splitViewController(_ splitViewController: UISplitViewController,
                             collapseSecondary secondaryViewController: UIViewController,
                             onto primaryViewController: UIViewController) -> Bool {
        return collapseSecondaryController
    }

}

private extension SearchContainerViewController {

    func configureSplitController() {
        configureSecondaryViewVisibility()

        switch lastHorizontalSpecifiedClass {
        case .compact:
            let updatedViewControllers: [UIViewController] = [
                splitControllers.primaryController,
                detailsController
            ].compactMap { $0 }
            let animated = updatedViewControllers.count != masterPaneNavController.viewControllers.count

            masterPaneNavController.setViewControllers(updatedViewControllers,
                                                       animated: animated)
            searchSplitViewController.viewControllers = [masterPaneNavController]
        case .regular:
            masterPaneNavController.setViewControllers(
                [splitControllers.primaryController],
                animated: false
            )

            searchSplitViewController.viewControllers = [
                masterPaneNavController,
                detailsController
            ].compactMap { $0 }
        }
    }

    private var detailsController: SearchDetailsViewController? {
        return splitControllers.secondaryController.flatMap {
            switch $0 {
            case let .anySizeClass(controller):
                return controller
            case let .regularOnly(controller):
                return lastHorizontalSpecifiedClass == .regular ? controller : nil
            }
        }
    }

    private func configureSecondaryViewVisibility() {
        switch lastHorizontalSpecifiedClass {
        case .compact:
            break
        case .regular:
            // Overriding the split controller's horizontal size class (as well as returning true from the
            // collapseSecondary: delegate method) appears to be the only way to hide the secondary controller here.
            // Setting other properties, such as preferredPrimaryColumnWidthFraction, doesn't work. More details:
            // https://stackoverflow.com/a/35718555/1342984
            setOverrideTraitCollection(
                UITraitCollection(horizontalSizeClass: collapseSecondaryController ? .compact : .regular),
                forChild: searchSplitViewController
            )
        }
    }

}

// MARK: Private view controllers

/// SearchPlaceholderViewController is never actually shown; it allows var splitControllers above to be non-optional.
private class SearchPlaceholderViewController: UIViewController, SearchPrimaryViewControllerProtocol {}

private class SearchMasterPaneNavigationController: UINavigationController {

    override func popViewController(animated: Bool) -> UIViewController? {
        let poppedController = super.popViewController(animated: animated)

        switch poppedController {
        case let detailsController as SearchDetailsViewController:
            detailsController.viewWasPopped()
        default:
            break
        }

        return poppedController
    }

}
