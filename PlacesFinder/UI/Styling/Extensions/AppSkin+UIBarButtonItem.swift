//
//  AppSkin+UIBarButtonItem.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import UIKit

extension AppSkin {

    var backButtonItem: UIBarButtonItem {
        let imageView = UIImageView(widthConstrainedImage: #imageLiteral(resourceName: "left_arrow"))
        imageView.contentMode = .scaleAspectFit

        // Set width to a decent size so it's easily tappable
        let item = UIBarButtonItem(customView: imageView)
        item.width = 44.0
        item.tintColor = colorings.navBar.backArrowTint.color
        return item
    }

}
