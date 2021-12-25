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
    private let mainPaneNavController: SearchMainPaneNavigationController
    private var lastHorizontalSpecifiedClass: SpecifiedSizeClass?

    private var collapseSecondaryController: Bool {
        return splitControllers.secondaryController == nil
    }

    init() {
        self.splitControllers = SearchContainerSplitControllers(primaryController: SearchPlaceholderViewController(),
                                                                secondaryController: nil)
        self.searchSplitViewController = UISplitViewController()
        self.mainPaneNavController = SearchMainPaneNavigationController()

        super.init(nibName: nil, bundle: nil)

        setupSplitViewController()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupSplitViewController() {
        searchSplitViewController.delegate = self
        searchSplitViewController.viewControllers = [mainPaneNavController]
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

    // Needed for iOS 13, because traitCollectionDidChange() is no longer called on initial load.
    // See https://developer.apple.com/documentation/ios_ipados_release_notes/ios_13_release_notes
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        guard lastHorizontalSpecifiedClass == nil,
            let newHorizontalSpecifiedClass = horizontalSpecifiedClass
        else { return }

        lastHorizontalSpecifiedClass = newHorizontalSpecifiedClass
        configureSplitController()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        guard let newHorizontalSpecifiedClass = horizontalSpecifiedClass,
            newHorizontalSpecifiedClass != lastHorizontalSpecifiedClass
        else { return }

        lastHorizontalSpecifiedClass = newHorizontalSpecifiedClass
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
        guard let specifiedClass = lastHorizontalSpecifiedClass else { return }

        configureSecondaryViewVisibility(specifiedClass)
        assignViewControllers(specifiedClass)
    }

    private func configureSecondaryViewVisibility(_ specifiedClass: SpecifiedSizeClass) {
        switch specifiedClass {
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

    private func assignViewControllers(_ specifiedClass: SpecifiedSizeClass) {
        switch specifiedClass {
        case .compact:
            let updatedViewControllers: [UIViewController] = [
                splitControllers.primaryController,
                detailsController
            ].compactMap { $0 }
            let animated = updatedViewControllers.count != mainPaneNavController.viewControllers.count

            mainPaneNavController.setViewControllers(updatedViewControllers,
                                                     animated: animated)
            searchSplitViewController.viewControllers = [mainPaneNavController]
        case .regular:
            mainPaneNavController.setViewControllers(
                [splitControllers.primaryController],
                animated: false
            )

            searchSplitViewController.viewControllers = [
                mainPaneNavController,
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

}

// MARK: Private view controllers

/// SearchPlaceholderViewController is never actually shown; it allows var splitControllers above to be non-optional.
private class SearchPlaceholderViewController: UIViewController, SearchPrimaryViewControllerProtocol {}

private class SearchMainPaneNavigationController: UINavigationController {

    private var previousViewControllers: [UIViewController] = []

    init() {
        super.init(nibName: nil, bundle: nil)

        delegate = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension SearchMainPaneNavigationController: UINavigationControllerDelegate {

    func navigationController(_ navigationController: UINavigationController,
                              didShow viewController: UIViewController,
                              animated: Bool) {
        defer {
            previousViewControllers = viewControllers
        }

        guard previousViewControllers.count > viewControllers.count,
            let previousTopController = previousViewControllers.last as? PopCallbackViewController
        else { return }

        previousTopController.viewControllerWasPopped()
    }

}
