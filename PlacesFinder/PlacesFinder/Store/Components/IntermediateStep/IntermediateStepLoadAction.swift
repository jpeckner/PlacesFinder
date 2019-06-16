//
//  IntermediateStepLoadAction.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Foundation
import SwiftDux

enum IntermediateStepLoadAction<E: Error & Equatable>: Action, Equatable {
    case inProgress
    case success
    case failure(E)
}
