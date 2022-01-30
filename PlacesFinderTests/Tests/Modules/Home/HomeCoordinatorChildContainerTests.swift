//
//  HomeCoordinatorChildContainerTests.swift
//  PlacesFinderTests
//
//  Copyright (c) 2020 Justin Peckner
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
                    case .settings,
                         .settingsChild:
                        return stubSettingsCoordinator
                    }
                }

                sut = HomeCoordinatorChildContainer(childFactory: mockFactory)
            }

            it("calls mockFactory.buildCoordinator() for each immediate child coordinator") {
                let receivedImmediateDescendents = receivedArgs.compactMap { descendent in
                    HomeCoordinatorImmediateDescendent(nodeBox: descendent.destinationNodeBox.asNodeBox)
                }
                expect(receivedImmediateDescendents) == HomeCoordinatorImmediateDescendent.allCases
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
