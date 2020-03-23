//
//  SearchDetailsViewModel+Init.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Shared
import SwiftDux

struct SearchDetailsViewModel: Equatable {
    enum Section: Equatable {
        case info([SearchDetailsInfoSectionViewModel])
        case location([SearchDetailsMapSectionViewModel])
    }

    let placeName: String
    let sections: [Section]
    private let store: IgnoredEquatable<DispatchingStoreProtocol>
    private let removeDetailedEntityAction: IgnoredEquatable<Action>
}

extension SearchDetailsViewModel {

    init(entity: SearchEntityModel,
         store: DispatchingStoreProtocol,
         actionPrism: SearchDetailsActionPrismProtocol,
         urlOpenerService: URLOpenerServiceProtocol,
         copyFormatter: SearchCopyFormatterProtocol,
         resultsCopyContent: SearchResultsCopyContent) {
        self.placeName = entity.name.value
        self.sections = [
            entity.buildInfoSection(urlOpenerService,
                                    copyFormatter: copyFormatter,
                                    resultsCopyContent: resultsCopyContent),
            entity.buildLocationSection(copyFormatter)
        ].compactMap { $0 }

        self.store = IgnoredEquatable(store)
        self.removeDetailedEntityAction = IgnoredEquatable(actionPrism.removeDetailedEntityAction)
    }

}

extension SearchDetailsViewModel {

    func dispatchRemoveDetailsAction() {
        store.value.dispatch(removeDetailedEntityAction.value)
    }

}

private extension SearchEntityModel {

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

private extension SearchEntityModel {

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
