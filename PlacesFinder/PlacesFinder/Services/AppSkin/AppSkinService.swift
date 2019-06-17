//
//  AppSkinService.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2018 Justin Peckner. All rights reserved.
//

import Foundation
import Shared

struct AppSkinServiceErrorPayload: Decodable, Equatable {
    let message: String
}

typealias AppSkinServiceCompletion = (Result<AppSkin, DecodableServiceError<AppSkinServiceErrorPayload>>) -> Void

protocol AppSkinServiceProtocol: AutoMockable {
    func fetchAppSkin(completion: @escaping AppSkinServiceCompletion)
}

private struct DecodableAppSkin: Decodable {
    let colorings: AppColorings
}

class AppSkinService: AppSkinServiceProtocol {

    private typealias AppColoringsCompletion = DecodableServiceCompletion<DecodableAppSkin, AppSkinServiceErrorPayload>

    private let url: URL
    private let decodableService: DecodableServiceProtocol

    init(url: URL,
         decodableService: DecodableServiceProtocol) {
        self.url = url
        self.decodableService = decodableService
    }

    func fetchAppSkin(completion: @escaping AppSkinServiceCompletion) {
        fetchAppColorings { result in
            switch result {
            case let .success(decodableSkin):
                let appSkin = AppSkin(colorings: decodableSkin.colorings)
                completion(.success(appSkin))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }

    private func fetchAppColorings(completion: @escaping AppColoringsCompletion) {
        let urlRequest = URLRequest(url: url, type: .GET)
        decodableService.performRequest(urlRequest, completion: completion)
    }

}
