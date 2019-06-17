//
//  AppSkinActionCreator.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2018 Justin Peckner. All rights reserved.
//

import Foundation
import Shared
import SwiftDux

protocol AppSkinActionCreatorProtocol: ResettableAutoMockable {
    static func loadSkin(skinService: AppSkinServiceProtocol) -> Action
}

enum AppSkinActionCreator: AppSkinActionCreatorProtocol, GuaranteedEntityActionCreator {

    static func loadSkin(skinService: AppSkinServiceProtocol) -> Action {
        return loadGuaranteedEntity(.nonThrowing(skinService.fetchAppSkin))
    }

}
