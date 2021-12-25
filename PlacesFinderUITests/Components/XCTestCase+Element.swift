//
//  XCTestCase+Element.swift
//  PlacesFinderUITests
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import XCTest

extension XCTestCase {

    func waitUntilElementExists(_ element: XCUIElement,
                                timeout: TimeInterval = 5.0) {
        let predicate = NSPredicate(format: "exists == true")
        let existanceEpectation = expectation(for: predicate,
                                              evaluatedWith: element,
                                              handler: nil)
        wait(for: [existanceEpectation], timeout: timeout)
    }

}
