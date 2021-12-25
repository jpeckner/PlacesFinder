//
//  AppLinkTypeBuilderTests.swift
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
