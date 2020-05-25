//
//  StubDispatchingStore.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2020 Justin Peckner. All rights reserved.
//

#if DEBUG

import SwiftDux

class StubDispatchingStore: DispatchingStoreProtocol {

    func dispatch(_ action: Action) {
        fatalError("Stub method should never be called")
    }

}

#endif
