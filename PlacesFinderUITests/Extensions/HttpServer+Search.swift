//
//  HttpServer+Search.swift
//  PlacesFinderUITests
//
//  Created by Justin Peckner.
//  Copyright © 2020 Justin Peckner. All rights reserved.
//

import Swifter
import XCTest

extension HttpServer {

    func start() {
        guard let portString = ProcessInfo().environment["TEST_PLACE_LOOKUP_PORT"] else {
            XCTFail("TEST_PLACE_LOOKUP_PORT environment variable must be set")
            return
        }

        guard let port = UInt16(portString) else {
            XCTFail("Invalid UInt16 value: \(portString)")
            return
        }

        do {
            try start(port, forceIPv4: true)
        } catch {
            XCTFail("\(error)")
        }
    }

    func configureSearchEndpoints() {
        self["v3/businesses/search"] = { request in
            guard request.method == "GET",
                let term = (request.queryParams.first { $0.0 == "term" })?.1,
                let requestType = FakeSearchRequest(rawValue: term)
            else {
                return HttpResponse.badRequest(nil)
            }

            return HttpResponse.ok(.text(requestType.response))
        }
    }

}
