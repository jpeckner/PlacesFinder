//
//  YelpRequestBuilder.swift
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
