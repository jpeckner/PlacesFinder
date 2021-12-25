//
//  DecodableServices.swift
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
