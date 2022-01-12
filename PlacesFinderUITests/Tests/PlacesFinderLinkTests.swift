//
//  PlacesFinderLinkTests.swift
//  PlacesFinderUITests
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

import Swifter
import XCTest

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
        server.configureSearchEndpoints()

        installFreshApp()
    }

}

extension PlacesFinderLinkTests {

    func testEmptySearchLinkLaunchesAppToSearchView() {
        launchApp(with: "search")
        enableLocationServices()

        XCTAssertTrue(app.searchFields["Search nearby"].exists)
    }

}

extension PlacesFinderLinkTests {

    func testSearchLinkLaunchesAppToSearchViewAndExecutesSearch() {
        server.start()

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

        XCUIDevice.shared.press(.home)
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
                                placeNames: placeNames)
        verifyDetailsView(detailedPlace)

        app.navigationBars[detailedPlace.name].buttons["Back"].tap()
        verifySearchResultsView(keywords: keywords,
                                placeNames: placeNames)
    }

    private func verifySearchResultsView(keywords: String,
                                         placeNames: [String]) {
        Thread.sleep(forTimeInterval: 2.0)

        XCTAssertTrue(app.navigationBars.staticTexts[PlacesFinderLinkTests.appDisplayName].exists)

        // Identifying the text inputted into UISearchBar appears to be broken in Xcode 11.X:
        //   https://stackoverflow.com/questions/58907895/xcuitest-failed-to-find-matching-element
        //   https://stackoverflow.com/questions/58682989/cannot-find-search-bar-in-ui-tests
        // Comment this line back in once Apple has fixed this issue.
//        XCTAssertTrue(app.searchFields["Search nearby"].textFields[keywords].exists)

        placeNames.forEach {
            XCTAssertTrue(app.staticTexts[$0].exists)
        }
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

    func installFreshApp() {
        app.resetAuthorizationStatus(for: .location)
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
        Thread.sleep(forTimeInterval: 1.0)
        springboardHandler.tapAlertButton(labeled: allowButtonText)
        Thread.sleep(forTimeInterval: 1.0)
    }

    var allowButtonText: String {
        "Allow While Using App"
    }

}

private struct PlaceDetails {
    let name: String
    let address: String
    let numReviews: Int
    let phoneNumber: String
}
