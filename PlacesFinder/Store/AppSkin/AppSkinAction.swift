//
//  AppSkinAction.swift
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
import SwiftDux

enum AppSkinAction: Action {
    case startLoadSkin
}

enum AppSkinMiddleware {

    static func loadSkinMiddleware(skinService: AppSkinServiceProtocol) -> Middleware<AppState> {
        return { dispatch, _ in
            return { next in
                return { action in
                    guard case AppSkinAction.startLoadSkin = action else {
                        next(action)
                        return
                    }

                    dispatch(GuaranteedEntityAction<AppSkin>.inProgress)

                    skinService.fetchAppSkin { result in
                        switch result {
                        case let .success(appSkin):
                            dispatch(GuaranteedEntityAction<AppSkin>.success(appSkin))
                        case let .failure(error):
                            let entityError = EntityError.loadError(underlyingError: EquatableError(error))
                            dispatch(GuaranteedEntityAction<AppSkin>.failure(entityError))
                        }
                    }
                }
            }
        }
    }

}
