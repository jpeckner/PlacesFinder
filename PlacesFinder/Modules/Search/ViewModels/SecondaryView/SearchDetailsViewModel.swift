//
//  SearchDetailsViewModel+Init.swift
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

import Combine
import Shared
import SwiftDux

struct SearchDetailsViewModel: Equatable {

    enum Section: Equatable {
        case info([SearchDetailsInfoSectionViewModel])
        case location([SearchDetailsMapSectionViewModel])
    }

    let placeName: String
    private let sections: [Section]
    private let actionSubscriber: IgnoredEquatable<AnySubscriber<Search.Action, Never>>
    private let removeDetailedEntityAction: IgnoredEquatable<Search.Action>

    init(placeName: String,
         sections: [SearchDetailsViewModel.Section],
         actionSubscriber: AnySubscriber<Search.Action, Never>,
         removeDetailedEntityAction: Search.Action) {
        self.placeName = placeName
        self.sections = sections
        self.actionSubscriber = IgnoredEquatable(actionSubscriber)
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
        _ = actionSubscriber.value.receive(removeDetailedEntityAction.value)
    }

}

// MARK: SearchDetailsViewModelBuilder

// sourcery: AutoMockable
protocol SearchDetailsViewModelBuilderProtocol {
    func buildViewModel(_ entity: SearchEntityModel,
                        resultsCopyContent: SearchResultsCopyContent) -> SearchDetailsViewModel
}

class SearchDetailsViewModelBuilder: SearchDetailsViewModelBuilderProtocol {

    private let actionSubscriber: AnySubscriber<Search.Action, Never>
    private let actionPrism: SearchDetailsActionPrismProtocol
    private let urlOpenerService: URLOpenerServiceProtocol
    private let copyFormatter: SearchCopyFormatterProtocol

    init(actionSubscriber: AnySubscriber<Search.Action, Never>,
         actionPrism: SearchDetailsActionPrismProtocol,
         urlOpenerService: URLOpenerServiceProtocol,
         copyFormatter: SearchCopyFormatterProtocol) {
        self.actionSubscriber = actionSubscriber
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

        return SearchDetailsViewModel(
            placeName: entity.name.value,
            sections: sections,
            actionSubscriber: actionSubscriber,
            removeDetailedEntityAction: .searchActivity(actionPrism.removeDetailedEntityAction)
        )
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
