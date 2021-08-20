//
//  AppLinkTypeBuilder.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import CoordiNode
import Foundation
import Shared

protocol LinkTypeProtocol {
    var destinationNodeBox: DestinationNodeBox { get }
}

protocol AppLinkPayloadProtocol {}

protocol AppLinkTypeBuilderProtocol: AutoMockable {
    func buildPayload(_ url: URL) -> AppLinkType?
}

class AppLinkTypeBuilder: AppLinkTypeBuilderProtocol {

    func buildPayload(_ url: URL) -> AppLinkType? {
        guard let firstPathComponent = url.pathComponentsSansSlash.first else { return nil }

        switch firstPathComponent {
        case "search":
            let components = URLComponents(string: url.absoluteString)
            let keywordsItem = components?.queryItem(for: SearchLinkPayload.keywordsKey)
            guard let keywords = (keywordsItem?.value.flatMap { try? NonEmptyString($0) }) else {
                return .emptySearch(EmptySearchLinkPayload())
            }

            return .search(SearchLinkPayload(keywords: keywords))
        case "settings":
            return .settings(SettingsLinkPayload())
        default:
            return nil
        }
    }

}
