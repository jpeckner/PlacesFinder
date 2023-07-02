//
//  SettingsCoordinatorTests.swift
//  PlacesFinderTests
//
//  Copyright (c) 2019 Justin Peckner
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

import Combine
import CoordiNodeTestComponents
import Nimble
import Quick
import Shared
import SharedTestComponents
import SwiftDux
import SwiftDuxTestComponents

class SettingsCoordinatorTests: QuickSpec {

    // swiftlint:disable force_try
    // swiftlint:disable force_unwrapping
    // swiftlint:disable function_body_length
    // swiftlint:disable implicitly_unwrapped_optional
    // swiftlint:disable line_length
    override func spec() {

        struct Dependencies {
            let stubSettingsViewModel: SettingsViewModel = {
                let sections = NonEmptyArray(with: SettingsSectionViewModel.stubValue(id: .searchDistance))
                return SettingsViewModel(
                    sections: sections,
                    colorings: AppColorings.defaultColorings.settings
                )
            }()
            let stubNavController = UINavigationController()

            let mockStore: MockAppStore
            let mockServiceContainer: ServiceContainer
            let mockSettingsPresenter: SettingsPresenterProtocolMock
            let mockSettingsViewModelBuilder: SettingsViewModelBuilderProtocolMock
            let mockNavigationBarViewModelBuilder: NavigationBarViewModelBuilderProtocolMock

            @MainActor
            init() {
                mockStore = MockAppStore()
                mockSettingsPresenter = SettingsPresenterProtocolMock()
                mockSettingsPresenter.rootNavController = stubNavController

                mockServiceContainer = ServiceContainer.mockValue()

                mockSettingsViewModelBuilder = SettingsViewModelBuilderProtocolMock()
                mockSettingsViewModelBuilder.buildViewModelSearchPreferencesStateAppCopyContentAppDisplayNameColoringsReturnValue = stubSettingsViewModel

                mockNavigationBarViewModelBuilder = NavigationBarViewModelBuilderProtocolMock()
                mockNavigationBarViewModelBuilder.buildTitleViewModelCopyContentReturnValue = .stubValue()
            }
        }

        struct TestData {
            let dependencies: Dependencies
            let coordinator: SettingsCoordinator<MockAppStore>
        }

        let testStorage = AsyncStorage<TestData>()

        beforeEach {
            Task { @MainActor in
                let dependencies = Dependencies()
                let coordinator = SettingsCoordinator(
                    store: dependencies.mockStore,
                    presenter: dependencies.mockSettingsPresenter,
                    serviceContainer: dependencies.mockServiceContainer,
                    settingsViewModelBuilder: dependencies.mockSettingsViewModelBuilder,
                    navigationBarViewModelBuilder: dependencies.mockNavigationBarViewModelBuilder
                )
                let testData = TestData(dependencies: dependencies,
                                        coordinator: coordinator)

                await testStorage.setElement(testData)
            }

            try! await Task.sleep(nanoseconds: 100_000_000)
        }

        describe("init") {

            it("subscribes to its relevant key paths") {
                let testData = await testStorage.element!
                let substatesSubscription =
                    testData.dependencies.mockStore.receivedSubscriptions.last?.subscription
                    as? SubstatesSubscription<SettingsCoordinator<MockAppStore>>

                expect(substatesSubscription?.subscribedPaths.count) == 2
                expect(substatesSubscription?.subscribedPaths.keys.contains(\AppState.searchPreferencesState)) == true
            }

        }

        describe("TabCoordinatorProtocol") {

            describe("rootViewController") {
                it("returns presenter.rootNavController") {
                    Task { @MainActor in
                        let testData = await testStorage.element!
                        expect(testData.coordinator.rootViewController) === testData.dependencies.stubNavController
                    }

                    try! await Task.sleep(nanoseconds: 100_000_000)
                }
            }

        }

        describe("SubstatesSubscriber") {

            describe("newState()") {

                @Sendable func performTest(linkType: AppLinkType?) async {
                    let testData = await testStorage.element!

                    let state = AppState.stubValue(
                        routerState: RouterState(loadState: linkType.map { .waitingForPayloadToBeCleared($0) } ?? .idle,
                                                 currentNode: StubNode.nodeBox)
                    )

                    testData.coordinator.newState(state: state,
                                                  updatedSubstates: [])
                }

                it("calls presenter.loadSettingsView()") {
                    let testData = await testStorage.element!
                    let presenter = testData.dependencies.mockSettingsPresenter

                    Task { @MainActor in
                        expect(presenter.loadSettingsViewTitleViewModelAppSkinCalled) == false
                        await performTest(linkType: nil)
                        await expect(presenter.loadSettingsViewTitleViewModelAppSkinCalled).toEventually(beTrue())
                    }

                    try! await Task.sleep(nanoseconds: 100_000_000)
                }

                context("when the state has a pending linkType of type SettingsLinkPayload") {
                    beforeEach {
                        await performTest(linkType: .settings(SettingsLinkPayload()))
                    }

                    it("dispatches AppRouterAction.clearLink") {
                        let testData = await testStorage.element!
                        await expect(testData.dependencies.mockStore.hasDispatchedRouterClearLinkAction)
                            .toEventually(beTrue())
                    }
                }

                context("else when the state has a pending linkType of a different type") {
                    var verificationBlock: NoDispatchVerificationBlock!

                    beforeEach {
                        let testData = await testStorage.element!
                        verificationBlock = self.verifyNoDispatches(from: testData.dependencies.mockStore) {
                            Task {
                                await performTest(linkType: .emptySearch(EmptySearchLinkPayload()))
                            }
                        }

                        try! await Task.sleep(nanoseconds: 100_000_000)
                    }

                    it("does not dispatch an action") {
                        verificationBlock()
                    }
                }

                context("else when the state does not have a linkType") {
                    var verificationBlock: NoDispatchVerificationBlock!

                    beforeEach {
                        let testData = await testStorage.element!
                        verificationBlock = self.verifyNoDispatches(from: testData.dependencies.mockStore) {
                            Task {
                                await performTest(linkType: nil)
                            }
                        }

                        try! await Task.sleep(nanoseconds: 100_000_000)
                    }

                    it("does not dispatch an action") {
                        verificationBlock()
                    }
                }

            }

        }

    }

}
