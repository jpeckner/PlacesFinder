//
//  StaticInfoViewModel.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2020 Justin Peckner. All rights reserved.
//

import Foundation

struct StaticInfoViewModel {
    let imageName: String
    let title: String
    let description: String
}

protocol StaticInfoCopyProtocol {
    var iconImageName: String { get }
    var title: String { get }
    var description: String { get }
}

extension StaticInfoCopyProtocol {

    var staticInfoViewModel: StaticInfoViewModel {
        return StaticInfoViewModel(imageName: iconImageName,
                                   title: title,
                                   description: description)
    }

}
