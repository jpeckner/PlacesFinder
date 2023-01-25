//
//  AppLinkTypeBuilder.swift
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
        case "settingsChild":
            return .settingsChild(SettingsChildLinkPayload())
        default:
            return nil
        }
    }

}
