//
//  SearchDetailsSectionProtocol.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Shared
import UIKit

protocol SearchDetailsSectionProtocol {
    static var allCellTypes: [UITableViewCell.Type] { get }

    var cellType: UITableViewCell.Type { get }
    var isSelectable: Bool { get }

    func configureCell(_ cell: UITableViewCell,
                       colorings: SearchDetailsViewColorings) throws
}

extension SearchDetailsInfoSectionViewModel: SearchDetailsSectionProtocol, AutoCellType {

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

extension SearchDetailsMapSectionViewModel: SearchDetailsSectionProtocol, AutoCellType {

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
