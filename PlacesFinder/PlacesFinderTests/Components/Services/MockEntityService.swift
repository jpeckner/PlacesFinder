//
//  MockEntityService.swift
//  PlacesFinderTests
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Foundation
import Shared
import SharedTestComponents

class MockEntityService {

    private let returnedResult: Result<StubEntity, StubError>
    private let responseQueue: DispatchQueue

    private(set) var fetchStubEntityCalled = false

    init(returnedResult: Result<StubEntity, StubError>,
         responseQueue: DispatchQueue = .global()) {
        self.returnedResult = returnedResult
        self.responseQueue = responseQueue
    }

    func fetchStubEntity(completion: @escaping (Result<StubEntity, StubError>) -> Void) {
        fetchStubEntityCalled = true

        responseQueue.async {
            completion(self.returnedResult)
        }
    }

}
