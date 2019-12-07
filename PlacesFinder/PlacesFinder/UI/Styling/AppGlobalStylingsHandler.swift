//
//  AppGlobalStylingsHandler.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Shared

protocol AppGlobalStylingsHandlerProtocol: AutoMockable {
    func apply(_ appSkin: AppSkin)
}

class AppGlobalStylingsHandler: AppGlobalStylingsHandlerProtocol {

    func apply(_ appSkin: AppSkin) {
        let navBarAppearance = UINavigationBar.appearance()
        navBarAppearance.barTintColor = appSkin.colorings.navBar.viewColoring.backgroundColor

        let tabBarAppearance = UITabBar.appearance()
        tabBarAppearance.tintColor = appSkin.colorings.tabBar.selectedItemTint.color
        tabBarAppearance.unselectedItemTintColor = appSkin.colorings.tabBar.unselectedItemTint.color
        tabBarAppearance.barTintColor = appSkin.colorings.tabBar.viewColoring.backgroundColor
    }

}
