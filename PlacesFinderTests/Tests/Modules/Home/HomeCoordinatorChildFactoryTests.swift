//
//  HomeCoordinatorChildFactoryTests.swift
//  PlacesFinderTests
//
//  Copyright (c) 2020 Justin Peckner
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

class HomeCoordinatorChildFactoryTests: QuickSpec {

    // swiftlint:disable implicitly_unwrapped_optional
    override func spec() {

        var sut: HomeCoordinatorChildFactory<MockAppStore>!

        beforeEach {
            sut = HomeCoordinatorChildFactory(store: MockAppStore(),
                                              listenerContainer: ListenerContainer.mockValue(),
                                              serviceContainer: ServiceContainer.mockValue())
        }

        describe("buildCoordinator") {

            context("when the destinationDescendent arg is .search") {

                var result: TabCoordinatorProtocol!

                beforeEach {
                    result = sut.buildCoordinator(for: .search)
                }

                it("returns an instance of SearchCoordinator") {
                    expect(result is SearchCoordinator<MockAppStore, MockSearchStore>) == true
                }

            }

            context("else when the destinationDescendent arg is .settings") {

                var result: TabCoordinatorProtocol!

                beforeEach {
                    result = sut.buildCoordinator(for: .settings)
                }

                it("returns an instance of SettingsCoordinator") {
                    expect(result is SettingsCoordinator<MockAppStore>) == true
                }

            }

        }

    }

}
