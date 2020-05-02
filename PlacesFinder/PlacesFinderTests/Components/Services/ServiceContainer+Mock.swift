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
        appRoutingHandler: AppRoutingHandlerProtocol = AppRoutingHandlerProtocolMock(),
        appSkinService: AppSkinServiceProtocol = AppSkinServiceProtocolMock(),
        locationRequestHandler: LocationRequestHandlerProtocol = LocationRequestHandlerProtocolMock(),
        placeLookupService: PlaceLookupServiceProtocol = PlaceLookupServiceProtocolMock(),
        searchCopyFormatter: SearchCopyFormatterProtocol = SearchCopyFormatterProtocolMock(),
        urlOpenerService: URLOpenerServiceProtocol = URLOpenerServiceProtocolMock()
    ) -> ServiceContainer {
        return ServiceContainer(appRoutingHandler: appRoutingHandler,
                                appSkinService: appSkinService,
                                locationRequestHandler: locationRequestHandler,
                                placeLookupService: placeLookupService,
                                searchCopyFormatter: searchCopyFormatter,
                                urlOpenerService: urlOpenerService)
    }

}
