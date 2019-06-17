//
//  SearchProgressCell.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Foundation
import Shared

class SearchProgressCell: SearchCellBase {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupSkeleton()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupSkeleton() {
        detailsContainerView.heightAnchor.constraint(equalToConstant: 24.0).isActive = true
        disclosureImageView.isHidden = true

        makeSkeletonable()
    }

}
