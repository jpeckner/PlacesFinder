//
//  SearchResultCell.swift
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

import Shared
import SwiftUI

struct SearchResultCell: View {

    @ObservedObject var cellModel: ValueObservable<SearchResultCellModel>

    var body: some View {
        HStack {
            DownloadedImageViewSUI(imageURL: cellModel.value.image.url)
                .aspectRatio(1, contentMode: .fit)
                .cornerRadius(4)

            VStack(alignment: .leading) {
                Text(cellModel.value.name.value)
                    .modifier(
                        textStyleClass: .cellText,
                        textColoring: cellModel.value.colorings.bodyTextColoring
                    )

                HStack {
                    Image(uiImage: cellModel.value.ratingsAverage.starsImage)

                    Spacer()

                    cellModel.value.pricing.map { pricing in
                        Text(pricing)
                            .modifier(
                                textStyleClass: .pricingLabel,
                                textColoring: cellModel.value.colorings.bodyTextColoring
                            )
                    }
                }
            }

            Spacer(minLength: 16)

            Image(uiImage: Constants.disclosureArrow)
                .resizable()
                .frame(width: 12, widthToHeightRatio: Constants.disclosureArrow.widthToHeightRatio)
                .foregroundColor(Color(uiColor: cellModel.value.colorings.disclosureArrowTint.color))
        }
        .frame(height: 68)
    }

    private enum Constants {
        static let disclosureArrow = #imageLiteral(resourceName: "right_arrow").withRenderingMode(.alwaysTemplate)
    }

}
