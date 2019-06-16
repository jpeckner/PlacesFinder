//
//  DecodableServices.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Foundation
import Shared

struct DecodableServices {

    let quickTimeoutDecodableService: DecodableService
    let standardTimeoutDecodableService: DecodableService

    init() {
        let responseQueue = DispatchQueue(label: "NetworkDataService.responseQueue")
        let decoder = JSONDecoder()

        let quickTimeoutConfig = URLSessionConfiguration.default
        quickTimeoutConfig.timeoutIntervalForResource = 3.0
        let quickTimeoutSession = URLSession(configuration: quickTimeoutConfig)
        self.quickTimeoutDecodableService = DecodableService(urlSession: quickTimeoutSession,
                                                             responseQueue: responseQueue,
                                                             decoder: decoder)

        let standardTimeoutSession = URLSession.shared
        self.standardTimeoutDecodableService = DecodableService(urlSession: standardTimeoutSession,
                                                                responseQueue: responseQueue,
                                                                decoder: decoder)
    }

}

private extension DecodableService {

    convenience init(urlSession: URLSession,
                     responseQueue: DispatchQueue,
                     decoder: DecoderProtocol) {
        let networkDataService = NetworkDataService(urlSession: urlSession,
                                                    responseQueue: responseQueue)
        let httpService = HTTPService(networkDataService: networkDataService)

        self.init(httpService: httpService,
                  decoder: decoder)
    }

}
