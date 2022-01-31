//
//  SearchDetailsViewModelBuilderTests.swift
//  PlacesFinderTests
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

import Nimble
import Quick
import Shared
import SharedTestComponents
import SwiftDux

class SearchDetailsViewModelBuilderTests: QuickSpec {

    private enum StubViewModelAction: Action {
        case removeDetailedEntityAction
    }

    // swiftlint:disable function_body_length
    // swiftlint:disable implicitly_unwrapped_optional
    // swiftlint:disable line_length
    override func spec() {

        let stubModel = SearchEntityModel.stubValue()
        let stubCopyContent = SearchResultsCopyContent.stubValue()

        var mockStore: MockAppStore!
        var mockSearchActivityActionPrism: SearchActivityActionPrismProtocolMock!

        var mockURLOpenerService: URLOpenerServiceProtocolMock!
        var mockCopyFormatter: SearchCopyFormatterProtocolMock!

        var sut: SearchDetailsViewModelBuilder!
        var result: SearchDetailsViewModel!

        beforeEach {
            mockStore = MockAppStore()

            mockSearchActivityActionPrism = SearchActivityActionPrismProtocolMock()
            mockSearchActivityActionPrism.removeDetailedEntityAction = StubViewModelAction.removeDetailedEntityAction

            mockURLOpenerService = URLOpenerServiceProtocolMock()

            mockCopyFormatter = SearchCopyFormatterProtocolMock()
            mockCopyFormatter.formatAddressReturnValue = .stubValue("formatAddressReturnValue")
            mockCopyFormatter.formatCallablePhoneNumberDisplayPhoneReturnValue = "formatCallablePhoneNumberDisplayPhoneReturnValue"
            mockCopyFormatter.formatNonCallablePhoneNumberReturnValue = "formatNonCallablePhoneNumberReturnValue"
            mockCopyFormatter.formatRatingsNumRatingsReturnValue = "formatRatingsNumRatingsReturnValue"
            mockCopyFormatter.formatPricingPricingReturnValue = "formatPricingPricingReturnValue"

            sut = SearchDetailsViewModelBuilder(store: mockStore,
                                                actionPrism: mockSearchActivityActionPrism,
                                                urlOpenerService: mockURLOpenerService,
                                                copyFormatter: mockCopyFormatter)
        }

        func constructResult(entity: SearchEntityModel) {
            result = sut.buildViewModel(entity,
                                        resultsCopyContent: stubCopyContent)
        }

        describe("placeName") {
            beforeEach {
                constructResult(entity: stubModel)
            }

            it("has the same place name as the passed-in model") {
                expect(result.placeName) == stubModel.name.value
            }
        }

        describe(".info section") {

            func returnedSection() -> SearchDetailsViewModel.Section? {
                return result.section(sectionIndex: SearchDetailsViewModel.Section.infoSectionIndex)
            }

            var blockCalled: Bool!

            beforeEach {
                blockCalled = false
                mockURLOpenerService.buildOpenURLBlockReturnValue = {
                    blockCalled = true
                }

                constructResult(entity: stubModel)
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

                it("...and with the ratings returned by mockCopyFormatter.formatRatings()...") {
                    expect(returnedViewModel()?.infoViewModel?.numRatingsMessage) == "formatRatingsNumRatingsReturnValue"
                }

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

                        constructResult(entity: stubModel)
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

                        constructResult(entity: stubModel)
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
                guard result.sectionsCount > SearchDetailsViewModel.Section.locationSectionIndex else { return nil }
                return result.section(sectionIndex: SearchDetailsViewModel.Section.locationSectionIndex)
            }

            context("when the model has a non-nil coordinate") {

                let stubCoordinate = PlaceLookupCoordinate.stubValue()

                func returnedViewModel() -> SearchDetailsMapSectionViewModel? {
                    return returnedSection()?.locationSectionViewModels?[0]
                }

                beforeEach {
                    let stubEntity = SearchEntityModel.stubValue(coordinate: stubCoordinate)
                    constructResult(entity: stubEntity)
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
                    let stubEntity = SearchEntityModel.stubValue(coordinate: nil)
                    constructResult(entity: stubEntity)
                }

                it("does not include SearchDetailsViewModel.Section.location") {
                    expect(returnedSection()).to(beNil())
                }
            }

        }

        describe("dispatchRemoveDetailsAction") {
            beforeEach {
                constructResult(entity: stubModel)
                result.dispatchRemoveDetailsAction()
            }

            it("dispatches the expected action") {
                expect(mockStore.dispatchedNonAsyncActions.last as? StubViewModelAction) == .removeDetailedEntityAction
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
