//
//  YelpRequestBuilder.swift
//  Shared
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Foundation

class YelpRequestBuilder {

    static let searchPath = "/v3/businesses/search"
    static let maxResultsPerPage: Int = 50

    private let config: YelpRequestConfig

    init(config: YelpRequestConfig) {
        self.config = config
    }

}

extension YelpRequestBuilder: PlaceLookupRequestBuilderProtocol {

    func buildPageRequestToken(_ placeLookupParams: PlaceLookupParams,
                               startingIndex: Int,
                               resultsPerPage: Int) -> PlaceLookupPageRequestTokenResult {
        let acceptableRange = 1...YelpRequestBuilder.maxResultsPerPage
        guard acceptableRange.contains(resultsPerPage) else {
            return .failure(.invalidResultsPerPageAmount(acceptableRange: acceptableRange))
        }

        var components = config.searchURLComponents
        components.queryItems =
            placeLookupParams.queryItems + [
                URLQueryItem(name: "offset", value: String(startingIndex)),
                URLQueryItem(name: "limit", value: String(resultsPerPage)),
            ]
        guard let url = components.url else {
            return .failure(.invalidURL(components: components))
        }

        let request = URLRequest(url: url,
                                 type: .GET,
                                 headers: ["Authorization": "Bearer \(config.apiKey)"])

        return .success(PlaceLookupPageRequestToken(placeLookupParams: placeLookupParams,
                                                    urlRequest: request,
                                                    startingIndex: startingIndex,
                                                    resultsPerPage: resultsPerPage))
    }

}

private extension PlaceLookupSorting {

    var stringValue: String {
        switch self {
        case .bestMatch:
            return "best_match"
        case .distance:
            return "distance"
        case .rating:
            return "rating"
        case .reviewCount:
            return "review_count"
        }
    }

}

private extension PlaceLookupParams {

    var queryItems: [URLQueryItem] {
        return [
            URLQueryItem(name: "term", value: keywords.value),
            URLQueryItem(name: "latitude", value: String(coordinate.latitude)),
            URLQueryItem(name: "longitude", value: String(coordinate.longitude)),
            URLQueryItem(name: "radius", value: String(Int(radius.converted(to: .meters).value))),
            URLQueryItem(name: "sort_by", value: sorting.stringValue),
        ]
    }

}
