//
//  AppChildCoordinatorTests.swift
//  PlacesFinderTests
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Nimble
import Quick

class AppChildCoordinatorTests: QuickSpec {

    private typealias THomeCoordinatorFactory = HomeCoordinatorChildFactoryProtocolMock<MockAppStore>

    override func spec() {

        describe("AppCoordinatorChildProtocol") {

            describe("HomeCoordinator") {
                it("returns .home") {
                    expect(HomeCoordinator<THomeCoordinatorFactory>.self.appCoordinatorImmediateDescendent) == .home
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
