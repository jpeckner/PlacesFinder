//
//  AppColoringProtocol.swift
//  PlacesFinder
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
