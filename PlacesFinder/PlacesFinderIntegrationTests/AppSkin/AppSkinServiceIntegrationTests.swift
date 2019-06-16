//
//  AppSkinServiceIntegrationTests.swift
//  PlacesFinderIntegrationTests
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Nimble
import Quick
import Shared

class AppSkinServiceIntegrationTests: QuickSpec {

    // swiftlint:disable implicitly_unwrapped_optional
    override func spec() {

        var appSkinService: AppSkinService!

        func setupTest() {
            do {
                let appConfig = try AppConfig(bundle: Bundle.main)
                let decodableServices = DecodableServices()
                appSkinService = AppSkinService(url: appConfig.appSkinConfig.url,
                                                decodableService: decodableServices.quickTimeoutDecodableService)
            } catch {
                fail("Unexpected error: \(error)")
            }
        }

        describe("requestPage") {

            var fetchedResult: Result<AppSkin, DecodableServiceError<AppSkinServiceErrorPayload>>!

            beforeSuite {
                setupTest()

                waitUntil(timeout: 5.0) { done in
                    appSkinService.fetchAppSkin { result in
                        fetchedResult = result
                        done()
                    }
                }
            }

            it("returns a valid skin from the API") {
                expect { try fetchedResult.get() }.toNot(throwError())
            }

        }

    }

}
