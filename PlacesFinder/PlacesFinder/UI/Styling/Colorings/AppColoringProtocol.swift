//
//  AppColoringProtocol.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Foundation
import Shared

// Views with poorly-contrasting colors (such as navy-blue text on a black background) are a particularly nefarious bug.
// This can occur when the app's hard-coded colors don't mix with colors sent from the API, or if the app's hard-coded
// colors don't mix with themselves (due to programmer error).
//
// To help solve this, each distinct view in the app (typically a full-screen view, but also stand-alone views like the
// nav bar and tab bar) is styled with exactly one AppColoringProtocol. This intentionally forces us- as well as whoever
// manages colors sent from the API- to think about each view's colors holistically. While it can't eliminate the
// possibility of incompatible colors, it does greatly reduce the risk.
protocol AppColoringProtocol: Decodable, Equatable {}

protocol AppStandardColoringsProtocol {
    var viewColoring: ViewColoring { get }
    var titleTextColoring: TextColoring { get }
    var bodyTextColoring: TextColoring { get }
}

extension AppStandardColoringsProtocol {

    var standard: AppStandardColorings {
        return AppStandardColorings(viewColoring: viewColoring,
                                    titleTextColoring: titleTextColoring,
                                    bodyTextColoring: bodyTextColoring)
    }

}

// sourcery: fieldName = "standard"
struct AppStandardColorings: AppColoringProtocol, AppStandardColoringsProtocol {
    let viewColoring: ViewColoring
    let titleTextColoring: TextColoring
    let bodyTextColoring: TextColoring
}

// sourcery: fieldName = "navBar"
struct NavBarColorings: AppColoringProtocol {
    let viewColoring: ViewColoring
    let iconTintColoring: FillColoring
    let backArrowTint: FillColoring
    let titleTextColoring: TextColoring
}

// sourcery: fieldName = "tabBar"
struct TabBarColorings: AppColoringProtocol {
    let viewColoring: ViewColoring
    let selectedItemTint: FillColoring
    let unselectedItemTint: FillColoring
}
