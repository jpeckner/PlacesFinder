//
//  SearchResultsViewPropsTests.swift
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
import Shared
import SwiftDux

// swiftlint:disable blanket_disable_command
// swiftlint:disable function_body_length
// swiftlint:disable implicitly_unwrapped_optional
class SearchResultsViewPropsTests: AsyncSpec {

    override class func spec() {

        let stubbedRefreshAction = Search.ActivityAction.stubbedStartInitialRequestAction()
        let stubbedNextRequestAction = Search.ActivityAction.stubbedStartSubsequentRequestAction()

        var stubResultProps: NonEmptyArray<SearchResultProps>!
        var result: SearchResultsViewProps!

        func buildProps(
            resultProps: NonEmptyArray<SearchResultProps>,
            nextRequestAction: Search.Action? = .searchActivity(.stubbedStartSubsequentRequestAction())
        ) -> SearchResultsViewProps {
            return SearchResultsViewProps(resultProps: resultProps,
                                          refreshAction: .searchActivity(stubbedRefreshAction),
                                          nextRequestAction: nextRequestAction)
        }

        beforeEach {
            stubResultProps = NonEmptyArray([0, 1, 2].map { idx in
                SearchResultProps.stubValue(
                    cellProps: SearchResultCellProps.stubValue(name: .stubValue("stubName_\(idx)")),
                    detailEntityAction: .searchActivity(.detailedEntity(.stubValue(id: .stubValue("stubID_\(idx)"))))
                )
            })
        }

        describe("resultProps.count") {

            it("returns the number of result props") {
                result = buildProps(resultProps: stubResultProps)
                expect(result.resultProps.value.count) == 3

                result = buildProps(resultProps: stubResultProps.appendedWith([
                    SearchResultProps.stubValue()
                ]))
                expect(result.resultProps.value.count) == 4

                result = buildProps(resultProps: stubResultProps.appendedWith([
                    SearchResultProps.stubValue(),
                    SearchResultProps.stubValue()
                ]))
                expect(result.resultProps.value.count) == 5
            }

        }

        describe("resultProps[rowIndex]") {

            beforeEach {
                result = buildProps(resultProps: stubResultProps)
            }

            it("returns the props at the specified index") {
                expect(result.resultProps.value[2].cellProps) == stubResultProps.value[2].cellProps
            }

            it("includes the expected detailEntityAction") {
                expect(result.resultProps.value[2].detailEntityAction.value)
                    == .searchActivity(.detailedEntity(.stubValue(id: .stubValue("stubID_2"))))
            }

        }

        describe("refreshAction") {

            beforeEach {
                result = buildProps(resultProps: stubResultProps)
            }

            it("returns the expected action") {
                expect(result.refreshAction.value) == .searchActivity(stubbedRefreshAction)
            }

        }

        describe("nextRequestAction") {

            context("when nextRequestAction is not nil") {
                beforeEach {
                    result = buildProps(resultProps: stubResultProps,
                                        nextRequestAction: .searchActivity(stubbedNextRequestAction))
                }

                it("returns the expected action the first time it is consumed") {
                    let nextRequestAction = await result.nextRequestAction.value.consume()
                    expect(nextRequestAction) == .searchActivity(stubbedNextRequestAction)
                }

                it("returns nil once consumed, including from a copy of the props") {
                    let copiedProps: SearchResultsViewProps = result
                    _ = await result.nextRequestAction.value.consume()

                    let secondAction = await result.nextRequestAction.value.consume()
                    let copiedPropsAction = await copiedProps.nextRequestAction.value.consume()
                    expect(secondAction) == nil
                    expect(copiedPropsAction) == nil
                }
            }

            context("when nextRequestAction is nil") {
                beforeEach {
                    result = buildProps(resultProps: stubResultProps,
                                        nextRequestAction: nil)
                }

                it("returns nil") {
                    let nextRequestAction = await result.nextRequestAction.value.consume()
                    expect(nextRequestAction) == nil
                }
            }

        }

    }

}
// swiftlint:enable blanket_disable_command
