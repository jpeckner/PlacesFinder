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

    // swiftlint:disable function_body_length
    // swiftlint:disable implicitly_unwrapped_optional
    // swiftlint:disable line_length
    override func spec() {

        let stubSettingsViewModel: SettingsViewModel = {
            let sections = NonEmptyArray(with: SettingsSectionViewModel.stubValue())
            return SettingsViewModel(sections: sections)
        }()
        let stubNavController = UINavigationController()

        var mockStore: MockAppStore!
        var mockServiceContainer: ServiceContainer!
        var mockSettingsPresenter: SettingsPresenterProtocolMock!
        var mockSettingsViewModelBuilder: SettingsViewModelBuilderProtocolMock!
        var mockNavigationBarViewModelBuilder: NavigationBarViewModelBuilderProtocolMock!

        var coordinator: SettingsCoordinator<MockAppStore>!

        beforeEach {
            mockStore = MockAppStore()
            mockSettingsPresenter = SettingsPresenterProtocolMock()
            mockSettingsPresenter.rootNavController = stubNavController

            mockServiceContainer = ServiceContainer.mockValue()

            mockSettingsViewModelBuilder = SettingsViewModelBuilderProtocolMock()
            mockSettingsViewModelBuilder.buildViewModelSearchPreferencesStateAppCopyContentReturnValue = stubSettingsViewModel

            mockNavigationBarViewModelBuilder = NavigationBarViewModelBuilderProtocolMock()
            mockNavigationBarViewModelBuilder.buildTitleViewModelCopyContentReturnValue = .stubValue()

            coordinator = SettingsCoordinator(store: mockStore,
                                              presenter: mockSettingsPresenter,
                                              serviceContainer: mockServiceContainer,
                                              settingsViewModelBuilder: mockSettingsViewModelBuilder,
                                              navigationBarViewModelBuilder: mockNavigationBarViewModelBuilder)
        }

        describe("init") {

            it("subscribes to its relevant key paths") {
                let substatesSubscription =
                    mockStore.receivedSubscriptions.last?.subscription
                    as? SubstatesSubscription<SettingsCoordinator<MockAppStore>>

                expect(substatesSubscription?.subscribedPaths.count) == 2
                expect(substatesSubscription?.subscribedPaths.keys.contains(\AppState.searchPreferencesState)) == true
            }

        }

        describe("TabCoordinatorProtocol") {

            describe("rootViewController") {
                it("returns presenter.rootNavController") {
                    expect(coordinator.rootViewController) === stubNavController
                }
            }

        }

        describe("SubstatesSubscriber") {

            describe("newState()") {

                func performTest(linkType: AppLinkType?) {
                    let state = AppState.stubValue(
                        routerState: RouterState(loadState: linkType.map { .waitingForPayloadToBeCleared($0) } ?? .idle,
                                                 currentNode: StubNode.nodeBox)
                    )

                    coordinator.newState(state: state,
                                         updatedSubstates: [])
                }

                it("calls presenter.loadSettingsView()") {
                    expect(mockSettingsPresenter.loadSettingsViewTitleViewModelAppSkinCalled) == false
                    performTest(linkType: nil)
                    expect(mockSettingsPresenter.loadSettingsViewTitleViewModelAppSkinCalled) == true
                }

                context("when the state has a pending linkType of type SettingsLinkPayload") {
                    beforeEach {
                        performTest(linkType: .settings(SettingsLinkPayload()))
                    }

                    it("dispatches AppRouterAction.clearLink") {
                        expect(mockStore.hasDispatchedRouterClearLinkAction) == true
                    }
                }

                context("else when the state has a pending linkType of a different type") {
                    var verificationBlock: NoDispatchVerificationBlock!

                    beforeEach {
                        verificationBlock = self.verifyNoDispatches(from: mockStore) {
                            performTest(linkType: .emptySearch(EmptySearchLinkPayload()))
                        }
                    }

                    it("does not dispatch an action") {
                        verificationBlock()
                    }
                }

                context("else when the state does not have a linkType") {
                    var verificationBlock: NoDispatchVerificationBlock!

                    beforeEach {
                        verificationBlock = self.verifyNoDispatches(from: mockStore) {
                            performTest(linkType: nil)
                        }
                    }

                    it("does not dispatch an action") {
                        verificationBlock()
                    }
                }

            }

        }

    }

}
