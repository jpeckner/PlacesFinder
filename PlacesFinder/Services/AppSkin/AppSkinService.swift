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

    func fetchAppSkin(completion: @escaping AppSkinServiceCompletion) {
        // This previously fetched the skin from an API, but the introduction of Dark Mode in iOS 13 has mostly obviated
        // the desire for custom skins in an app. However, the previous infrastructure remains in place as an example of
        // how to build a modular, multi-layered app architecture.
        let appSkin = AppSkin(colorings: AppColorings.defaultColorings)
        completion(.success(appSkin))
    }

}
