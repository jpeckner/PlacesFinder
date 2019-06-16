//
//  SkeletonMakeable.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import SkeletonView
import UIKit

extension UIView {

    func makeSkeletonable(recursive: Bool = true) {
        self.isSkeletonable = true

        if recursive {
            subviews.forEach { $0.makeSkeletonable(recursive: recursive) }
        }
    }

}
