//
//  DownloadedImageView.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Kingfisher
import Shared
import UIKit

class DownloadedImageView: UIImageView {

    private let placeholderImage: UIImage
    private var downloadTask: DownloadTask?

    init(contentMode: ContentMode = .scaleAspectFit,
         placeholderImage: UIImage = #imageLiteral(resourceName: "magnifying_glass")) {
        self.placeholderImage = placeholderImage

        super.init(image: placeholderImage)

        self.contentMode = contentMode
        tintColor = .label(alternative: .black)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureImage(_ url: URL?) {
        downloadTask = kf.setImage(with: url,
                                   placeholder: placeholderImage)
    }

    func cancelImageDownload() {
        downloadTask?.cancel()
    }

}
