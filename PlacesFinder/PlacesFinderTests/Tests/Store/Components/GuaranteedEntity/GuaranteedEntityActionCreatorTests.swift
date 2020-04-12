//
//  GuaranteedEntityActionCreatorTests.swift
//  PlacesFinderTests
//
//  Created by Justin Peckner.
//  Copyright © 2018 Justin Peckner. All rights reserved.
//

import Nimble
import Quick
import Shared
import SharedTestComponents
import SwiftDuxTestComponents

private enum TestGuaranteedEntityActionCreator: GuaranteedEntityActionCreator {}

class GuaranteedEntityActionCreatorTests: QuickSpec {

    // swiftlint:disable function_body_length
    // swiftlint:disable implicitly_unwrapped_optional
    override func spec() {

        describe("loadGuaranteedEntity") {

            let stubEntity = StubEntity.stubValue()

            var mockStore: MockAppStore!

            beforeEach {
                mockStore = MockAppStore()
            }

            context("when the load block is non-throwing") {

                var mockService: MockEntityService!

                func performTest(returnedResult: Result<StubEntity, StubError>,
                                 actionWaitCount: Int = 2) {
                    mockService = MockEntityService(returnedResult: returnedResult)
                    let loadBlock = EntityLoadBlock.nonThrowing(mockService.fetchStubEntity)

                    waitFor(mockStore, toReachNonAsyncActionCount: actionWaitCount) {
                        mockStore.dispatch(TestGuaranteedEntityActionCreator.loadGuaranteedEntity(loadBlock))
                    }
                }

                it("dispatches GuaranteedEntityAction.inProgress") {
                    performTest(returnedResult: .failure(StubError.plainError),
                                actionWaitCount: 1)

                    let dispatchedAction = mockStore.dispatchedNonAsyncActions.first
                    expect(dispatchedAction as? GuaranteedEntityAction<StubEntity>) == .inProgress
                }

                it("calls mockEntityService.fetchStubEntity") {
                    performTest(returnedResult: .failure(StubError.plainError),
                                actionWaitCount: 1)
                    expect(mockService.fetchStubEntityCalled) == true
                }

                context("when the load block returns success") {
                    beforeEach {
                        performTest(returnedResult: .success(stubEntity))
                    }

                    it("dispatches GuaranteedEntityAction.success") {
                        verifySuccess()
                    }
                }

                context("else when the load block returns failure") {
                    beforeEach {
                        performTest(returnedResult: .failure(StubError.plainError))
                    }

                    it("dispatches GuaranteedEntityAction.fallback") {
                        verifyLoadError()
                    }
                }
            }

            context("else when the load block is throwing") {

                var mockService: MockThrowingEntityService!

                func performTest(courseOfAction: MockThrowingEntityService.CourseOfAction,
                                 actionWaitCount: Int) {
                    mockService = MockThrowingEntityService(courseOfAction: courseOfAction)
                    let loadBlock = EntityLoadBlock.throwing(mockService.fetchStubEntity)

                    waitFor(mockStore, toReachNonAsyncActionCount: actionWaitCount) {
                        mockStore.dispatch(TestGuaranteedEntityActionCreator.loadGuaranteedEntity(loadBlock))
                    }
                }

                it("dispatches GuaranteedEntityAction.inProgress") {
                    performTest(courseOfAction: .throwError(StubError.thrownError),
                                actionWaitCount: 1)

                    let dispatchedAction = mockStore.dispatchedNonAsyncActions.first
                    expect(dispatchedAction as? GuaranteedEntityAction<StubEntity>) == .inProgress
                }

                it("calls mockEntityService.fetchStubEntity") {
                    performTest(courseOfAction: .throwError(StubError.thrownError),
                                actionWaitCount: 1)

                    expect(mockService.fetchStubEntityCalled) == true
                }

                context("when the load block throws an error") {
                    beforeEach {
                        performTest(courseOfAction: .throwError(StubError.thrownError),
                                    actionWaitCount: 2)
                    }

                    it("dispatches GuaranteedEntityAction.failure(.preloadError)") {
                        verifyPreloadError()
                    }
                }

                context("else when the load block returns failure") {
                    beforeEach {
                        performTest(courseOfAction: .callbackWithResult(.failure(StubError.plainError)),
                                    actionWaitCount: 2)
                    }

                    it("dispatches GuaranteedEntityAction.fallback") {
                        verifyLoadError()
                    }
                }

                context("else when the load block returns success") {
                    beforeEach {
                        performTest(courseOfAction: .callbackWithResult(.success(stubEntity)),
                                    actionWaitCount: 2)
                    }

                    it("dispatches GuaranteedEntityAction.success") {
                        verifySuccess()
                    }
                }
            }

            func verifyPreloadError() {
                let dispatchedAction = mockStore.dispatchedNonAsyncActions.last as? GuaranteedEntityAction<StubEntity>
                let underlyingError = IgnoredEquatable<Error>(StubError.thrownError)
                expect(dispatchedAction) == .failure(.preloadError(underlyingError: underlyingError))
            }

            func verifyLoadError() {
                let dispatchedAction = mockStore.dispatchedNonAsyncActions.last as? GuaranteedEntityAction<StubEntity>
                let underlyingError = IgnoredEquatable<Error>(StubError.plainError)
                expect(dispatchedAction) == .failure(.loadError(underlyingError: underlyingError))
            }

            func verifySuccess() {
                let dispatchedAction = mockStore.dispatchedNonAsyncActions.last as? GuaranteedEntityAction<StubEntity>
                expect(dispatchedAction) == .success(stubEntity)
            }

        }

    }

}
