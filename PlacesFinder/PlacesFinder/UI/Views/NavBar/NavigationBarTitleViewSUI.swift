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

    @State var title: String

    var body: some View {
        HStack {
            Image(uiImage: #imageLiteral(resourceName: "magnifying_glass"))

            StyledLabelSUI(text: title,
                           styleClass: .navBarTitle)
        }
    }

}

@available(iOS 13.0, *)
struct NavigationBarTitleViewSUI_Previews: PreviewProvider {
    static var previews: some View {
        NavigationBarTitleViewSUI(title: "Placeholder")
    }
}
