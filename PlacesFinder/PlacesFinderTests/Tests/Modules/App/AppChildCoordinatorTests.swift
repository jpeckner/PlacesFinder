//
//  AppChildCoordinatorTests.swift
//  PlacesFinderTests
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Nimble
#if DEBUG
@testable import PlacesFinder
#endif
import Quick

class AppChildCoordinatorTests: QuickSpec {

    override func spec() {

        describe("AppCoordinatorChildProtocol") {

            describe("HomeCoordinator") {
                it("returns .home") {
                    expect(HomeCoordinator<MockAppStore>.self.appCoordinatorImmediateDescendent) == .home
                }
            }

            describe("LaunchCoordinator") {
                it("returns .launch") {
                    expect(LaunchCoordinator<MockAppStore>.self.appCoordinatorImmediateDescendent) == .launch
                }
            }

        }

    }

}
