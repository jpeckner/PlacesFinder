//
//  StaticInfoViewModel.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2020 Justin Peckner. All rights reserved.
//

import Foundation
import UIKit

struct StaticInfoViewModel {
    let image: UIImage
    let title: String
    let description: String
}

protocol StaticInfoCopyProtocol {
    var iconImage: UIImage { get }
    var title: String { get }
    var description: String { get }
}

extension StaticInfoCopyProtocol {

    var staticInfoViewModel: StaticInfoViewModel {
        return StaticInfoViewModel(image: iconImage,
                                   title: title,
                                   description: description)
    }

}
