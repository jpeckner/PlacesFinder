//
//  SpringboardHandler.swift
//  PlacesFinderUITests
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import CoreGraphics
import XCTest

enum SpringboardHandlerError: Error {
    case appNotFound(displayName: String)
}

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

    // Source: https://stackoverflow.com/a/36168101/1342984
    func deleteApp(_ application: XCUIApplication,
                   displayName: String) throws {
        application.terminate()

        let icon = springboardApp.icons[displayName]
        guard icon.exists else {
            throw SpringboardHandlerError.appNotFound(displayName: displayName)
        }

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
