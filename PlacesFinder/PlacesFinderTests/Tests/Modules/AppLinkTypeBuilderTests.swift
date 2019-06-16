//
//  AppLinkTypeBuilderTests.swift
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

class AppLinkTypeBuilderTests: QuickSpec {

    // swiftlint:disable function_body_length
    // swiftlint:disable implicitly_unwrapped_optional
    override func spec() {

        var builder: AppLinkTypeBuilder!

        var result: AppLinkType?

        beforeEach {
            builder = AppLinkTypeBuilder()
        }

        describe("AppLinkTypeBuilderProtocol") {

            describe("buildPayload") {

                context("when the URL's path begins with /search") {
                    let urlString = "https://www.example.com/search"

                    context("and there is no keywords query item") {
                        beforeEach {
                            let url = URL.stubValue(string: urlString)
                            result = builder.buildPayload(url)
                        }

                        it("returns an EmptySearchLinkPayload") {
                            let payload = result?.value as? EmptySearchLinkPayload
                            expect(payload).toNot(beNil())
                        }
                    }

                    context("else and the keywords query item has an empty value") {
                        beforeEach {
                            let url = URL.stubValue(string: "\(urlString)?keywords=")
                            result = builder.buildPayload(url)
                        }

                        it("returns an EmptySearchLinkPayload") {
                            let payload = result?.value as? EmptySearchLinkPayload
                            expect(payload).toNot(beNil())
                        }
                    }

                    context("else and the keywords query item has a non-empty value") {
                        beforeEach {
                            let url = URL.stubValue(string: "\(urlString)?keywords=hello%20world")
                            result = builder.buildPayload(url)
                        }

                        it("returns a SearchLinkPayload, with keywords set to the percent-decoded value") {
                            let payload = result?.value as? SearchLinkPayload
                            expect(payload?.keywords.value) == "hello world"
                        }
                    }

                }

                context("else when the URL's path begins with /settings") {
                    let urlString = "https://www.example.com/settings"

                    beforeEach {
                        let url = URL.stubValue(string: urlString)
                        result = builder.buildPayload(url)
                    }

                    it("returns a SettingsLinkPayload") {
                        let payload = result?.value as? SettingsLinkPayload
                        expect(payload).toNot(beNil())
                    }
                }

                context("else") {
                    let url = URL.stubValue(string: "https://www.example.com/unknown")

                    beforeEach {
                        result = builder.buildPayload(url)
                    }

                    it("returns nil") {
                        expect(result).to(beNil())
                    }
                }

            }

        }

    }

}
