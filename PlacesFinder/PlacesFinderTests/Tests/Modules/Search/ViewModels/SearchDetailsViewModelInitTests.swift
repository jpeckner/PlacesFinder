//
//  SearchDetailsViewModelInitTests.swift
//  PlacesFinderTests
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Nimble
#if DEBUG
@testable import PlacesFinder
#endif
import Quick
import Shared
import SharedTestComponents

class SearchDetailsViewModelInitTests: QuickSpec {

    // swiftlint:disable function_body_length
    // swiftlint:disable implicitly_unwrapped_optional
    override func spec() {

        let stubModel = SearchEntityModel.stubValue()
        let stubCopyContent = SearchResultsCopyContent.stubValue()

        var mockURLOpenerService: URLOpenerServiceProtocolMock!
        var mockCopyFormatter: SearchCopyFormatterProtocolMock!

        var result: SearchDetailsViewModel!

        // swiftlint:disable line_length
        beforeEach {
            mockURLOpenerService = URLOpenerServiceProtocolMock()

            mockCopyFormatter = SearchCopyFormatterProtocolMock()
            mockCopyFormatter.formatAddressReturnValue = .stubValue("formatAddressReturnValue")
            mockCopyFormatter.formatCallablePhoneNumberDisplayPhoneReturnValue = "formatCallablePhoneNumberDisplayPhoneReturnValue"
            mockCopyFormatter.formatNonCallablePhoneNumberReturnValue = "formatNonCallablePhoneNumberReturnValue"
            mockCopyFormatter.formatRatingsNumRatingsReturnValue = "formatRatingsNumRatingsReturnValue"
            mockCopyFormatter.formatPricingPricingReturnValue = "formatPricingPricingReturnValue"
        }
        // swiftlint:enable line_length

        func performTest(entity: SearchEntityModel) {
            result = SearchDetailsViewModel(entity: entity,
                                            urlOpenerService: mockURLOpenerService,
                                            copyFormatter: mockCopyFormatter,

                                            resultsCopyContent: stubCopyContent)
        }

        describe("placeName") {
            beforeEach {
                performTest(entity: stubModel)
            }

            it("has the same place name as the passed-in model") {
                expect(result.placeName) == stubModel.name.value
            }
        }

        describe(".info section") {

            func returnedSection() -> SearchDetailsViewModel.Section? {
                return result.sections.element(at: SearchDetailsViewModel.Section.infoSectionIndex)
            }

            var blockCalled: Bool!

            beforeEach {
                blockCalled = false
                mockURLOpenerService.buildOpenURLBlockReturnValue = {
                    blockCalled = true
                }

                performTest(entity: stubModel)
            }

            it("includes SearchDetailsViewModel.Section.info") {
                guard case .info? = returnedSection() else {
                    fail("Unexpected value found: \(String(describing: returnedSection()))")
                    return
                }
            }

            describe(".info") {

                func returnedViewModel() -> SearchDetailsInfoSectionViewModel? {
                    return returnedSection()?.infoSectionViewModels?[0]
                }

                it("contains .info as a viewmodel, with the model's name...") {
                    expect(returnedViewModel()?.infoViewModel?.name) == stubModel.name
                }

                it("...and with the address returned by mockCopyFormatter.formatAddress()...") {
                    expect(returnedViewModel()?.infoViewModel?.address) == mockCopyFormatter.formatAddressReturnValue
                }

                it("...and with the model's ratingsAverage...") {
                    expect(returnedViewModel()?.infoViewModel?.ratingsAverage) == stubModel.ratings.average
                }

                // swiftlint:disable line_length
                it("...and with the ratings returned by mockCopyFormatter.formatRatings()...") {
                    expect(returnedViewModel()?.infoViewModel?.numRatingsMessage) == "formatRatingsNumRatingsReturnValue"
                }
                // swiftlint:enable line_length

                it("...and with the pricing returned by mockCopyFormatter.formatPricing()...") {
                    expect(returnedViewModel()?.infoViewModel?.pricing) == "formatPricingPricingReturnValue"
                }

                it("...and the block returned from buildOpenURLBlock()") {
                    expect(blockCalled) == false
                    returnedViewModel()?.infoViewModel?.apiLinkCallback?.value()
                    expect(blockCalled) == true
                }

            }

            describe(".phoneNumber") {

                func returnedViewModel() -> SearchDetailsInfoSectionViewModel? {
                    return returnedSection()?.infoSectionViewModels?[1]
                }

                context("when urlOpenerService.buildPhoneCallBlock() returns a non-nil value") {
                    var blockCalled: Bool!

                    beforeEach {
                        blockCalled = false
                        mockURLOpenerService.buildPhoneCallBlockReturnValue = {
                            blockCalled = true
                        }

                        performTest(entity: stubModel)
                    }

                    it("contains .phoneNumber, with the value from copyFormatter.formatCallablePhoneNumber()") {
                        let returnedPhoneNumber = returnedViewModel()?.phoneNumberViewModel?.phoneLabelText
                        expect(returnedPhoneNumber) == "formatCallablePhoneNumberDisplayPhoneReturnValue"
                    }

                    it("...and the block returned from buildPhoneCallBlock()") {
                        expect(blockCalled) == false
                        returnedViewModel()?.phoneNumberViewModel?.makeCallBlock?.value()
                        expect(blockCalled) == true
                    }
                }

                context("else when urlOpenerService.buildPhoneCallBlock() returns a nil value") {
                    beforeEach {
                        mockURLOpenerService.buildPhoneCallBlockReturnValue = nil

                        performTest(entity: stubModel)
                    }

                    it("contains .phoneNumber, with the value from copyFormatter.formatNonCallablePhoneNumber()") {
                        let returnedPhoneNumber = returnedViewModel()?.phoneNumberViewModel?.phoneLabelText
                        expect(returnedPhoneNumber) == "formatNonCallablePhoneNumberReturnValue"
                    }
                }

            }

        }

        describe(".location section") {

            func returnedSection() -> SearchDetailsViewModel.Section? {
                return result.sections.element(at: SearchDetailsViewModel.Section.locationSectionIndex)
            }

            context("when the model has a non-nil coordinate") {

                let stubCoordinate = PlaceLookupCoordinate.stubValue()

                func returnedViewModel() -> SearchDetailsMapSectionViewModel? {
                    return returnedSection()?.locationSectionViewModels?[0]
                }

                beforeEach {
                    performTest(entity: SearchEntityModel.stubValue(coordinate: stubCoordinate))
                }

                it("includes SearchDetailsViewModel.Section.location") {
                    guard case .location? = returnedSection() else {
                        fail("Unexpected value found: \(String(describing: returnedSection()))")
                        return
                    }
                }

                it("contains .mapCoordinate as a viewmodel, with the model's name...") {
                    expect(returnedViewModel()?.mapCoordinateViewModel?.placeName) == stubModel.name
                }

                it("...and with the address returned by mockCopyFormatter.formatAddress()...") {
                    expect(returnedViewModel()?.mapCoordinateViewModel?.address)
                        == mockCopyFormatter.formatAddressReturnValue
                }

                it("...and with the model's coordinate") {
                    expect(returnedViewModel()?.mapCoordinateViewModel?.coordinate) == stubCoordinate
                }

            }

            context("else when the model has a nil coordinate") {
                beforeEach {
                    performTest(entity: SearchEntityModel.stubValue(coordinate: nil))
                }

                it("does not include SearchDetailsViewModel.Section.location") {
                    expect(returnedSection()).to(beNil())
                }
            }

        }

    }

}

private extension SearchDetailsViewModel.Section {

    static var infoSectionIndex: Int {
        return 0
    }

    var infoSectionViewModels: [SearchDetailsInfoSectionViewModel]? {
        switch self {
        case let .info(viewModels):
            return viewModels
        default:
            return nil
        }
    }

    static var locationSectionIndex: Int {
        return 1
    }

    var locationSectionViewModels: [SearchDetailsMapSectionViewModel]? {
        switch self {
        case let .location(viewModels):
            return viewModels
        default:
            return nil
        }
    }

}

private extension SearchDetailsInfoSectionViewModel {

    var infoViewModel: SearchDetailsBasicInfoViewModel? {
        if case let .basicInfo(viewModel) = self { return viewModel }
        return nil
    }

    var phoneNumberViewModel: SearchDetailsPhoneNumberViewModel? {
        if case let .phoneNumber(viewModel) = self { return viewModel }
        return nil
    }

}

private extension SearchDetailsMapSectionViewModel {

    var mapCoordinateViewModel: SearchDetailsMapCoordinateViewModel? {
        if case let .mapCoordinate(viewModel) = self { return viewModel }
        return nil
    }

}
