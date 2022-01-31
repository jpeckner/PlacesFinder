//
//  AppDelegate.swift
//  PlacesFinder
//
//  Copyright (c) 2018 Justin Peckner
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
import CoreLocation
import Foundation
import Reachability
import Shared
import SwiftDux
import UIKit

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
        let locationAuthManager = CLLocationManager()
        let store = Store<AppState>(userDefaultsService: userDefaultsService,
                                    locationAuthManager: locationAuthManager,
                                    appCopyContent: appCopyContent)

        let listenerContainer = ListenerContainer(store: store,
                                                  locationAuthManager: locationAuthManager,
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
                     locationAuthManager: CLLocationManager,
                     appCopyContent: AppCopyContent) {
        let searchPreferencesState =
            (try? userDefaultsService.getSearchPreferences()).map { stored in
                SearchPreferencesState(stored: stored)
            }
            ?? SearchPreferencesState(usesMetricSystem: Locale.current.usesMetricSystem)
        let initialState = AppState(
            appCopyContent: appCopyContent,
            locationAuthStatus: locationAuthManager.authorizationStatus.authStatus(),
            currentRouterNode: AppCoordinatorNode.nodeBox,
            searchPreferencesState: searchPreferencesState
        )

        self.init(reducer: AppStateReducer.reduce,
                  initialState: initialState)
    }

}

// MARK: ServiceContainer

private extension ServiceContainer {

    init(appConfig: AppConfig,
         store: DispatchingStoreProtocol) {
        let routingHandler = RoutingHandler()
        let destinationRoutingHandler = DestinationRoutingHandler()
        self.appRoutingHandler = AppRoutingHandler(routingHandler: routingHandler,
                                                   destinationRoutingHandler: destinationRoutingHandler)

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
