//
//  MockThrowingEntityService.swift
//  PlacesFinderTests
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Foundation
import Shared
import SharedTestComponents

class MockThrowingEntityService {

    enum CourseOfAction {
        case throwError(Error)
        case callbackWithResult(Result<StubEntity, StubError>)
    }

    private let courseOfAction: CourseOfAction
    private let responseQueue: DispatchQueue

    private(set) var fetchStubEntityCalled = false

    init(courseOfAction: CourseOfAction,
         responseQueue: DispatchQueue = .global()) {
        self.courseOfAction = courseOfAction
        self.responseQueue = responseQueue
    }

    func fetchStubEntity(completion: @escaping (Result<StubEntity, StubError>) -> Void) throws {
        fetchStubEntityCalled = true

        switch courseOfAction {
        case let .throwError(error):
            throw error
        case let .callbackWithResult(result):
            responseQueue.async {
                completion(result)
            }
        }
    }

}
