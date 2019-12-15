//
//  NavigationBarTitleViewSUI.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Shared
import SwiftUI

@available(iOS 13.0, *)
struct NavigationBarTitleViewSUI: View {

    private let title: String

    init(title: String) {
        self.title = title
    }

    var body: some View {
        HStack {
            Image(uiImage: #imageLiteral(resourceName: "magnifying_glass"))

            StyledLabelSUI(text: title,
                           styleClass: .navBarTitle)
        }
    }

}
