//
//  SearchDetailsSectionProtocol.swift
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

import Shared
import UIKit

protocol SearchDetailsSectionProtocol {
    static var allCellTypes: [UITableViewCell.Type] { get }

    var cellType: UITableViewCell.Type { get }
    var isSelectable: Bool { get }

    @MainActor
    func configureCell(_ cell: UITableViewCell,
                       colorings: SearchDetailsViewColorings) throws
}

extension SearchDetailsInfoSectionViewModel: SearchDetailsSectionProtocol {

    var isSelectable: Bool {
        switch self {
        case .basicInfo:
            return false
        case .phoneNumber:
            return true
        }
    }

    func configureCell(_ cell: UITableViewCell,
                       colorings: SearchDetailsViewColorings) throws {
        switch self {
        case let .basicInfo(viewModel):
            let detailsInfoCell: SearchDetailsBasicInfoCell = try CastingFunctions.cast(cell)
            detailsInfoCell.configure(viewModel,
                                      colorings: colorings)
        case let .phoneNumber(viewModel):
            let phoneNumberCell: SearchDetailsPhoneNumberCell = try CastingFunctions.cast(cell)
            phoneNumberCell.configure(viewModel,
                                      colorings: colorings)
        }
    }

}

extension SearchDetailsMapSectionViewModel: SearchDetailsSectionProtocol {

    var isSelectable: Bool {
        switch self {
        case .mapCoordinate:
            return false
        }
    }

    func configureCell(_ cell: UITableViewCell,
                       colorings: SearchDetailsViewColorings) throws {
        switch self {
        case let .mapCoordinate(viewModel):
            let mapCell: SearchDetailsMapCell = try CastingFunctions.cast(cell)
            mapCell.configure(viewModel)
        }
    }

}
