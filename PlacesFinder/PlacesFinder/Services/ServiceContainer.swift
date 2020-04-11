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
    let appSkinService: AppSkinServiceProtocol
    let locationRequestHandler: LocationRequestHandlerProtocol
    let placeLookupService: PlaceLookupServiceProtocol
    let routingHandler: AppRoutingHandlerProtocol
    let searchCopyFormatter: SearchCopyFormatterProtocol
    let urlOpenerService: URLOpenerServiceProtocol
}
