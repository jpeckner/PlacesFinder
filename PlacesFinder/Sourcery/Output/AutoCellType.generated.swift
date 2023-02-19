// Generated using Sourcery 2.0.1 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT
import UIKit


extension SearchDetailsInfoSectionViewModel {

    static let allCellTypes: [UITableViewCell.Type] = [
        SearchDetailsBasicInfoCell.self,
        SearchDetailsPhoneNumberCell.self,
    ]

    var cellType: UITableViewCell.Type {
        switch self {
        case .basicInfo:
            return SearchDetailsBasicInfoCell.self
        case .phoneNumber:
            return SearchDetailsPhoneNumberCell.self
        }
    }

}

extension SearchDetailsMapSectionViewModel {

    static let allCellTypes: [UITableViewCell.Type] = [
        SearchDetailsMapCell.self,
    ]

    var cellType: UITableViewCell.Type {
        switch self {
        case .mapCoordinate:
            return SearchDetailsMapCell.self
        }
    }

}
