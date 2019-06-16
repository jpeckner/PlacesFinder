//
//  ChildCoordinatorProtocol.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Shared
import UIKit

// sourcery: AutoMockable
protocol ChildCoordinatorProtocol {
    var rootViewController: UIViewController { get }

    func start(_ completion: () -> Void)
    func finish(_ completion: (() -> Void)?)
}
