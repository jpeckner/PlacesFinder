//
//  SafariHandler.swift
//  PlacesFinderUITests
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import XCTest

class SafariHandler {

    private let safariApp: XCUIApplication

    init() {
        self.safariApp = XCUIApplication(bundleIdentifier: "com.apple.mobilesafari")
    }

    func launch() {
        safariApp.launch()
    }

    func openLink(_ link: String) {
        safariApp.textFields["Search or enter website name"].tap()
        safariApp.typeText(link)
        safariApp.keyboards.buttons["Go"].tap()

        safariApp.buttons["Open"].tap()
    }

}
