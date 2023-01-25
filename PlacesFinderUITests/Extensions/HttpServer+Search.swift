//
//  HttpServer+Search.swift
//  PlacesFinderUITests
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
