//
//  DownloadedImageView.swift
//  PlacesFinder
//
//  Copyright (c) 2019 Justin Peckner
//  
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//  
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//  
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import Kingfisher
import Shared
import SwiftUI
import UIKit

struct DownloadedImageViewSUI: View {

    private let imageURL: URL
    private let placeholderImage: Image

    init(imageURL: URL,
         placeholderImage: Image = Image(uiImage: #imageLiteral(resourceName: "magnifying_glass"))) {
        self.imageURL = imageURL
        self.placeholderImage = placeholderImage
    }

    var body: some View {
        KFImage(imageURL)
            .placeholder { _ in
                placeholderImage
            }
            .resizable()
    }

}

class DownloadedImageView: UIImageView {

    private let placeholderImage: UIImage
    private var downloadTask: DownloadTask?

    init(contentMode: ContentMode = .scaleAspectFit,
         placeholderImage: UIImage = #imageLiteral(resourceName: "magnifying_glass")) {
        self.placeholderImage = placeholderImage

        super.init(image: placeholderImage)

        self.contentMode = contentMode
        tintColor = .label
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension DownloadedImageView {

    func configure(_ viewModel: DownloadedImageViewModel) {
        downloadTask = kf.setImage(with: viewModel.url,
                                   placeholder: placeholderImage)
    }

    func cancelImageDownload() {
        downloadTask?.cancel()
    }

}
