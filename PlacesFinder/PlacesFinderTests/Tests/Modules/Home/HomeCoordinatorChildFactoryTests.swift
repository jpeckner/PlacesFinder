//
//  HomeCoordinatorChildFactoryTests.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2020 Justin Peckner. All rights reserved.
//

import Nimble
import Quick

class HomeCoordinatorChildFactoryTests: QuickSpec {

    // swiftlint:disable implicitly_unwrapped_optional
    override func spec() {

        var sut: HomeCoordinatorChildFactory<MockAppStore>!

        beforeEach {
            sut = HomeCoordinatorChildFactory(store: MockAppStore(),
                                              listenerContainer: ListenerContainer.mockValue(),
                                              serviceContainer: ServiceContainer.mockValue())
        }

        describe("buildCoordinator") {

            context("when the destinationDescendent arg is .search") {

                var result: TabCoordinatorProtocol!

                beforeEach {
                    result = sut.buildCoordinator(for: .search)
                }

                it("returns an instance of SearchCoordinator") {
                    expect(result is SearchCoordinator<MockAppStore>) == true
                }

            }

            context("else when the destinationDescendent arg is .settings") {

                var result: TabCoordinatorProtocol!

                beforeEach {
                    result = sut.buildCoordinator(for: .settings)
                }

                it("returns an instance of SettingsCoordinator") {
                    expect(result is SettingsCoordinator<MockAppStore>) == true
                }

            }

        }

    }

}
