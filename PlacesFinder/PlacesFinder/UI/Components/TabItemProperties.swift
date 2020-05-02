//
//  TabItemProperties.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Shared
import UIKit

struct TabItemProperties {
    let imageName: String
}

extension UIViewController {

    // https://developer.apple.com/design/human-interface-guidelines/ios/icons-and-images/custom-icons/ lists specific
    // heights to use at the URL below, but using them with vector images, such as
    // https://stackoverflow.com/a/37627080/1342984 describes, results in the images being too small. Using 32x32 tab
    // icons displays the desired size correctly on all current iPhones and iPads.
    private static let tabImageSize = CGSize(width: 32.0, height: 32.0)

    func configure(_ properties: TabItemProperties) {
        guard let image = UIImage(named: properties.imageName) else { return }

        let templateImage = image.withRenderingMode(.alwaysTemplate)
        tabBarItem.image = templateImage.with(size: UIViewController.tabImageSize)
    }

}

extension UITabBarController {

    // Concept for method from https://stackoverflow.com/a/46392579/1342984
    func adjustTabImageInsets(_ horizontalSizeClass: SpecifiedSizeClass) {
        tabBar.items?.forEach {
            switch horizontalSizeClass {
            case .compact:
                $0.imageInsets = UIEdgeInsets(top: 6.0, left: 0.0, bottom: -6.0, right: 0.0)
            case .regular:
                $0.imageInsets = .zero
            }
        }
    }

}
