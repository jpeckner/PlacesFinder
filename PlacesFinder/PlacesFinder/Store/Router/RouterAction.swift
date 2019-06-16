//
//  RouterAction.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import CoordiNode
import Foundation
import Shared
import SwiftDux

typealias RouterLinkType = LinkTypeProtocol & Equatable

enum RouterAction<TLinkType: RouterLinkType>: Action, Equatable {
    case setCurrentCoordinator(NodeBox)
    case setDestinationCoordinator(DestinationNodeBox, payload: TLinkType?)
    case requestLink(TLinkType)
    case clearLink
}
