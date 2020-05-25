//
//  DownloadedImageViewModel.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2020 Justin Peckner. All rights reserved.
//

import Foundation

struct DownloadedImageViewModel: Equatable {
    let url: URL
    let placeholderName: String
}

extension DownloadedImageViewModel {

    init(url: URL) {
        self.init(url: url,
                  placeholderName: "magnifying_glass")
    }

}
