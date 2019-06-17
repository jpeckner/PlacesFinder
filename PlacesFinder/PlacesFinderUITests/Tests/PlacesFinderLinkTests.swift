//
//  PlacesFinderLinkTests.swift
//  PlacesFinderUITests
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Swifter
import XCTest

class PlacesFinderLinkTests: XCTestCase {

    private static let appDisplayName = "PlacesFinder"
    private static let urlBase = "placesFinder://com.justinpeckner.placesfinder"

    // swiftlint:disable implicitly_unwrapped_optional
    private var server: HttpServer!
    private var app: XCUIApplication!
    private var safariHandler: SafariHandler!
    private var springboardHandler: SpringboardHandler!
    // swiftlint:enable implicitly_unwrapped_optional

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        safariHandler = SafariHandler()
        springboardHandler = SpringboardHandler()

        server = HttpServer()
        server["v3/businesses/search"] = { _ in
            HttpResponse.ok(.text(fakeResponse))
        }
    }

    func testEmptySearchLinkLaunchesAppToSearchView() {
        launchApp(with: "search")
        enableLocationServices()

        XCTAssertTrue(app.textFields["Search nearby"].exists)
    }

    func testSearchLinkLaunchesAppToSearchViewAndExecutesSearch() {
        startServer()
        launchApp(with: "search?keywords=McDonald's%20restaurant")
        enableLocationServices()

        XCTAssertTrue(app.textFields["McDonald's restaurant"].exists)

        Thread.sleep(forTimeInterval: 5.0)
        let firstResult = app.staticTexts["BJ's Restaurant & Brewhouse"]
        XCTAssertTrue(firstResult.exists)
        XCTAssertTrue(app.staticTexts["Outback Steakhouse"].exists)
        XCTAssertTrue(app.staticTexts["YAYOI"].exists)

        firstResult.tap()
        Thread.sleep(forTimeInterval: 3.0)
        XCTAssertTrue(app.staticTexts["10690 N De Anza Blvd\nCupertino, CA 95014"].exists)
    }

    func testSettingsLinkLaunchesAppToSettingsView() {
        launchApp(with: "settings")

        XCTAssertTrue(app.staticTexts["SORT RESULTS BY"].exists)
    }

}

private extension PlacesFinderLinkTests {

    func startServer() {
        guard let portString = ProcessInfo().environment["TEST_PLACE_LOOKUP_PORT"] else {
            XCTFail("TEST_PLACE_LOOKUP_PORT environment variable must be set")
            return
        }

        guard let port = UInt16(portString) else {
            XCTFail("Invalid UInt16 value: \(portString)")
            return
        }

        do {
            try server.start(port, forceIPv4: true)
        } catch {
            XCTFail("\(error)")
        }
    }

    func launchApp(with linkPath: String) {
        try? springboardHandler.deleteApp(app, displayName: PlacesFinderLinkTests.appDisplayName)

        // Call app.launch() to install the latest build of the app, but then immediately terminate it, since we want to
        // test that the app can be launched via deep link
        app.launch()
        app.terminate()

        safariHandler.launch()
        safariHandler.openLink("\(PlacesFinderLinkTests.urlBase)/\(linkPath)")

        let navTitleElement = app.staticTexts[PlacesFinderLinkTests.appDisplayName]
        waitUntilElementExists(navTitleElement,
                               timeout: 10.0)
    }

    func enableLocationServices() {
        Thread.sleep(forTimeInterval: 0.5)
        springboardHandler.tapAlertButton(labeled: "Allow")
    }

}
