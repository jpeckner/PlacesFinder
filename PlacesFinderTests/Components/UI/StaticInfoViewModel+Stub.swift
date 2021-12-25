//
//  StaticInfoViewModel+Stub.swift
//  PlacesFinderTests
//
//  Created by Justin Peckner.
//  Copyright © 2020 Justin Peckner. All rights reserved.
//

import Foundation

extension StaticInfoViewModel {

    static func stubValue(imageName: String = "stubStaticInfoImageName",
                          title: String = "stubStaticInfoTitle",
                          description: String = "stubStaticInfoDescription") -> StaticInfoViewModel {
        return StaticInfoViewModel(imageName: imageName,
                                   title: title,
                                   description: description)
    }

}
