//
//  PlacesFinderLinkTests.swift
//  PlacesFinderUITests
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Swifter
import XCTest

private struct PlaceDetails {
    let name: String
    let address: String
    let numReviews: Int
    let phoneNumber: String
}

class PlacesFinderLinkTests: XCTestCase {

    private static let appDisplayName = "PlacesFinder"
    private static let urlBase = "placesFinder://com.justinpeckner.PlacesFinder"

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
        server["v3/businesses/search"] = { request in
            guard request.method == "GET",
                let term = (request.queryParams.first { $0.0 == "term" })?.1,
                let requestType = FakeSearchRequest(rawValue: term)
            else {
                return HttpResponse.badRequest(nil)
            }

            return HttpResponse.ok(.text(requestType.response))
        }

        installFreshApp()
    }

}

extension PlacesFinderLinkTests {

    func testEmptySearchLinkLaunchesAppToSearchView() {
        launchApp(with: "search")
        enableLocationServices()

        XCTAssertTrue(app.textFields["Search nearby"].exists)
    }

}

extension PlacesFinderLinkTests {

    func testSearchLinkLaunchesAppToSearchViewAndExecutesSearch() {
        startServer()

        launchApp(with: "search?keywords=Fast%20casual%20restaurants")
        enableLocationServices()
        verifySearch(
            keywords: "Fast casual restaurants",
            placeNames: [
                "BJ's Restaurant & Brewhouse",
                "Outback Steakhouse",
                "YAYOI",
            ],
            detailedPlace: PlaceDetails(
                name: "BJ's Restaurant & Brewhouse",
                address: "10690 N De Anza Blvd Cupertino, CA 95014",
                numReviews: 1609,
                phoneNumber: "(408) 865-6970"
            )
        )

        XCUIDevice.shared.press(XCUIDevice.Button.home)
        launchApp(with: "search?keywords=Go%20Karts")
        verifySearch(
            keywords: "Go Karts",
            placeNames: [
                "K1 Speed",
                "LeMans Karting",
                "Sky High Sports - Santa Clara",
            ],
            detailedPlace: PlaceDetails(
                name: "Sky High Sports - Santa Clara",
                address: "2880 Mead Ave Santa Clara, CA 95051",
                numReviews: 564,
                phoneNumber: "(408) 496-5867"
            )
        )
    }

    private func verifySearch(keywords: String,
                              placeNames: [String],
                              detailedPlace: PlaceDetails) {
        verifySearchResultsView(keywords: keywords,
                                placeNames: placeNames,
                                waitForResults: true)
        verifyDetailsView(detailedPlace)

        app.navigationBars[detailedPlace.name].buttons["Back"].tap()
        verifySearchResultsView(keywords: keywords,
                                placeNames: placeNames,
                                waitForResults: false)
    }

    private func verifySearchResultsView(keywords: String,
                                         placeNames: [String],
                                         waitForResults: Bool) {
        XCTAssertTrue(app.navigationBars.staticTexts[PlacesFinderLinkTests.appDisplayName].exists)
        XCTAssertTrue(app.textFields[keywords].exists)
        if waitForResults { Thread.sleep(forTimeInterval: 2.0) }
        placeNames.forEach { XCTAssertTrue(app.staticTexts[$0].exists) }
    }

    private func verifyDetailsView(_ placeDetails: PlaceDetails) {
        app.staticTexts[placeDetails.name].tap()
        Thread.sleep(forTimeInterval: 2.0)

        XCTAssertTrue(app.navigationBars[placeDetails.name].exists)
        XCTAssertTrue(app.staticTexts[placeDetails.name].exists)
        XCTAssertTrue(app.staticTexts[placeDetails.address].exists)
        let reviewsText = "\(placeDetails.numReviews) \(placeDetails.numReviews == 1 ? "review" : "reviews")"
        XCTAssertTrue(app.staticTexts[reviewsText].exists)
        XCTAssertTrue(app.staticTexts[placeDetails.phoneNumber].exists)
    }

}

extension PlacesFinderLinkTests {

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

    func installFreshApp() {
        try? springboardHandler.deleteApp(app, displayName: PlacesFinderLinkTests.appDisplayName)

        // Call app.launch() to install the latest build of the app, but then immediately terminate it, since we want to
        // test that the app can be launched via deep link
        app.launch()
        app.terminate()
    }

    func launchApp(with linkPath: String) {
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
