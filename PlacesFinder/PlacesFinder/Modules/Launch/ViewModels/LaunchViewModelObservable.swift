//
//  LaunchViewModelObservable.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Foundation

@available(iOS 13.0, *)
class LaunchViewModelObservable: ObservableObject {
    @Published var isAnimating = false
}
