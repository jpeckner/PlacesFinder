//
//  ServiceContainer.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2018 Justin Peckner. All rights reserved.
//

import CoordiNode
import Shared

struct ServiceContainer {
    let appRoutingHandler: AppRoutingHandlerProtocol
    let appSkinService: AppSkinServiceProtocol
    let locationRequestHandler: LocationRequestHandlerProtocol
    let placeLookupService: PlaceLookupServiceProtocol
    let searchCopyFormatter: SearchCopyFormatterProtocol
    let urlOpenerService: URLOpenerServiceProtocol
}
