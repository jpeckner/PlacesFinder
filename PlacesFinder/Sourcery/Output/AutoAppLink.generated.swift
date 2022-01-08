// Generated using Sourcery 1.2.1 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT
import CoordiNode
import SwiftDux



enum AppLinkType: Equatable {
    case emptySearch(EmptySearchLinkPayload)
    case search(SearchLinkPayload)
    case settings(SettingsLinkPayload)
}

extension AppLinkType {

    var value: AppLinkPayloadProtocol {
        switch self {
        case let .emptySearch(payload):
            return payload
        case let .search(payload):
            return payload
        case let .settings(payload):
            return payload
        }
    }

}

extension AppLinkType: LinkTypeProtocol {

    // Note: each type implementing AppLinkPayloadProtocol must belong to exactly one DestinationCoordinatorProtocol's
    // linkPayloadType annotation. A compiler error here means that's not currently the case.
    var destinationNodeBox: DestinationNodeBox {
        switch self {
        case .emptySearch:
            return SearchCoordinatorNode.destinationNodeBox
        case .search:
            return SearchCoordinatorNode.destinationNodeBox
        case .settings:
            return SettingsCoordinatorNode.destinationNodeBox
        }
    }

}

extension SearchCoordinator {

    func clearAllAssociatedLinkTypes(_ state: AppState,
                                     store: DispatchingStoreProtocol) {
        clearPayloadTypeIfPresent(SearchLinkPayload.self,
                                  state: state,
                                  store: store)
        clearPayloadTypeIfPresent(EmptySearchLinkPayload.self,
                                  state: state,
                                  store: store)
    }

}
extension SettingsCoordinator {

    func clearAllAssociatedLinkTypes(_ state: AppState,
                                     store: DispatchingStoreProtocol) {
        clearPayloadTypeIfPresent(SettingsLinkPayload.self,
                                  state: state,
                                  store: store)
    }

}
