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

    init(placeName: String,
         sections: [SearchDetailsViewModel.Section],
         store: DispatchingStoreProtocol,
         removeDetailedEntityAction: Action) {
        self.placeName = placeName
        self.sections = sections
        self.store = IgnoredEquatable(store)
        self.removeDetailedEntityAction = IgnoredEquatable(removeDetailedEntityAction)
    }

}

extension SearchDetailsViewModel {

    var sectionsCount: Int {
        return sections.count
    }

    func section(sectionIndex: Int) -> Section {
        return sections[sectionIndex]
    }

    func cellViewModels(sectionIndex: Int) -> [SearchDetailsSectionProtocol] {
        switch section(sectionIndex: sectionIndex) {
        case let .info(viewModels as [SearchDetailsSectionProtocol]),
             let .location(viewModels as [SearchDetailsSectionProtocol]):
            return viewModels
        }
    }

    func cellViewModel(sectionIndex: Int,
                       rowIndex: Int) -> SearchDetailsSectionProtocol {
        return cellViewModels(sectionIndex: sectionIndex)[rowIndex]
    }

}

extension SearchDetailsViewModel {

    func dispatchRemoveDetailsAction() {
        store.value.dispatch(removeDetailedEntityAction.value)
    }

}

// MARK: SearchDetailsViewModelBuilder

protocol SearchDetailsViewModelBuilderProtocol: AutoMockable {
    func buildViewModel(_ entity: SearchEntityModel,
                        resultsCopyContent: SearchResultsCopyContent) -> SearchDetailsViewModel
}

class SearchDetailsViewModelBuilder: SearchDetailsViewModelBuilderProtocol {

    private let store: DispatchingStoreProtocol
    private let actionPrism: SearchDetailsActionPrismProtocol
    private let urlOpenerService: URLOpenerServiceProtocol
    private let copyFormatter: SearchCopyFormatterProtocol

    init(store: DispatchingStoreProtocol,
         actionPrism: SearchDetailsActionPrismProtocol,
         urlOpenerService: URLOpenerServiceProtocol,
         copyFormatter: SearchCopyFormatterProtocol) {
        self.store = store
        self.actionPrism = actionPrism
        self.urlOpenerService = urlOpenerService
        self.copyFormatter = copyFormatter
    }

    func buildViewModel(_ entity: SearchEntityModel,
                        resultsCopyContent: SearchResultsCopyContent) -> SearchDetailsViewModel {
        let sections = [
            entity.buildInfoSection(urlOpenerService,
                                    copyFormatter: copyFormatter,
                                    resultsCopyContent: resultsCopyContent),
            entity.buildLocationSection(copyFormatter),
        ].compactMap { $0 }

        return SearchDetailsViewModel(placeName: entity.name.value,
                                      sections: sections,
                                      store: store,
                                      removeDetailedEntityAction: actionPrism.removeDetailedEntityAction)
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
            image: DownloadedImageViewModel(url: image),
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
