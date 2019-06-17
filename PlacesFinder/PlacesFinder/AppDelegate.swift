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

// TODO (pre-release): enable fetch/pull/push in UploadToTestflightFastfile (once origin is live), and do a test upload
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
        window.makeKeyAndVisible()
        appCoordinator.start()

        guard let url = launchOptions?[.url] as? URL else { return true }

        return appCoordinator.handleURL(url)
    }

    // Sample linking URLs to use in Safari in iOS Simulator:
    //   placesFinder://com.justinpeckner.placesfinder/search?keywords=Chinese%20Food
    //   placesFinder://com.justinpeckner.placesfinder/settings
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
        self.reachabilityListener = Reachability().map {
            ReachabilityListener(store: store, reachability: $0)
        }

        self.userDefaultsListener = UserDefaultsListener(store: store,
                                                         userDefaultsService: userDefaultsService)
    }

}

// MARK: ServiceContainer

private extension ServiceContainer {

    init(appConfig: AppConfig,
         store: DispatchingStoreProtocol) {
        let decodableServices = DecodableServices()

        self.appSkinService = AppSkinService(
            url: appConfig.appSkinConfig.url,
            decodableService: decodableServices.quickTimeoutDecodableService
        )

        let locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        self.locationRequestHandler = LocationRequestHandler(locationManager: locationManager)

        self.placeLookupService = PlaceLookupService(
            apiOption: .yelp(appConfig.yelpRequestConfig),
            decodableService: decodableServices.standardTimeoutDecodableService
        )

        self.routingHandler = AppRoutingHandler(routingHandler: RoutingHandler())

        self.urlOpenerService = URLOpenerService(urlOpener: UIApplication.shared)
    }

}
