//
//  StubLinkType.swift
//  PlacesFinderTests
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import CoordiNode
import Foundation
#if DEBUG
@testable import PlacesFinder
#endif

struct StubLinkType: LinkTypeProtocol, Equatable {

    var destinationNodeBox: DestinationNodeBox {
        return StubDestinationNode.destinationNodeBox
    }

}
