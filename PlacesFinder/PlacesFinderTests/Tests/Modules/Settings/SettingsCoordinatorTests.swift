//
//  SettingsCoordinatorTests.swift
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
import Shared
import SharedTestComponents
import SwiftDux
import SwiftDuxTestComponents

class SettingsCoordinatorTests: QuickSpec {

    // swiftlint:disable function_body_length
    // swiftlint:disable implicitly_unwrapped_optional
    override func spec() {

        let stubViewModel: SettingsViewModel = {
            let sections = NonEmptyArray(with: SettingsSectionViewModel.stubValue(id: 0))
            return SettingsViewModel(sections: sections)
        }()
        let stubNavController = UINavigationController()

        var mockStore: MockAppStore!
        var mockSettingsPresenter: SettingsPresenterProtocolMock!
        var coordinator: SettingsCoordinator<MockAppStore>!

        beforeEach {
            mockStore = MockAppStore()
            mockSettingsPresenter = SettingsPresenterProtocolMock()
            mockSettingsPresenter.rootNavController = stubNavController

            let mockViewModelBuilder = SettingsViewModelBuilderProtocolMock()
            mockViewModelBuilder.buildViewModelSearchPreferencesStateAppCopyContentReturnValue = stubViewModel

            coordinator = SettingsCoordinator(store: mockStore,
                                              presenter: mockSettingsPresenter,
                                              viewModelBuilder: mockViewModelBuilder)
        }

        describe("init") {

            it("subscribes to its relevant key paths") {
                let substatesSubscription =
                    mockStore.receivedSubscriptions.last?.subscription
                    as? SubstatesSubscription<SettingsCoordinator<MockAppStore>>

                expect(substatesSubscription?.subscribedPaths.count) == 1
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
                        expect(mockStore.dispatchedNonAsyncActions.contains {
                            ($0 as? AppRouterAction) == .clearLink
                        }) == true
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
