//
//  ServiceContainer+Mock.swift
//  PlacesFinderTests
//
//  Created by Justin Peckner.
//  Copyright © 2018 Justin Peckner. All rights reserved.
//

import CoordiNode
import Foundation
import Shared
import SharedTestComponents

extension ServiceContainer {

    static func mockValue(
        appSkinService: AppSkinServiceProtocol = AppSkinServiceProtocolMock(),
        locationRequestHandler: LocationRequestHandlerProtocol = LocationRequestHandlerProtocolMock(),
        placeLookupService: PlaceLookupServiceProtocol = PlaceLookupServiceProtocolMock(),
        routingHandler: AppRoutingHandlerProtocol = AppRoutingHandlerProtocolMock(),
        searchCopyFormatter: SearchCopyFormatterProtocol = SearchCopyFormatterProtocolMock(),
        urlOpenerService: URLOpenerServiceProtocol = URLOpenerServiceProtocolMock()
    ) -> ServiceContainer {
        return ServiceContainer(appSkinService: appSkinService,
                                locationRequestHandler: locationRequestHandler,
                                placeLookupService: placeLookupService,
                                routingHandler: routingHandler,
                                searchCopyFormatter: searchCopyFormatter,
                                urlOpenerService: urlOpenerService)
    }

}
