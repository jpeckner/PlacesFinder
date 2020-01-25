//
//  SearchDetailsViewModel+Init.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Shared
import SwiftDux

enum SearchDetailsViewContext {
    case detailedEntity(SearchDetailsViewModel)
    case firstListedEntity(SearchDetailsViewModel)
}

struct SearchDetailsViewModel: Equatable {
    enum Section: Equatable {
        case info([SearchDetailsInfoSectionViewModel])
        case location([SearchDetailsMapSectionViewModel])
    }

    let placeName: String
    let sections: [Section]
}

extension SearchDetailsViewModel {

    init(searchDetailsModel: SearchDetailsModel,
         urlOpenerService: URLOpenerServiceProtocol,
         copyFormatter: SearchCopyFormatterProtocol,
         resultsCopyContent: SearchResultsCopyContent) {
        self.placeName = searchDetailsModel.name.value
        self.sections = [
            searchDetailsModel.buildInfoSection(urlOpenerService,
                                                copyFormatter: copyFormatter,
                                                resultsCopyContent: resultsCopyContent),
            searchDetailsModel.buildLocationSection(copyFormatter)
        ].compactMap { $0 }
    }

}

private extension SearchDetailsModel {

    func buildInfoSection(_ urlOpenerService: URLOpenerServiceProtocol,
                          copyFormatter: SearchCopyFormatterProtocol,
                          resultsCopyContent: SearchResultsCopyContent) -> SearchDetailsViewModel.Section {
        return .info([
            placeDetailsCellModel(urlOpenerService,
                                  copyFormatter: copyFormatter,
                                  resultsCopyContent: resultsCopyContent),
            phoneNumberCellModel(urlOpenerService,
                                 copyFormatter: copyFormatter,
                                 resultsCopyContent: resultsCopyContent)
        ].compactMap { $0 })
    }

    private func placeDetailsCellModel(
        _ urlOpenerService: URLOpenerServiceProtocol,
        copyFormatter: SearchCopyFormatterProtocol,
        resultsCopyContent: SearchResultsCopyContent
    ) -> SearchDetailsInfoSectionViewModel {
        return .basicInfo(SearchDetailsBasicInfoViewModel(
            image: image,
            name: name,
            address: addressLines.map { copyFormatter.formatAddress($0) },
            ratingsAverage: ratings.average,
            numRatingsMessage: copyFormatter.formatRatings(resultsCopyContent,
                                                           numRatings: ratings.numRatings),
            pricing: pricing.map { copyFormatter.formatPricing(resultsCopyContent, pricing: $0) },
            apiLinkCallback: urlOpenerService.buildOpenURLBlock(url).map { IgnoredEquatable($0) }
        ))
    }

    private func phoneNumberCellModel(
        _ urlOpenerService: URLOpenerServiceProtocol,
        copyFormatter: SearchCopyFormatterProtocol,
        resultsCopyContent: SearchResultsCopyContent
    ) -> SearchDetailsInfoSectionViewModel? {
        guard let displayPhone = displayPhone else { return nil }

        let makeCallBlock = dialablePhone.flatMap { urlOpenerService.buildPhoneCallBlock($0) }
        let phoneLabelText = makeCallBlock != nil ?
            copyFormatter.formatCallablePhoneNumber(resultsCopyContent, displayPhone: displayPhone)
            : copyFormatter.formatNonCallablePhoneNumber(displayPhone)

        return .phoneNumber(SearchDetailsPhoneNumberViewModel(
            phoneLabelText: phoneLabelText,
            makeCallBlock: makeCallBlock.map { IgnoredEquatable($0) }
        ))
    }

}

private extension SearchDetailsModel {

    func buildLocationSection(_ copyFormatter: SearchCopyFormatterProtocol) -> SearchDetailsViewModel.Section? {
        guard let coordinate = coordinate else { return nil }

        return .location([
            .mapCoordinate(SearchDetailsMapCoordinateViewModel(
                placeName: name,
                address: addressLines.map { copyFormatter.formatAddress($0) },
                coordinate: coordinate,
                regionRadius: PlaceLookupDistance(value: 2500, unit: .meters)
            ))
        ])
    }

}
