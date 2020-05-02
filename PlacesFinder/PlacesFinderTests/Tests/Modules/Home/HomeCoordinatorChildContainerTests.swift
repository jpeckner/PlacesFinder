//
//  HomeCoordinatorChildContainerTests.swift
//  PlacesFinderTests
//
//  Created by Justin Peckner.
//  Copyright © 2020 Justin Peckner. All rights reserved.
//

import Nimble
import Quick
import UIKit

class HomeCoordinatorChildContainerTests: QuickSpec {

    // swiftlint:disable function_body_length
    // swiftlint:disable implicitly_unwrapped_optional
    override func spec() {

        let stubSearchRootController = UIViewController()
        let stubSearchCoordinator = TabCoordinatorProtocolMock()
        stubSearchCoordinator.rootViewController = stubSearchRootController

        let stubSettingsRootController = UIViewController()
        let stubSettingsCoordinator = TabCoordinatorProtocolMock()
        stubSettingsCoordinator.rootViewController = stubSettingsRootController

        var sut: HomeCoordinatorChildContainer<HomeCoordinatorChildFactoryProtocolMock<MockAppStore>>!

        beforeEach {
            sut = HomeCoordinatorChildContainer(search: stubSearchCoordinator,
                                                settings: stubSettingsCoordinator)
        }

        describe("init(childFactory:)") {

            var receivedArgs: [HomeCoordinatorDestinationDescendent]!

            beforeEach {
                receivedArgs = []

                let mockFactory = HomeCoordinatorChildFactoryProtocolMock<MockAppStore>()
                mockFactory.buildCoordinatorForClosure = {
                    receivedArgs.append($0)

                    switch $0 {
                    case .search:
                        return stubSearchCoordinator
                    case .settings:
                        return stubSettingsCoordinator
                    }
                }

                sut = HomeCoordinatorChildContainer(childFactory: mockFactory)
            }

            it("calls mockFactory.buildCoordinator() for each child coordinator") {
                expect(receivedArgs) == HomeCoordinatorDestinationDescendent.allCases
            }

            it("assigns each child property to the expected coordinator") {
                expect(sut.coordinator(for: .search)) === stubSearchCoordinator

                expect(sut.coordinator(for: .settings)) === stubSettingsCoordinator
            }

        }

        describe("init(search:settings:)") {

            it("assigns each child property to the expected coordinator") {
                expect(sut.coordinator(for: .search)) === stubSearchCoordinator

                expect(sut.coordinator(for: .settings)) === stubSettingsCoordinator
            }

        }

        describe("orderedChildCoordinators") {

            it("returns the coordinators in the expected order") {
                let coordinators = sut.orderedChildCoordinators

                expect(coordinators.count) == 2
                expect(coordinators[0]) === stubSearchCoordinator
                expect(coordinators[1]) === stubSettingsCoordinator
            }

        }

        describe("orderedChildViewControllers") {

            it("returns the coordinators' view controllers in the expected order") {
                let viewControllers = sut.orderedChildViewControllers

                expect(viewControllers.count) == 2
                expect(viewControllers[0]) === stubSearchRootController
                expect(viewControllers[1]) === stubSettingsRootController
            }

        }

        describe("coordinator(childType:)") {

            let expectedResults: [HomeCoordinatorImmediateDescendent: TabCoordinatorProtocol] = [
                .search: stubSearchCoordinator,
                .settings: stubSettingsCoordinator,
            ]

            for descendent in HomeCoordinatorImmediateDescendent.allCases {

                context("when the descendent arg is \(descendent)") {
                    var result: TabCoordinatorProtocol!

                    beforeEach {
                        result = sut.coordinator(for: descendent)
                    }

                    it("returns the expected coordinator") {
                        expect(result) === expectedResults[descendent]
                    }
                }

            }

        }

    }

}
