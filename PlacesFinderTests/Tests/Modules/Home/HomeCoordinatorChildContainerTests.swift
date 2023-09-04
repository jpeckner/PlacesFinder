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
import SharedTestComponents
import UIKit

// swiftlint:disable blanket_disable_command
// swiftlint:disable force_try
// swiftlint:disable force_unwrapping
// swiftlint:disable function_body_length
// swiftlint:disable implicitly_unwrapped_optional
// swiftlint:disable line_length
class HomeCoordinatorChildContainerTests: QuickSpec {

    override func spec() {

        typealias ChildContainerType = HomeCoordinatorChildContainer<HomeCoordinatorChildFactoryProtocolMock<MockAppStore>>

        struct Dependencies {
            let stubSearchRootController = UIViewController()
            let stubSearchCoordinator = TabCoordinatorProtocolMock()
            let stubSettingsRootController = UIViewController()
            let stubSettingsCoordinator = TabCoordinatorProtocolMock()

            @MainActor init() {
                stubSearchCoordinator.rootViewController = stubSearchRootController
                stubSettingsCoordinator.rootViewController = stubSettingsRootController
            }
        }

        struct TestData {
            let sut: ChildContainerType
            let dependencies: Dependencies
        }

        let testStorage = AsyncStorage<TestData>()

        beforeEach {
            Task { @MainActor in
                let dependencies = Dependencies()
                let sut = ChildContainerType(search: dependencies.stubSearchCoordinator,
                                             settings: dependencies.stubSettingsCoordinator)
                let testData = TestData(sut: sut,
                                        dependencies: dependencies)
                await testStorage.setElement(testData)
            }
            try! await Task.sleep(nanoseconds: 100_000_000)
        }

        describe("init(childFactory:)") {

            var receivedArgs: [HomeCoordinatorDestinationDescendent]!

            beforeEach {
                receivedArgs = []

                let mockFactory = HomeCoordinatorChildFactoryProtocolMock<MockAppStore>()
                let dependencies = await testStorage.element!.dependencies

                mockFactory.buildCoordinatorForClosure = {
                    receivedArgs.append($0)

                    switch $0 {
                    case .search:
                        return dependencies.stubSearchCoordinator
                    case .settings,
                         .aboutApp:
                        return dependencies.stubSettingsCoordinator
                    }
                }

                let updatedTestData = await TestData(
                    sut: HomeCoordinatorChildContainer(childFactory: mockFactory),
                    dependencies: dependencies
                )
                await testStorage.setElement(updatedTestData)
            }

            it("calls mockFactory.buildCoordinator() for each immediate child coordinator") {
                let receivedImmediateDescendents = receivedArgs.compactMap { descendent in
                    HomeCoordinatorImmediateDescendent(nodeBox: descendent.destinationNodeBox.asNodeBox)
                }
                expect(receivedImmediateDescendents) == HomeCoordinatorImmediateDescendent.allCases
            }

            it("assigns each child property to the expected coordinator") {
                let testData = await testStorage.element!

                let searchResult = await testData.sut.coordinator(for: .search)
                expect(searchResult) === testData.dependencies.stubSearchCoordinator

                let settingsResult = await testData.sut.coordinator(for: .settings)
                expect(settingsResult) === testData.dependencies.stubSettingsCoordinator
            }

        }

        describe("init(search:settings:)") {

            it("assigns each child property to the expected coordinator") {
                let testData = await testStorage.element!

                let searchResult = await testData.sut.coordinator(for: .search)
                expect(searchResult) === testData.dependencies.stubSearchCoordinator

                let settingsResult = await testData.sut.coordinator(for: .settings)
                expect(settingsResult) === testData.dependencies.stubSettingsCoordinator
            }

        }

        describe("orderedChildCoordinators") {

            it("returns the coordinators in the expected order") {
                let testData = await testStorage.element!
                let coordinators = await testData.sut.orderedChildCoordinators

                expect(coordinators.count) == 2
                expect(coordinators[0]) === testData.dependencies.stubSearchCoordinator
                expect(coordinators[1]) === testData.dependencies.stubSettingsCoordinator
            }

        }

        describe("orderedChildViewControllers") {

            it("returns the coordinators' view controllers in the expected order") {
                let testData = await testStorage.element!
                let viewControllers = await testData.sut.orderedChildViewControllers

                expect(viewControllers.count) == 2
                expect(viewControllers[0]) === testData.dependencies.stubSearchRootController
                expect(viewControllers[1]) === testData.dependencies.stubSettingsRootController
            }

        }

        describe("coordinator(childType:)") {

            for descendent in HomeCoordinatorImmediateDescendent.allCases {

                context("when the descendent arg is \(descendent)") {
                    var result: TabCoordinatorProtocol!

                    beforeEach {
                        result = await testStorage.element!.sut.coordinator(for: descendent)
                    }

                    it("returns the expected coordinator") {
                        let testData = await testStorage.element!
                        let expectedResults: [HomeCoordinatorImmediateDescendent: TabCoordinatorProtocol] = [
                            .search: testData.dependencies.stubSearchCoordinator,
                            .settings: testData.dependencies.stubSettingsCoordinator,
                        ]

                        expect(result) === expectedResults[descendent]
                    }
                }

            }

        }

    }

}
// swiftlint:enable blanket_disable_command
