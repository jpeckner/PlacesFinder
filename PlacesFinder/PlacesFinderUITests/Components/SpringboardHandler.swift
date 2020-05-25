//
//  SpringboardHandler.swift
//  PlacesFinderUITests
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import XCTest

class SpringboardHandler {

    private let springboardApp: XCUIApplication

    init() {
        self.springboardApp = XCUIApplication(bundleIdentifier: "com.apple.springboard")
        springboardApp.activate()
    }

    func tapAlertButton(labeled label: String) {
        guard let alertElement = springboardApp.alerts.allElementsBoundByIndex.first,
            alertElement.buttons[label].exists
        else {
            XCTFail("No button found with label \(label)")
            return
        }

        alertElement.buttons[label].tap()
    }

    func deleteApp(_ application: XCUIApplication,
                   displayName: String) {
        application.terminate()

        let icon = springboardApp.icons[displayName]
        guard icon.exists else {
            return
        }

        deleteiOS13App(displayName)
    }

    // Source: https://stackoverflow.com/a/58696197/1342984
    private func deleteiOS13App(_ displayName: String) {
        Thread.sleep(forTimeInterval: 1.0)
        let appIcon = springboardApp.icons.matching(identifier: displayName).firstMatch
        appIcon.press(forDuration: 1.3)
        Thread.sleep(forTimeInterval: 1.0)

        springboardApp.buttons["Delete App"].tap()

        let deleteButton = springboardApp.alerts.buttons["Delete"].firstMatch
        guard deleteButton.waitForExistence(timeout: 5) else {
            return
        }

        deleteButton.tap()
    }

}
