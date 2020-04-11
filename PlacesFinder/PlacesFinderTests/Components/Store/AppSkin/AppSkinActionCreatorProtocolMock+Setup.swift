//
//  AppSkinActionCreatorProtocolMock+Setup.swift
//  PlacesFinderTests
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import SwiftDux

enum StubAppSkinAction: Action {
    case loadSkin
}

extension AppSkinActionCreatorProtocolMock {

    static func setup() {
        AppSkinActionCreatorProtocolMock.loadSkinSkinServiceReset()
        AppSkinActionCreatorProtocolMock.loadSkinSkinServiceReturnValue = StubAppSkinAction.loadSkin
    }

}
