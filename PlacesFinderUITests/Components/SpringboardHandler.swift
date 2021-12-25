//
//  SpringboardHandler.swift
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
