//
//  SpringboardHandler.swift
//  PlacesFinderUITests
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import CoreGraphics
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

        if #available(iOS 13.0, *) {
            deleteiOS13App(displayName)
        } else {
            deletePreiOS13App(icon,
                              displayName: displayName)
        }
    }

    // Source: https://stackoverflow.com/a/58696197/1342984
    @available(iOS 13.0, *)
    private func deleteiOS13App(_ displayName: String) {
        Thread.sleep(forTimeInterval: 1.0)
        let appIcon = springboardApp.icons.matching(identifier: displayName).firstMatch
        appIcon.press(forDuration: 1.3)
        Thread.sleep(forTimeInterval: 1.0)

        springboardApp.buttons["Delete App"].tap()

        let deleteButton = springboardApp.alerts.buttons["Delete"].firstMatch
        if deleteButton.waitForExistence(timeout: 5) {
            deleteButton.tap()
        }
    }

    // Source: https://stackoverflow.com/a/36168101/1342984
    private func deletePreiOS13App(_ icon: XCUIElement,
                                   displayName: String) {
        let iconFrame = icon.frame
        let springboardFrame = springboardApp.frame
        icon.press(forDuration: 1.3)

        // Tap the little "X" button at approximately where it is. The X is not exposed directly.
        let offset = CGVector(dx: (iconFrame.minX + 3) / springboardFrame.maxX,
                              dy: (iconFrame.minY + 3) / springboardFrame.maxY)
        springboardApp.coordinate(withNormalizedOffset: offset).tap()

        Thread.sleep(forTimeInterval: 2.0)
        tapAlertButton(labeled: "Delete")
    }

}
