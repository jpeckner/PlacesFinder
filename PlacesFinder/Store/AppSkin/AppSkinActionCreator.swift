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
        let action: AppAsyncAction = loadGuaranteedEntity(.nonThrowing(skinService.fetchAppSkin))
        return action
    }

}
