//
//  SearchDetailsInfoSectionViewModel.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Foundation
import Shared

struct SearchDetailsBasicInfoViewModel: Equatable {
    let image: DownloadedImageViewModel
    let name: NonEmptyString
    let address: NonEmptyString?
    let ratingsAverage: SearchRatingValue
    let numRatingsMessage: String
    let pricing: String?
    let apiLinkCallback: IgnoredEquatable<OpenURLBlock>?
}

struct SearchDetailsPhoneNumberViewModel: Equatable {
    let phoneLabelText: String
    let makeCallBlock: IgnoredEquatable<OpenURLBlock>?
}

enum SearchDetailsInfoSectionViewModel: Equatable {
    // sourcery: cellType = "SearchDetailsBasicInfoCell"
    case basicInfo(SearchDetailsBasicInfoViewModel)

    // sourcery: cellType = "SearchDetailsPhoneNumberCell"
    case phoneNumber(SearchDetailsPhoneNumberViewModel)
}
