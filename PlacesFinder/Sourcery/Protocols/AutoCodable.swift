//
//  AutoCodable.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Foundation

public protocol AutoDecodable: Decodable {}

public protocol AutoEncodable: Encodable {}

public protocol AutoCodable: AutoDecodable, AutoEncodable {}
