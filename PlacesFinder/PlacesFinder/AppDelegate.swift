//
//  AppDelegate.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2018 Justin Peckner. All rights reserved.
//

import CoordiNode
import CoreLocation
import Foundation
import Reachability
import Shared
import SwiftDux
import UIKit

// TODO: run UI tests after switch to SwiftUI
// TODO: delete dead UIKit code
// TODO: remove "SUI" prefixes from types?

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    typealias TChildFactory = AppCoordinatorChildFactory<Store<AppState>>

    let window: UIWindow
    private let appCoordinator: AppCoordinator<TChildFactory>

    override init() {
        let appConfig: AppConfig
        do {
            appConfig = try AppConfig(bundle: Bundle.main)
        } catch {
            fatalError("Unexpected error: \(error)")
        }

        self.window = UIWindow(frame: UIScreen.main.bounds)

        let childFactory = TChildFactory(appConfig: appConfig)
        let payloadBuilder = AppLinkTypeBuilder()
        self.appCoordinator = AppCoordinator(mainWindow: window,
                                             childFactory: childFactory,
                                             payloadBuilder: payloadBuilder)
    }

    func application(
        _ application: UIApplication,
        willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        // Defer this so that appCoordinator first has a chance to dispatch the link payload (if any) to the app's state
        defer {
            appCoordinator.start()
        }

        window.makeKeyAndVisible()

        guard let url = launchOptions?[.url] as? URL else {
            return true
        }

        return appCoordinator.handleURL(url)
    }

    // Sample linking URLs to use in Safari in iOS Simulator. Use placesFinder:// as the scheme for Release builds, and
    // placesFinder-dev:// for Debug.
    //   placesFinder[-dev]://com.justinpeckner.PlacesFinder/search?keywords=Chinese%20Food
    //   placesFinder[-dev]://com.justinpeckner.PlacesFinder/settings
    func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey: Any] = [:]
    ) -> Bool {
        return appCoordinator.handleURL(url)
    }

}

// MARK: AppCoordinatorChildFactory

private extension AppDelegate.TChildFactory {

    convenience init(appConfig: AppConfig) {
        let userDefaultsService = UserDefaultsService(userDefaults: .standard)
        let appCopyContent = AppCopyContent(displayName: appConfig.displayName)
        let store = Store<AppState>(userDefaultsService: userDefaultsService,
                                    appCopyContent: appCopyContent)

        let listenerContainer = ListenerContainer(store: store,
                                                  userDefaultsService: userDefaultsService)

        let serviceContainer = ServiceContainer(appConfig: appConfig,
                                                store: store)

        let launchStatePrism = LaunchStatePrism()

        self.init(store: store,
                  listenerContainer: listenerContainer,
                  serviceContainer: serviceContainer,
                  launchStatePrism: launchStatePrism,
                  defaultLinkType: .emptySearch(EmptySearchLinkPayload()))
    }

}

// MARK: Store

private extension Store where State == AppState {

    convenience init(userDefaultsService: UserDefaultsServiceProtocol,
                     appCopyContent: AppCopyContent) {
        let searchPreferencesState =
            (try? userDefaultsService.getSearchPreferences())
            ?? SearchPreferencesState(usesMetricSystem: Locale.current.usesMetricSystem)
        let initialState = AppState(
            appCopyContent: appCopyContent,
            locationAuthStatus: CLLocationManager.authorizationStatus().authStatus(),
            currentRouterNode: AppCoordinatorNode.nodeBox,
            searchPreferencesState: searchPreferencesState
        )

        self.init(reducer: AppStateReducer.reduce,
                  initialState: initialState)
    }

}

// MARK: ListenerContainer

private extension ListenerContainer {

    init(store: Store<AppState>,
         userDefaultsService: UserDefaultsServiceProtocol) {
        self.locationAuthListener = LocationAuthListener(store: store,
                                                         locationAuthManager: CLLocationManager())

        // Use of the Reachability library enhances the app experience (it allows us to show a "No internet" message
        // rather than a less specific error), but the app still functions correctly on the off-chance that
        // Reachability.init() returns nil.
        do {
            let reachability = try Reachability()
            self.reachabilityListener = ReachabilityListener(store: store,
                                                             reachability: reachability)
        } catch {
            self.reachabilityListener = nil
        }

        self.userDefaultsListener = UserDefaultsListener(store: store,
                                                         userDefaultsService: userDefaultsService)
    }

}

// MARK: ServiceContainer

private extension ServiceContainer {

    init(appConfig: AppConfig,
         store: DispatchingStoreProtocol) {
        let routingHandler = RoutingHandler()
        self.appRoutingHandler = AppRoutingHandler(routingHandler: routingHandler)

        self.appSkinService = AppSkinService()

        let locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        self.locationRequestHandler = LocationRequestHandler(locationManager: locationManager)

        let decodableServices = DecodableServices()
        self.placeLookupService = YelpRequestService(
            config: appConfig.yelpRequestConfig,
            decodableService: decodableServices.standardTimeoutDecodableService
        )

        self.searchCopyFormatter = SearchCopyFormatter()

        self.urlOpenerService = URLOpenerService(urlOpener: UIApplication.shared)
    }

}
