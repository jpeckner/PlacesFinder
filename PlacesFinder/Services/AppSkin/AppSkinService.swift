//
//  AppSkinService.swift
//  PlacesFinder
//
//  Copyright (c) 2018 Justin Peckner
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

// Note: this needs to be declared public to avoid a compile error on `extension DecodableServiceError: Equatable` below
// periphery:ignore
public struct AppSkinServiceErrorPayload: Decodable, Equatable {}

typealias AppSkinServiceError = DecodableServiceError<AppSkinServiceErrorPayload>

extension DecodableServiceError: Equatable where TErrorPayload == AppSkinServiceErrorPayload {

    public static func == (
        lhs: Shared.DecodableServiceError<TErrorPayload>,
        rhs: Shared.DecodableServiceError<TErrorPayload>
    ) -> Bool {
        switch (lhs, rhs) {
        case let (.errorPayloadReturned(lhsPayload, _), .errorPayloadReturned(rhsPayload, _)):
            return lhsPayload == rhsPayload

        case (.errorPayloadReturned, .unexpected),
             (.unexpected, .errorPayloadReturned),
             (.unexpected, .unexpected):
            return false
        }
    }

}

// MARK: - AppSkinService

// sourcery: AutoMockable
protocol AppSkinServiceProtocol {
    func fetchAppSkin() async -> Result<AppSkin, AppSkinServiceError>
}

class AppSkinService: AppSkinServiceProtocol {

    func fetchAppSkin() async -> Result<AppSkin, AppSkinServiceError> {
        // This previously fetched the skin from an API, but the introduction of Dark Mode in iOS 13 has mostly obviated
        // the desire for custom skins in an app. However, the previous infrastructure remains in place as an example of
        // how to build a modular, multi-layered app architecture.
        let appSkin = AppSkin(colorings: AppColorings.defaultColorings)
        return .success(appSkin)
    }

}
