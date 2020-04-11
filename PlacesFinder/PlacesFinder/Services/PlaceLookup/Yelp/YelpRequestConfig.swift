//
//  YelpRequestConfig.swift
//  Shared
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Foundation

enum YelpRequestConfigError: Error {
    case invalidURLComponents
}

struct YelpRequestConfig {
    let apiKey: String
    let searchURLComponents: URLComponents
}

extension YelpRequestConfig {

     init(apiKey: String, baseURL: URL) throws {
        self.apiKey = apiKey

        let searchURL = baseURL.appendingPathComponent(YelpRequestBuilder.searchPath)
        guard let searchURLComponents = URLComponents(url: searchURL, resolvingAgainstBaseURL: true) else {
            throw YelpRequestConfigError.invalidURLComponents
        }
        self.searchURLComponents = searchURLComponents
    }

}
