// Generated using Sourcery 2.3.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT
// swiftlint:disable line_length
// swiftlint:disable variable_name

import Foundation
#if os(iOS) || os(tvOS) || os(watchOS)
import UIKit
#elseif os(OSX)
import AppKit
#endif

import Combine
import CoordiNode
import Foundation
import Shared
import SharedTestComponents
import SwiftDux
import UIKit
























class AppCoordinatorChildFactoryProtocolMock<TStore: StoreProtocol>: AppCoordinatorChildFactoryProtocol where TStore.TState == AppState, TStore.TAction == AppAction {


    var store: TStore {
        get { return underlyingStore }
        set(value) { underlyingStore = value }
    }
    var underlyingStore: TStore!
    var serviceContainer: ServiceContainer {
        get { return underlyingServiceContainer }
        set(value) { underlyingServiceContainer = value }
    }
    var underlyingServiceContainer: ServiceContainer!
    var launchStatePrism: LaunchStatePrismProtocol {
        get { return underlyingLaunchStatePrism }
        set(value) { underlyingLaunchStatePrism = value }
    }
    var underlyingLaunchStatePrism: LaunchStatePrismProtocol!

    //MARK: - buildLaunchCoordinator

    var buildLaunchCoordinatorCallsCount = 0
    var buildLaunchCoordinatorCalled: Bool {
        return buildLaunchCoordinatorCallsCount > 0
    }
    var buildLaunchCoordinatorReturnValue: AppCoordinatorChildProtocol!
    var buildLaunchCoordinatorClosure: (() -> AppCoordinatorChildProtocol)?

    @MainActor
    func buildLaunchCoordinator() -> AppCoordinatorChildProtocol {
        buildLaunchCoordinatorCallsCount += 1
        if let buildLaunchCoordinatorClosure = buildLaunchCoordinatorClosure {
            return buildLaunchCoordinatorClosure()
        } else {
            return buildLaunchCoordinatorReturnValue
        }
    }

    //MARK: - buildCoordinator

    var buildCoordinatorForCallsCount = 0
    var buildCoordinatorForCalled: Bool {
        return buildCoordinatorForCallsCount > 0
    }
    var buildCoordinatorForReceivedChildType: AppCoordinatorDestinationDescendent?
    var buildCoordinatorForReceivedInvocations: [AppCoordinatorDestinationDescendent] = []
    var buildCoordinatorForReturnValue: AppCoordinatorChildProtocol!
    var buildCoordinatorForClosure: ((AppCoordinatorDestinationDescendent) -> AppCoordinatorChildProtocol)?

    @MainActor
    func buildCoordinator(for childType: AppCoordinatorDestinationDescendent) -> AppCoordinatorChildProtocol {
        buildCoordinatorForCallsCount += 1
        buildCoordinatorForReceivedChildType = childType
        buildCoordinatorForReceivedInvocations.append(childType)
        if let buildCoordinatorForClosure = buildCoordinatorForClosure {
            return buildCoordinatorForClosure(childType)
        } else {
            return buildCoordinatorForReturnValue
        }
    }

}
class AppGlobalStylingsHandlerProtocolMock: AppGlobalStylingsHandlerProtocol, @unchecked Sendable {



    //MARK: - apply

    var applyCallsCount = 0
    var applyCalled: Bool {
        return applyCallsCount > 0
    }
    var applyReceivedAppSkin: AppSkin?
    var applyReceivedInvocations: [AppSkin] = []
    var applyClosure: ((AppSkin) -> Void)?

    @MainActor
    func apply(_ appSkin: AppSkin) {
        applyCallsCount += 1
        applyReceivedAppSkin = appSkin
        applyReceivedInvocations.append(appSkin)
        applyClosure?(appSkin)
    }

}
class AppLinkTypeBuilderProtocolMock: AppLinkTypeBuilderProtocol {



    //MARK: - buildPayload

    var buildPayloadCallsCount = 0
    var buildPayloadCalled: Bool {
        return buildPayloadCallsCount > 0
    }
    var buildPayloadReceivedUrl: URL?
    var buildPayloadReceivedInvocations: [URL] = []
    var buildPayloadReturnValue: AppLinkType?
    var buildPayloadClosure: ((URL) -> AppLinkType?)?

    func buildPayload(_ url: URL) -> AppLinkType? {
        buildPayloadCallsCount += 1
        buildPayloadReceivedUrl = url
        buildPayloadReceivedInvocations.append(url)
        if let buildPayloadClosure = buildPayloadClosure {
            return buildPayloadClosure(url)
        } else {
            return buildPayloadReturnValue
        }
    }

}
class AppSkinServiceProtocolMock: AppSkinServiceProtocol, @unchecked Sendable {



    //MARK: - fetchAppSkin

    var fetchAppSkinCallsCount = 0
    var fetchAppSkinCalled: Bool {
        return fetchAppSkinCallsCount > 0
    }
    var fetchAppSkinReturnValue: Result<AppSkin, AppSkinServiceError>!
    var fetchAppSkinClosure: (() async -> Result<AppSkin, AppSkinServiceError>)?

    func fetchAppSkin() async -> Result<AppSkin, AppSkinServiceError> {
        fetchAppSkinCallsCount += 1
        if let fetchAppSkinClosure = fetchAppSkinClosure {
            return await fetchAppSkinClosure()
        } else {
            return fetchAppSkinReturnValue
        }
    }

}
class ChildCoordinatorProtocolMock: ChildCoordinatorProtocol {


    var rootViewController: UIViewController {
        get { return underlyingRootViewController }
        set(value) { underlyingRootViewController = value }
    }
    var underlyingRootViewController: UIViewController!

    //MARK: - start

    var startCallsCount = 0
    var startCalled: Bool {
        return startCallsCount > 0
    }
    var startClosure: (() -> Void)?

    @MainActor
    func start() {
        startCallsCount += 1
        startClosure?()
    }

    //MARK: - finish

    var finishCallsCount = 0
    var finishCalled: Bool {
        return finishCallsCount > 0
    }
    var finishClosure: (() async -> Void)?

    @MainActor
    func finish() async {
        finishCallsCount += 1
        await finishClosure?()
    }

}
class HomeCoordinatorChildFactoryProtocolMock<TStore: StoreProtocol>: HomeCoordinatorChildFactoryProtocol where TStore.TState == AppState, TStore.TAction == AppAction {



    //MARK: - buildCoordinator

    var buildCoordinatorForCallsCount = 0
    var buildCoordinatorForCalled: Bool {
        return buildCoordinatorForCallsCount > 0
    }
    var buildCoordinatorForReceivedDestinationDescendent: HomeCoordinatorDestinationDescendent?
    var buildCoordinatorForReceivedInvocations: [HomeCoordinatorDestinationDescendent] = []
    var buildCoordinatorForReturnValue: TabCoordinatorProtocol!
    var buildCoordinatorForClosure: ((HomeCoordinatorDestinationDescendent) -> TabCoordinatorProtocol)?

    @MainActor
    func buildCoordinator(for destinationDescendent: HomeCoordinatorDestinationDescendent) -> TabCoordinatorProtocol {
        buildCoordinatorForCallsCount += 1
        buildCoordinatorForReceivedDestinationDescendent = destinationDescendent
        buildCoordinatorForReceivedInvocations.append(destinationDescendent)
        if let buildCoordinatorForClosure = buildCoordinatorForClosure {
            return buildCoordinatorForClosure(destinationDescendent)
        } else {
            return buildCoordinatorForReturnValue
        }
    }

}
class HomePresenterProtocolMock: HomePresenterProtocol {


    var delegate: HomePresenterDelegate?
    var rootViewController: UIViewController {
        get { return underlyingRootViewController }
        set(value) { underlyingRootViewController = value }
    }
    var underlyingRootViewController: UIViewController!

    //MARK: - setSelectedViewController

    var setSelectedViewControllerCallsCount = 0
    var setSelectedViewControllerCalled: Bool {
        return setSelectedViewControllerCallsCount > 0
    }
    var setSelectedViewControllerReceivedController: UIViewController?
    var setSelectedViewControllerReceivedInvocations: [UIViewController] = []
    var setSelectedViewControllerClosure: ((UIViewController) -> Void)?

    func setSelectedViewController(_ controller: UIViewController) {
        setSelectedViewControllerCallsCount += 1
        setSelectedViewControllerReceivedController = controller
        setSelectedViewControllerReceivedInvocations.append(controller)
        setSelectedViewControllerClosure?(controller)
    }

}
class LaunchPresenterProtocolMock: LaunchPresenterProtocol {


    var rootViewController: UIViewController {
        get { return underlyingRootViewController }
        set(value) { underlyingRootViewController = value }
    }
    var underlyingRootViewController: UIViewController!

    //MARK: - animateOut

    var animateOutCallsCount = 0
    var animateOutCalled: Bool {
        return animateOutCallsCount > 0
    }
    var animateOutClosure: (() async -> Void)?

    func animateOut() async {
        animateOutCallsCount += 1
        await animateOutClosure?()
    }

}
class LaunchStatePrismProtocolMock: LaunchStatePrismProtocol {


    var launchKeyPaths: Set<EquatableKeyPath<AppState>> {
        get { return underlyingLaunchKeyPaths }
        set(value) { underlyingLaunchKeyPaths = value }
    }
    var underlyingLaunchKeyPaths: Set<EquatableKeyPath<AppState>>!

    //MARK: - hasFinishedLaunching

    var hasFinishedLaunchingCallsCount = 0
    var hasFinishedLaunchingCalled: Bool {
        return hasFinishedLaunchingCallsCount > 0
    }
    var hasFinishedLaunchingReceivedState: AppState?
    var hasFinishedLaunchingReceivedInvocations: [AppState] = []
    var hasFinishedLaunchingReturnValue: Bool!
    var hasFinishedLaunchingClosure: ((AppState) -> Bool)?

    func hasFinishedLaunching(_ state: AppState) -> Bool {
        hasFinishedLaunchingCallsCount += 1
        hasFinishedLaunchingReceivedState = state
        hasFinishedLaunchingReceivedInvocations.append(state)
        if let hasFinishedLaunchingClosure = hasFinishedLaunchingClosure {
            return hasFinishedLaunchingClosure(state)
        } else {
            return hasFinishedLaunchingReturnValue
        }
    }

}
class LocationAuthListenerProtocolMock: LocationAuthListenerProtocol {


    var actionPublisher: AnyPublisher<LocationAuthAction, Never> {
        get { return underlyingActionPublisher }
        set(value) { underlyingActionPublisher = value }
    }
    var underlyingActionPublisher: AnyPublisher<LocationAuthAction, Never>!

    //MARK: - start

    var startCallsCount = 0
    var startCalled: Bool {
        return startCallsCount > 0
    }
    var startClosure: (() -> Void)?

    func start() {
        startCallsCount += 1
        startClosure?()
    }

    //MARK: - requestWhenInUseAuthorization

    var requestWhenInUseAuthorizationCallsCount = 0
    var requestWhenInUseAuthorizationCalled: Bool {
        return requestWhenInUseAuthorizationCallsCount > 0
    }
    var requestWhenInUseAuthorizationClosure: (() -> Void)?

    func requestWhenInUseAuthorization() {
        requestWhenInUseAuthorizationCallsCount += 1
        requestWhenInUseAuthorizationClosure?()
    }

}
class NavigationBarPropsBuilderProtocolMock: NavigationBarPropsBuilderProtocol {



    //MARK: - buildTitleProps

    var buildTitlePropsCallsCount = 0
    var buildTitlePropsCalled: Bool {
        return buildTitlePropsCallsCount > 0
    }
    var buildTitlePropsReturnValue: NavigationBarTitleViewProps!
    var buildTitlePropsClosure: (() -> NavigationBarTitleViewProps)?

    func buildTitleProps() -> NavigationBarTitleViewProps {
        buildTitlePropsCallsCount += 1
        if let buildTitlePropsClosure = buildTitlePropsClosure {
            return buildTitlePropsClosure()
        } else {
            return buildTitlePropsReturnValue
        }
    }

}
class PlaceLookupServiceProtocolMock: PlaceLookupServiceProtocol, @unchecked Sendable {



    //MARK: - buildInitialPageRequestToken

    var buildInitialPageRequestTokenPlaceLookupParamsThrowableError: Error?
    var buildInitialPageRequestTokenPlaceLookupParamsCallsCount = 0
    var buildInitialPageRequestTokenPlaceLookupParamsCalled: Bool {
        return buildInitialPageRequestTokenPlaceLookupParamsCallsCount > 0
    }
    var buildInitialPageRequestTokenPlaceLookupParamsReceivedPlaceLookupParams: PlaceLookupParams?
    var buildInitialPageRequestTokenPlaceLookupParamsReceivedInvocations: [PlaceLookupParams] = []
    var buildInitialPageRequestTokenPlaceLookupParamsReturnValue: PlaceLookupPageRequestToken!
    var buildInitialPageRequestTokenPlaceLookupParamsClosure: ((PlaceLookupParams) throws -> PlaceLookupPageRequestToken)?

    func buildInitialPageRequestToken(placeLookupParams: PlaceLookupParams) throws -> PlaceLookupPageRequestToken {
        buildInitialPageRequestTokenPlaceLookupParamsCallsCount += 1
        if let error = buildInitialPageRequestTokenPlaceLookupParamsThrowableError {
            throw error
        }
        buildInitialPageRequestTokenPlaceLookupParamsReceivedPlaceLookupParams = placeLookupParams
        buildInitialPageRequestTokenPlaceLookupParamsReceivedInvocations.append(placeLookupParams)
        if let buildInitialPageRequestTokenPlaceLookupParamsClosure = buildInitialPageRequestTokenPlaceLookupParamsClosure {
            return try buildInitialPageRequestTokenPlaceLookupParamsClosure(placeLookupParams)
        } else {
            return buildInitialPageRequestTokenPlaceLookupParamsReturnValue
        }
    }

    //MARK: - requestPage

    var requestPageRequestTokenCallsCount = 0
    var requestPageRequestTokenCalled: Bool {
        return requestPageRequestTokenCallsCount > 0
    }
    var requestPageRequestTokenReceivedRequestToken: PlaceLookupPageRequestToken?
    var requestPageRequestTokenReceivedInvocations: [PlaceLookupPageRequestToken] = []
    var requestPageRequestTokenReturnValue: PlaceLookupResult!
    var requestPageRequestTokenClosure: ((PlaceLookupPageRequestToken) async -> PlaceLookupResult)?

    func requestPage(requestToken: PlaceLookupPageRequestToken) async -> PlaceLookupResult {
        requestPageRequestTokenCallsCount += 1
        requestPageRequestTokenReceivedRequestToken = requestToken
        requestPageRequestTokenReceivedInvocations.append(requestToken)
        if let requestPageRequestTokenClosure = requestPageRequestTokenClosure {
            return await requestPageRequestTokenClosure(requestToken)
        } else {
            return requestPageRequestTokenReturnValue
        }
    }

}
class ReachabilityListenerProtocolMock: ReachabilityListenerProtocol {



    //MARK: - start

    var startCallsCount = 0
    var startCalled: Bool {
        return startCallsCount > 0
    }
    var startClosure: (() -> Void)?

    func start() {
        startCallsCount += 1
        startClosure?()
    }

}
class ReachabilityProtocolMock: ReachabilityProtocol {



    //MARK: - start

    var startQueueCallsCount = 0
    var startQueueCalled: Bool {
        return startQueueCallsCount > 0
    }
    var startQueueReceivedQueue: DispatchQueue?
    var startQueueReceivedInvocations: [DispatchQueue] = []
    var startQueueClosure: ((DispatchQueue) -> Void)?

    func start(queue: DispatchQueue) {
        startQueueCallsCount += 1
        startQueueReceivedQueue = queue
        startQueueReceivedInvocations.append(queue)
        startQueueClosure?(queue)
    }

    //MARK: - setReachabilityCallback

    var setReachabilityCallbackCallbackCallsCount = 0
    var setReachabilityCallbackCallbackCalled: Bool {
        return setReachabilityCallbackCallbackCallsCount > 0
    }
    var setReachabilityCallbackCallbackReceivedCallback: ((ReachabilityStatus) -> Void)?
    var setReachabilityCallbackCallbackReceivedInvocations: [((ReachabilityStatus) -> Void)] = []
    var setReachabilityCallbackCallbackClosure: ((@escaping (ReachabilityStatus) -> Void) -> Void)?

    func setReachabilityCallback(callback: @escaping (ReachabilityStatus) -> Void) {
        setReachabilityCallbackCallbackCallsCount += 1
        setReachabilityCallbackCallbackReceivedCallback = callback
        setReachabilityCallbackCallbackReceivedInvocations.append(callback)
        setReachabilityCallbackCallbackClosure?(callback)
    }

}
class SearchActivityActionPrismProtocolMock: SearchActivityActionPrismProtocol {


    var removeDetailedEntityAction: Search.ActivityAction {
        get { return underlyingRemoveDetailedEntityAction }
        set(value) { underlyingRemoveDetailedEntityAction = value }
    }
    var underlyingRemoveDetailedEntityAction: Search.ActivityAction!

    //MARK: - detailEntityAction

    var detailEntityActionCallsCount = 0
    var detailEntityActionCalled: Bool {
        return detailEntityActionCallsCount > 0
    }
    var detailEntityActionReceivedEntity: SearchEntityModel?
    var detailEntityActionReceivedInvocations: [SearchEntityModel] = []
    var detailEntityActionReturnValue: Search.ActivityAction!
    var detailEntityActionClosure: ((SearchEntityModel) -> Search.ActivityAction)?

    func detailEntityAction(_ entity: SearchEntityModel) -> Search.ActivityAction {
        detailEntityActionCallsCount += 1
        detailEntityActionReceivedEntity = entity
        detailEntityActionReceivedInvocations.append(entity)
        if let detailEntityActionClosure = detailEntityActionClosure {
            return detailEntityActionClosure(entity)
        } else {
            return detailEntityActionReturnValue
        }
    }

    //MARK: - initialRequestAction

    var initialRequestActionSearchParamsLocationUpdateRequestBlockCallsCount = 0
    var initialRequestActionSearchParamsLocationUpdateRequestBlockCalled: Bool {
        return initialRequestActionSearchParamsLocationUpdateRequestBlockCallsCount > 0
    }
    var initialRequestActionSearchParamsLocationUpdateRequestBlockReceivedArguments: (searchParams: SearchParams, locationUpdateRequestBlock: LocationUpdateRequestBlock)?
    var initialRequestActionSearchParamsLocationUpdateRequestBlockReceivedInvocations: [(searchParams: SearchParams, locationUpdateRequestBlock: LocationUpdateRequestBlock)] = []
    var initialRequestActionSearchParamsLocationUpdateRequestBlockReturnValue: Search.ActivityAction!
    var initialRequestActionSearchParamsLocationUpdateRequestBlockClosure: ((SearchParams, @escaping LocationUpdateRequestBlock) -> Search.ActivityAction)?

    func initialRequestAction(searchParams: SearchParams, locationUpdateRequestBlock: @escaping LocationUpdateRequestBlock) -> Search.ActivityAction {
        initialRequestActionSearchParamsLocationUpdateRequestBlockCallsCount += 1
        initialRequestActionSearchParamsLocationUpdateRequestBlockReceivedArguments = (searchParams: searchParams, locationUpdateRequestBlock: locationUpdateRequestBlock)
        initialRequestActionSearchParamsLocationUpdateRequestBlockReceivedInvocations.append((searchParams: searchParams, locationUpdateRequestBlock: locationUpdateRequestBlock))
        if let initialRequestActionSearchParamsLocationUpdateRequestBlockClosure = initialRequestActionSearchParamsLocationUpdateRequestBlockClosure {
            return initialRequestActionSearchParamsLocationUpdateRequestBlockClosure(searchParams, locationUpdateRequestBlock)
        } else {
            return initialRequestActionSearchParamsLocationUpdateRequestBlockReturnValue
        }
    }

    //MARK: - subsequentRequestAction

    var subsequentRequestActionSearchParamsAllEntitiesNumPagesReceivedTokenContainerThrowableError: Error?
    var subsequentRequestActionSearchParamsAllEntitiesNumPagesReceivedTokenContainerCallsCount = 0
    var subsequentRequestActionSearchParamsAllEntitiesNumPagesReceivedTokenContainerCalled: Bool {
        return subsequentRequestActionSearchParamsAllEntitiesNumPagesReceivedTokenContainerCallsCount > 0
    }
    var subsequentRequestActionSearchParamsAllEntitiesNumPagesReceivedTokenContainerReceivedArguments: (searchParams: SearchParams, allEntities: NonEmptyArray<SearchEntityModel>, numPagesReceived: Int, tokenContainer: PlaceLookupTokenAttemptsContainer)?
    var subsequentRequestActionSearchParamsAllEntitiesNumPagesReceivedTokenContainerReceivedInvocations: [(searchParams: SearchParams, allEntities: NonEmptyArray<SearchEntityModel>, numPagesReceived: Int, tokenContainer: PlaceLookupTokenAttemptsContainer)] = []
    var subsequentRequestActionSearchParamsAllEntitiesNumPagesReceivedTokenContainerReturnValue: Search.ActivityAction!
    var subsequentRequestActionSearchParamsAllEntitiesNumPagesReceivedTokenContainerClosure: ((SearchParams, NonEmptyArray<SearchEntityModel>, Int, PlaceLookupTokenAttemptsContainer) throws -> Search.ActivityAction)?

    func subsequentRequestAction(searchParams: SearchParams, allEntities: NonEmptyArray<SearchEntityModel>, numPagesReceived: Int, tokenContainer: PlaceLookupTokenAttemptsContainer) throws -> Search.ActivityAction {
        subsequentRequestActionSearchParamsAllEntitiesNumPagesReceivedTokenContainerCallsCount += 1
        if let error = subsequentRequestActionSearchParamsAllEntitiesNumPagesReceivedTokenContainerThrowableError {
            throw error
        }
        subsequentRequestActionSearchParamsAllEntitiesNumPagesReceivedTokenContainerReceivedArguments = (searchParams: searchParams, allEntities: allEntities, numPagesReceived: numPagesReceived, tokenContainer: tokenContainer)
        subsequentRequestActionSearchParamsAllEntitiesNumPagesReceivedTokenContainerReceivedInvocations.append((searchParams: searchParams, allEntities: allEntities, numPagesReceived: numPagesReceived, tokenContainer: tokenContainer))
        if let subsequentRequestActionSearchParamsAllEntitiesNumPagesReceivedTokenContainerClosure = subsequentRequestActionSearchParamsAllEntitiesNumPagesReceivedTokenContainerClosure {
            return try subsequentRequestActionSearchParamsAllEntitiesNumPagesReceivedTokenContainerClosure(searchParams, allEntities, numPagesReceived, tokenContainer)
        } else {
            return subsequentRequestActionSearchParamsAllEntitiesNumPagesReceivedTokenContainerReturnValue
        }
    }

    //MARK: - updateEditingAction

    var updateEditingActionCallsCount = 0
    var updateEditingActionCalled: Bool {
        return updateEditingActionCallsCount > 0
    }
    var updateEditingActionReceivedEditEvent: SearchBarEditEvent?
    var updateEditingActionReceivedInvocations: [SearchBarEditEvent] = []
    var updateEditingActionReturnValue: Search.ActivityAction!
    var updateEditingActionClosure: ((SearchBarEditEvent) -> Search.ActivityAction)?

    func updateEditingAction(_ editEvent: SearchBarEditEvent) -> Search.ActivityAction {
        updateEditingActionCallsCount += 1
        updateEditingActionReceivedEditEvent = editEvent
        updateEditingActionReceivedInvocations.append(editEvent)
        if let updateEditingActionClosure = updateEditingActionClosure {
            return updateEditingActionClosure(editEvent)
        } else {
            return updateEditingActionReturnValue
        }
    }

}
class SearchActivityStatePrismProtocolMock: SearchActivityStatePrismProtocol {



    //MARK: - presentationType

    var presentationTypeLocationAuthStateReachabilityStateCallsCount = 0
    var presentationTypeLocationAuthStateReachabilityStateCalled: Bool {
        return presentationTypeLocationAuthStateReachabilityStateCallsCount > 0
    }
    var presentationTypeLocationAuthStateReachabilityStateReceivedArguments: (locationAuthState: LocationAuthState, reachabilityState: ReachabilityState)?
    var presentationTypeLocationAuthStateReachabilityStateReceivedInvocations: [(locationAuthState: LocationAuthState, reachabilityState: ReachabilityState)] = []
    var presentationTypeLocationAuthStateReachabilityStateReturnValue: SearchPresentationType!
    var presentationTypeLocationAuthStateReachabilityStateClosure: ((LocationAuthState, ReachabilityState) -> SearchPresentationType)?

    func presentationType(locationAuthState: LocationAuthState, reachabilityState: ReachabilityState) -> SearchPresentationType {
        presentationTypeLocationAuthStateReachabilityStateCallsCount += 1
        presentationTypeLocationAuthStateReachabilityStateReceivedArguments = (locationAuthState: locationAuthState, reachabilityState: reachabilityState)
        presentationTypeLocationAuthStateReachabilityStateReceivedInvocations.append((locationAuthState: locationAuthState, reachabilityState: reachabilityState))
        if let presentationTypeLocationAuthStateReachabilityStateClosure = presentationTypeLocationAuthStateReachabilityStateClosure {
            return presentationTypeLocationAuthStateReachabilityStateClosure(locationAuthState, reachabilityState)
        } else {
            return presentationTypeLocationAuthStateReachabilityStateReturnValue
        }
    }

}
class SearchBackgroundViewPropsBuilderProtocolMock: SearchBackgroundViewPropsBuilderProtocol {



    //MARK: - buildProps

    var buildPropsKeywordsColoringsCallsCount = 0
    var buildPropsKeywordsColoringsCalled: Bool {
        return buildPropsKeywordsColoringsCallsCount > 0
    }
    var buildPropsKeywordsColoringsReceivedArguments: (keywords: NonEmptyString?, colorings: AppStandardColorings)?
    var buildPropsKeywordsColoringsReceivedInvocations: [(keywords: NonEmptyString?, colorings: AppStandardColorings)] = []
    var buildPropsKeywordsColoringsReturnValue: SearchBackgroundViewProps!
    var buildPropsKeywordsColoringsClosure: ((NonEmptyString?, AppStandardColorings) -> SearchBackgroundViewProps)?

    func buildProps(keywords: NonEmptyString?, colorings: AppStandardColorings) -> SearchBackgroundViewProps {
        buildPropsKeywordsColoringsCallsCount += 1
        buildPropsKeywordsColoringsReceivedArguments = (keywords: keywords, colorings: colorings)
        buildPropsKeywordsColoringsReceivedInvocations.append((keywords: keywords, colorings: colorings))
        if let buildPropsKeywordsColoringsClosure = buildPropsKeywordsColoringsClosure {
            return buildPropsKeywordsColoringsClosure(keywords, colorings)
        } else {
            return buildPropsKeywordsColoringsReturnValue
        }
    }

}
class SearchCopyFormatterProtocolMock: SearchCopyFormatterProtocol {



    //MARK: - formatAddress

    var formatAddressCallsCount = 0
    var formatAddressCalled: Bool {
        return formatAddressCallsCount > 0
    }
    var formatAddressReceivedAddress: PlaceLookupAddressLines?
    var formatAddressReceivedInvocations: [PlaceLookupAddressLines] = []
    var formatAddressReturnValue: NonEmptyString!
    var formatAddressClosure: ((PlaceLookupAddressLines) -> NonEmptyString)?

    func formatAddress(_ address: PlaceLookupAddressLines) -> NonEmptyString {
        formatAddressCallsCount += 1
        formatAddressReceivedAddress = address
        formatAddressReceivedInvocations.append(address)
        if let formatAddressClosure = formatAddressClosure {
            return formatAddressClosure(address)
        } else {
            return formatAddressReturnValue
        }
    }

    //MARK: - formatCallablePhoneNumber

    var formatCallablePhoneNumberDisplayPhoneCallsCount = 0
    var formatCallablePhoneNumberDisplayPhoneCalled: Bool {
        return formatCallablePhoneNumberDisplayPhoneCallsCount > 0
    }
    var formatCallablePhoneNumberDisplayPhoneReceivedDisplayPhone: NonEmptyString?
    var formatCallablePhoneNumberDisplayPhoneReceivedInvocations: [NonEmptyString] = []
    var formatCallablePhoneNumberDisplayPhoneReturnValue: String!
    var formatCallablePhoneNumberDisplayPhoneClosure: ((NonEmptyString) -> String)?

    func formatCallablePhoneNumber(displayPhone: NonEmptyString) -> String {
        formatCallablePhoneNumberDisplayPhoneCallsCount += 1
        formatCallablePhoneNumberDisplayPhoneReceivedDisplayPhone = displayPhone
        formatCallablePhoneNumberDisplayPhoneReceivedInvocations.append(displayPhone)
        if let formatCallablePhoneNumberDisplayPhoneClosure = formatCallablePhoneNumberDisplayPhoneClosure {
            return formatCallablePhoneNumberDisplayPhoneClosure(displayPhone)
        } else {
            return formatCallablePhoneNumberDisplayPhoneReturnValue
        }
    }

    //MARK: - formatNonCallablePhoneNumber

    var formatNonCallablePhoneNumberCallsCount = 0
    var formatNonCallablePhoneNumberCalled: Bool {
        return formatNonCallablePhoneNumberCallsCount > 0
    }
    var formatNonCallablePhoneNumberReceivedDisplayPhone: NonEmptyString?
    var formatNonCallablePhoneNumberReceivedInvocations: [NonEmptyString] = []
    var formatNonCallablePhoneNumberReturnValue: String!
    var formatNonCallablePhoneNumberClosure: ((NonEmptyString) -> String)?

    func formatNonCallablePhoneNumber(_ displayPhone: NonEmptyString) -> String {
        formatNonCallablePhoneNumberCallsCount += 1
        formatNonCallablePhoneNumberReceivedDisplayPhone = displayPhone
        formatNonCallablePhoneNumberReceivedInvocations.append(displayPhone)
        if let formatNonCallablePhoneNumberClosure = formatNonCallablePhoneNumberClosure {
            return formatNonCallablePhoneNumberClosure(displayPhone)
        } else {
            return formatNonCallablePhoneNumberReturnValue
        }
    }

    //MARK: - formatRatings

    var formatRatingsNumRatingsCallsCount = 0
    var formatRatingsNumRatingsCalled: Bool {
        return formatRatingsNumRatingsCallsCount > 0
    }
    var formatRatingsNumRatingsReceivedNumRatings: Int?
    var formatRatingsNumRatingsReceivedInvocations: [Int] = []
    var formatRatingsNumRatingsReturnValue: String!
    var formatRatingsNumRatingsClosure: ((Int) -> String)?

    func formatRatings(numRatings: Int) -> String {
        formatRatingsNumRatingsCallsCount += 1
        formatRatingsNumRatingsReceivedNumRatings = numRatings
        formatRatingsNumRatingsReceivedInvocations.append(numRatings)
        if let formatRatingsNumRatingsClosure = formatRatingsNumRatingsClosure {
            return formatRatingsNumRatingsClosure(numRatings)
        } else {
            return formatRatingsNumRatingsReturnValue
        }
    }

    //MARK: - formatPricing

    var formatPricingPricingCallsCount = 0
    var formatPricingPricingCalled: Bool {
        return formatPricingPricingCallsCount > 0
    }
    var formatPricingPricingReceivedPricing: PlaceLookupPricing?
    var formatPricingPricingReceivedInvocations: [PlaceLookupPricing] = []
    var formatPricingPricingReturnValue: String!
    var formatPricingPricingClosure: ((PlaceLookupPricing) -> String)?

    func formatPricing(pricing: PlaceLookupPricing) -> String {
        formatPricingPricingCallsCount += 1
        formatPricingPricingReceivedPricing = pricing
        formatPricingPricingReceivedInvocations.append(pricing)
        if let formatPricingPricingClosure = formatPricingPricingClosure {
            return formatPricingPricingClosure(pricing)
        } else {
            return formatPricingPricingReturnValue
        }
    }

}
class SearchDetailsPropsBuilderProtocolMock: SearchDetailsPropsBuilderProtocol {



    //MARK: - buildProps

    var buildPropsColoringsCallsCount = 0
    var buildPropsColoringsCalled: Bool {
        return buildPropsColoringsCallsCount > 0
    }
    var buildPropsColoringsReceivedArguments: (entity: SearchEntityModel, colorings: SearchDetailsViewColorings)?
    var buildPropsColoringsReceivedInvocations: [(entity: SearchEntityModel, colorings: SearchDetailsViewColorings)] = []
    var buildPropsColoringsReturnValue: SearchDetailsProps!
    var buildPropsColoringsClosure: ((SearchEntityModel, SearchDetailsViewColorings) -> SearchDetailsProps)?

    func buildProps(_ entity: SearchEntityModel, colorings: SearchDetailsViewColorings) -> SearchDetailsProps {
        buildPropsColoringsCallsCount += 1
        buildPropsColoringsReceivedArguments = (entity: entity, colorings: colorings)
        buildPropsColoringsReceivedInvocations.append((entity: entity, colorings: colorings))
        if let buildPropsColoringsClosure = buildPropsColoringsClosure {
            return buildPropsColoringsClosure(entity, colorings)
        } else {
            return buildPropsColoringsReturnValue
        }
    }

}
class SearchDetailsViewContextBuilderProtocolMock: SearchDetailsViewContextBuilderProtocol {



    //MARK: - buildViewContext

    var buildViewContextColoringsCallsCount = 0
    var buildViewContextColoringsCalled: Bool {
        return buildViewContextColoringsCallsCount > 0
    }
    var buildViewContextColoringsReceivedArguments: (searchActivityState: Search.ActivityState, colorings: SearchDetailsViewColorings)?
    var buildViewContextColoringsReceivedInvocations: [(searchActivityState: Search.ActivityState, colorings: SearchDetailsViewColorings)] = []
    var buildViewContextColoringsReturnValue: SearchDetailsViewContext?
    var buildViewContextColoringsClosure: ((Search.ActivityState, SearchDetailsViewColorings) -> SearchDetailsViewContext?)?

    func buildViewContext(_ searchActivityState: Search.ActivityState, colorings: SearchDetailsViewColorings) -> SearchDetailsViewContext? {
        buildViewContextColoringsCallsCount += 1
        buildViewContextColoringsReceivedArguments = (searchActivityState: searchActivityState, colorings: colorings)
        buildViewContextColoringsReceivedInvocations.append((searchActivityState: searchActivityState, colorings: colorings))
        if let buildViewContextColoringsClosure = buildViewContextColoringsClosure {
            return buildViewContextColoringsClosure(searchActivityState, colorings)
        } else {
            return buildViewContextColoringsReturnValue
        }
    }

}
class SearchInputContentPropsBuilderProtocolMock: SearchInputContentPropsBuilderProtocol {



    //MARK: - buildProps

    var buildPropsKeywordsBarStateCallsCount = 0
    var buildPropsKeywordsBarStateCalled: Bool {
        return buildPropsKeywordsBarStateCallsCount > 0
    }
    var buildPropsKeywordsBarStateReceivedArguments: (keywords: NonEmptyString?, barState: SearchInputParams.BarState)?
    var buildPropsKeywordsBarStateReceivedInvocations: [(keywords: NonEmptyString?, barState: SearchInputParams.BarState)] = []
    var buildPropsKeywordsBarStateReturnValue: SearchInputContentProps!
    var buildPropsKeywordsBarStateClosure: ((NonEmptyString?, SearchInputParams.BarState) -> SearchInputContentProps)?

    func buildProps(keywords: NonEmptyString?, barState: SearchInputParams.BarState) -> SearchInputContentProps {
        buildPropsKeywordsBarStateCallsCount += 1
        buildPropsKeywordsBarStateReceivedArguments = (keywords: keywords, barState: barState)
        buildPropsKeywordsBarStateReceivedInvocations.append((keywords: keywords, barState: barState))
        if let buildPropsKeywordsBarStateClosure = buildPropsKeywordsBarStateClosure {
            return buildPropsKeywordsBarStateClosure(keywords, barState)
        } else {
            return buildPropsKeywordsBarStateReturnValue
        }
    }

}
class SearchInputPropsBuilderProtocolMock: SearchInputPropsBuilderProtocol {



    //MARK: - buildProps

    var buildPropsInputParamsCallsCount = 0
    var buildPropsInputParamsCalled: Bool {
        return buildPropsInputParamsCallsCount > 0
    }
    var buildPropsInputParamsReceivedInputParams: SearchInputParams?
    var buildPropsInputParamsReceivedInvocations: [SearchInputParams] = []
    var buildPropsInputParamsReturnValue: SearchInputProps!
    var buildPropsInputParamsClosure: ((SearchInputParams) -> SearchInputProps)?

    func buildProps(inputParams: SearchInputParams) -> SearchInputProps {
        buildPropsInputParamsCallsCount += 1
        buildPropsInputParamsReceivedInputParams = inputParams
        buildPropsInputParamsReceivedInvocations.append(inputParams)
        if let buildPropsInputParamsClosure = buildPropsInputParamsClosure {
            return buildPropsInputParamsClosure(inputParams)
        } else {
            return buildPropsInputParamsReturnValue
        }
    }

}
class SearchInstructionsPropsBuilderProtocolMock: SearchInstructionsPropsBuilderProtocol {



    //MARK: - buildProps

    var buildPropsColoringsCallsCount = 0
    var buildPropsColoringsCalled: Bool {
        return buildPropsColoringsCallsCount > 0
    }
    var buildPropsColoringsReceivedColorings: AppStandardColorings?
    var buildPropsColoringsReceivedInvocations: [AppStandardColorings] = []
    var buildPropsColoringsReturnValue: SearchInstructionsProps!
    var buildPropsColoringsClosure: ((AppStandardColorings) -> SearchInstructionsProps)?

    func buildProps(colorings: AppStandardColorings) -> SearchInstructionsProps {
        buildPropsColoringsCallsCount += 1
        buildPropsColoringsReceivedColorings = colorings
        buildPropsColoringsReceivedInvocations.append(colorings)
        if let buildPropsColoringsClosure = buildPropsColoringsClosure {
            return buildPropsColoringsClosure(colorings)
        } else {
            return buildPropsColoringsReturnValue
        }
    }

}
class SearchLookupChildBuilderProtocolMock: SearchLookupChildBuilderProtocol {



    //MARK: - buildChild

    var buildChildLoadStateAppSkinLocationUpdateRequestBlockCallsCount = 0
    var buildChildLoadStateAppSkinLocationUpdateRequestBlockCalled: Bool {
        return buildChildLoadStateAppSkinLocationUpdateRequestBlockCallsCount > 0
    }
    var buildChildLoadStateAppSkinLocationUpdateRequestBlockReceivedArguments: (loadState: Search.LoadState, appSkin: AppSkin, locationUpdateRequestBlock: LocationUpdateRequestBlock)?
    var buildChildLoadStateAppSkinLocationUpdateRequestBlockReceivedInvocations: [(loadState: Search.LoadState, appSkin: AppSkin, locationUpdateRequestBlock: LocationUpdateRequestBlock)] = []
    var buildChildLoadStateAppSkinLocationUpdateRequestBlockReturnValue: SearchLookupChild!
    var buildChildLoadStateAppSkinLocationUpdateRequestBlockClosure: ((Search.LoadState, AppSkin, @escaping LocationUpdateRequestBlock) -> SearchLookupChild)?

    func buildChild(loadState: Search.LoadState, appSkin: AppSkin, locationUpdateRequestBlock: @escaping LocationUpdateRequestBlock) -> SearchLookupChild {
        buildChildLoadStateAppSkinLocationUpdateRequestBlockCallsCount += 1
        buildChildLoadStateAppSkinLocationUpdateRequestBlockReceivedArguments = (loadState: loadState, appSkin: appSkin, locationUpdateRequestBlock: locationUpdateRequestBlock)
        buildChildLoadStateAppSkinLocationUpdateRequestBlockReceivedInvocations.append((loadState: loadState, appSkin: appSkin, locationUpdateRequestBlock: locationUpdateRequestBlock))
        if let buildChildLoadStateAppSkinLocationUpdateRequestBlockClosure = buildChildLoadStateAppSkinLocationUpdateRequestBlockClosure {
            return buildChildLoadStateAppSkinLocationUpdateRequestBlockClosure(loadState, appSkin, locationUpdateRequestBlock)
        } else {
            return buildChildLoadStateAppSkinLocationUpdateRequestBlockReturnValue
        }
    }

}
class SearchLookupPropsBuilderProtocolMock: SearchLookupPropsBuilderProtocol {



    //MARK: - buildProps

    var buildPropsSearchActivityStateAppSkinLocationUpdateRequestBlockCallsCount = 0
    var buildPropsSearchActivityStateAppSkinLocationUpdateRequestBlockCalled: Bool {
        return buildPropsSearchActivityStateAppSkinLocationUpdateRequestBlockCallsCount > 0
    }
    var buildPropsSearchActivityStateAppSkinLocationUpdateRequestBlockReceivedArguments: (searchActivityState: Search.ActivityState, appSkin: AppSkin, locationUpdateRequestBlock: LocationUpdateRequestBlock)?
    var buildPropsSearchActivityStateAppSkinLocationUpdateRequestBlockReceivedInvocations: [(searchActivityState: Search.ActivityState, appSkin: AppSkin, locationUpdateRequestBlock: LocationUpdateRequestBlock)] = []
    var buildPropsSearchActivityStateAppSkinLocationUpdateRequestBlockReturnValue: SearchLookupProps!
    var buildPropsSearchActivityStateAppSkinLocationUpdateRequestBlockClosure: ((Search.ActivityState, AppSkin, @escaping LocationUpdateRequestBlock) -> SearchLookupProps)?

    func buildProps(searchActivityState: Search.ActivityState, appSkin: AppSkin, locationUpdateRequestBlock: @escaping LocationUpdateRequestBlock) -> SearchLookupProps {
        buildPropsSearchActivityStateAppSkinLocationUpdateRequestBlockCallsCount += 1
        buildPropsSearchActivityStateAppSkinLocationUpdateRequestBlockReceivedArguments = (searchActivityState: searchActivityState, appSkin: appSkin, locationUpdateRequestBlock: locationUpdateRequestBlock)
        buildPropsSearchActivityStateAppSkinLocationUpdateRequestBlockReceivedInvocations.append((searchActivityState: searchActivityState, appSkin: appSkin, locationUpdateRequestBlock: locationUpdateRequestBlock))
        if let buildPropsSearchActivityStateAppSkinLocationUpdateRequestBlockClosure = buildPropsSearchActivityStateAppSkinLocationUpdateRequestBlockClosure {
            return buildPropsSearchActivityStateAppSkinLocationUpdateRequestBlockClosure(searchActivityState, appSkin, locationUpdateRequestBlock)
        } else {
            return buildPropsSearchActivityStateAppSkinLocationUpdateRequestBlockReturnValue
        }
    }

}
class SearchNoResultsFoundPropsBuilderProtocolMock: SearchNoResultsFoundPropsBuilderProtocol {



    //MARK: - buildProps

    var buildPropsColoringsCallsCount = 0
    var buildPropsColoringsCalled: Bool {
        return buildPropsColoringsCallsCount > 0
    }
    var buildPropsColoringsReceivedColorings: AppStandardColorings?
    var buildPropsColoringsReceivedInvocations: [AppStandardColorings] = []
    var buildPropsColoringsReturnValue: SearchNoResultsFoundProps!
    var buildPropsColoringsClosure: ((AppStandardColorings) -> SearchNoResultsFoundProps)?

    func buildProps(colorings: AppStandardColorings) -> SearchNoResultsFoundProps {
        buildPropsColoringsCallsCount += 1
        buildPropsColoringsReceivedColorings = colorings
        buildPropsColoringsReceivedInvocations.append(colorings)
        if let buildPropsColoringsClosure = buildPropsColoringsClosure {
            return buildPropsColoringsClosure(colorings)
        } else {
            return buildPropsColoringsReturnValue
        }
    }

}
class SearchPresenterProtocolMock: SearchPresenterProtocol {


    var rootViewController: UIViewController {
        get { return underlyingRootViewController }
        set(value) { underlyingRootViewController = value }
    }
    var underlyingRootViewController: UIViewController!

    //MARK: - loadNoInternetViews

    var loadNoInternetViewsTitlePropsAppSkinCallsCount = 0
    var loadNoInternetViewsTitlePropsAppSkinCalled: Bool {
        return loadNoInternetViewsTitlePropsAppSkinCallsCount > 0
    }
    var loadNoInternetViewsTitlePropsAppSkinReceivedArguments: (props: SearchNoInternetViewProps, titleProps: NavigationBarTitleViewProps, appSkin: AppSkin)?
    var loadNoInternetViewsTitlePropsAppSkinReceivedInvocations: [(props: SearchNoInternetViewProps, titleProps: NavigationBarTitleViewProps, appSkin: AppSkin)] = []
    var loadNoInternetViewsTitlePropsAppSkinClosure: ((SearchNoInternetViewProps, NavigationBarTitleViewProps, AppSkin) -> Void)?

    func loadNoInternetViews(_ props: SearchNoInternetViewProps, titleProps: NavigationBarTitleViewProps, appSkin: AppSkin) {
        loadNoInternetViewsTitlePropsAppSkinCallsCount += 1
        loadNoInternetViewsTitlePropsAppSkinReceivedArguments = (props: props, titleProps: titleProps, appSkin: appSkin)
        loadNoInternetViewsTitlePropsAppSkinReceivedInvocations.append((props: props, titleProps: titleProps, appSkin: appSkin))
        loadNoInternetViewsTitlePropsAppSkinClosure?(props, titleProps, appSkin)
    }

    //MARK: - loadLocationServicesDisabledViews

    var loadLocationServicesDisabledViewsCtaBlockTitlePropsAppSkinCallsCount = 0
    var loadLocationServicesDisabledViewsCtaBlockTitlePropsAppSkinCalled: Bool {
        return loadLocationServicesDisabledViewsCtaBlockTitlePropsAppSkinCallsCount > 0
    }
    var loadLocationServicesDisabledViewsCtaBlockTitlePropsAppSkinReceivedArguments: (props: SearchLocationDisabledViewProps, ctaBlock: SearchCTABlock?, titleProps: NavigationBarTitleViewProps, appSkin: AppSkin)?
    var loadLocationServicesDisabledViewsCtaBlockTitlePropsAppSkinReceivedInvocations: [(props: SearchLocationDisabledViewProps, ctaBlock: SearchCTABlock?, titleProps: NavigationBarTitleViewProps, appSkin: AppSkin)] = []
    var loadLocationServicesDisabledViewsCtaBlockTitlePropsAppSkinClosure: ((SearchLocationDisabledViewProps, SearchCTABlock?, NavigationBarTitleViewProps, AppSkin) -> Void)?

    func loadLocationServicesDisabledViews(_ props: SearchLocationDisabledViewProps, ctaBlock: SearchCTABlock?, titleProps: NavigationBarTitleViewProps, appSkin: AppSkin) {
        loadLocationServicesDisabledViewsCtaBlockTitlePropsAppSkinCallsCount += 1
        loadLocationServicesDisabledViewsCtaBlockTitlePropsAppSkinReceivedArguments = (props: props, ctaBlock: ctaBlock, titleProps: titleProps, appSkin: appSkin)
        loadLocationServicesDisabledViewsCtaBlockTitlePropsAppSkinReceivedInvocations.append((props: props, ctaBlock: ctaBlock, titleProps: titleProps, appSkin: appSkin))
        loadLocationServicesDisabledViewsCtaBlockTitlePropsAppSkinClosure?(props, ctaBlock, titleProps, appSkin)
    }

    //MARK: - loadSearchBackgroundView

    var loadSearchBackgroundViewTitlePropsAppSkinCallsCount = 0
    var loadSearchBackgroundViewTitlePropsAppSkinCalled: Bool {
        return loadSearchBackgroundViewTitlePropsAppSkinCallsCount > 0
    }
    var loadSearchBackgroundViewTitlePropsAppSkinReceivedArguments: (props: SearchBackgroundViewProps, titleProps: NavigationBarTitleViewProps, appSkin: AppSkin)?
    var loadSearchBackgroundViewTitlePropsAppSkinReceivedInvocations: [(props: SearchBackgroundViewProps, titleProps: NavigationBarTitleViewProps, appSkin: AppSkin)] = []
    var loadSearchBackgroundViewTitlePropsAppSkinClosure: ((SearchBackgroundViewProps, NavigationBarTitleViewProps, AppSkin) -> Void)?

    func loadSearchBackgroundView(_ props: SearchBackgroundViewProps, titleProps: NavigationBarTitleViewProps, appSkin: AppSkin) {
        loadSearchBackgroundViewTitlePropsAppSkinCallsCount += 1
        loadSearchBackgroundViewTitlePropsAppSkinReceivedArguments = (props: props, titleProps: titleProps, appSkin: appSkin)
        loadSearchBackgroundViewTitlePropsAppSkinReceivedInvocations.append((props: props, titleProps: titleProps, appSkin: appSkin))
        loadSearchBackgroundViewTitlePropsAppSkinClosure?(props, titleProps, appSkin)
    }

    //MARK: - loadSearchViews

    var loadSearchViewsViewModelDetailsViewContextTitlePropsAppSkinCallsCount = 0
    var loadSearchViewsViewModelDetailsViewContextTitlePropsAppSkinCalled: Bool {
        return loadSearchViewsViewModelDetailsViewContextTitlePropsAppSkinCallsCount > 0
    }
    var loadSearchViewsViewModelDetailsViewContextTitlePropsAppSkinReceivedArguments: (props: SearchLookupProps, viewModel: SearchViewModel, detailsViewContext: SearchDetailsViewContext?, titleProps: NavigationBarTitleViewProps, appSkin: AppSkin)?
    var loadSearchViewsViewModelDetailsViewContextTitlePropsAppSkinReceivedInvocations: [(props: SearchLookupProps, viewModel: SearchViewModel, detailsViewContext: SearchDetailsViewContext?, titleProps: NavigationBarTitleViewProps, appSkin: AppSkin)] = []
    var loadSearchViewsViewModelDetailsViewContextTitlePropsAppSkinClosure: ((SearchLookupProps, SearchViewModel, SearchDetailsViewContext?, NavigationBarTitleViewProps, AppSkin) -> Void)?

    func loadSearchViews(_ props: SearchLookupProps, viewModel: SearchViewModel, detailsViewContext: SearchDetailsViewContext?, titleProps: NavigationBarTitleViewProps, appSkin: AppSkin) {
        loadSearchViewsViewModelDetailsViewContextTitlePropsAppSkinCallsCount += 1
        loadSearchViewsViewModelDetailsViewContextTitlePropsAppSkinReceivedArguments = (props: props, viewModel: viewModel, detailsViewContext: detailsViewContext, titleProps: titleProps, appSkin: appSkin)
        loadSearchViewsViewModelDetailsViewContextTitlePropsAppSkinReceivedInvocations.append((props: props, viewModel: viewModel, detailsViewContext: detailsViewContext, titleProps: titleProps, appSkin: appSkin))
        loadSearchViewsViewModelDetailsViewContextTitlePropsAppSkinClosure?(props, viewModel, detailsViewContext, titleProps, appSkin)
    }

}
class SearchResultCellPropsBuilderProtocolMock: SearchResultCellPropsBuilderProtocol {



    //MARK: - buildProps

    var buildPropsModelColoringsCallsCount = 0
    var buildPropsModelColoringsCalled: Bool {
        return buildPropsModelColoringsCallsCount > 0
    }
    var buildPropsModelColoringsReceivedArguments: (model: SearchEntityModel, colorings: SearchResultsViewColorings)?
    var buildPropsModelColoringsReceivedInvocations: [(model: SearchEntityModel, colorings: SearchResultsViewColorings)] = []
    var buildPropsModelColoringsReturnValue: SearchResultCellProps!
    var buildPropsModelColoringsClosure: ((SearchEntityModel, SearchResultsViewColorings) -> SearchResultCellProps)?

    func buildProps(model: SearchEntityModel, colorings: SearchResultsViewColorings) -> SearchResultCellProps {
        buildPropsModelColoringsCallsCount += 1
        buildPropsModelColoringsReceivedArguments = (model: model, colorings: colorings)
        buildPropsModelColoringsReceivedInvocations.append((model: model, colorings: colorings))
        if let buildPropsModelColoringsClosure = buildPropsModelColoringsClosure {
            return buildPropsModelColoringsClosure(model, colorings)
        } else {
            return buildPropsModelColoringsReturnValue
        }
    }

}
class SearchResultPropsBuilderProtocolMock: SearchResultPropsBuilderProtocol {



    //MARK: - buildProps

    var buildPropsModelColoringsCallsCount = 0
    var buildPropsModelColoringsCalled: Bool {
        return buildPropsModelColoringsCallsCount > 0
    }
    var buildPropsModelColoringsReceivedArguments: (model: SearchEntityModel, colorings: SearchResultsViewColorings)?
    var buildPropsModelColoringsReceivedInvocations: [(model: SearchEntityModel, colorings: SearchResultsViewColorings)] = []
    var buildPropsModelColoringsReturnValue: SearchResultProps!
    var buildPropsModelColoringsClosure: ((SearchEntityModel, SearchResultsViewColorings) -> SearchResultProps)?

    func buildProps(model: SearchEntityModel, colorings: SearchResultsViewColorings) -> SearchResultProps {
        buildPropsModelColoringsCallsCount += 1
        buildPropsModelColoringsReceivedArguments = (model: model, colorings: colorings)
        buildPropsModelColoringsReceivedInvocations.append((model: model, colorings: colorings))
        if let buildPropsModelColoringsClosure = buildPropsModelColoringsClosure {
            return buildPropsModelColoringsClosure(model, colorings)
        } else {
            return buildPropsModelColoringsReturnValue
        }
    }

}
class SearchResultsViewPropsBuilderProtocolMock: SearchResultsViewPropsBuilderProtocol {



    //MARK: - buildProps

    var buildPropsSubmittedParamsAllEntitiesColoringsNumPagesReceivedTokenContainerLocationUpdateRequestBlockCallsCount = 0
    var buildPropsSubmittedParamsAllEntitiesColoringsNumPagesReceivedTokenContainerLocationUpdateRequestBlockCalled: Bool {
        return buildPropsSubmittedParamsAllEntitiesColoringsNumPagesReceivedTokenContainerLocationUpdateRequestBlockCallsCount > 0
    }
    var buildPropsSubmittedParamsAllEntitiesColoringsNumPagesReceivedTokenContainerLocationUpdateRequestBlockReceivedArguments: (submittedParams: SearchParams, allEntities: NonEmptyArray<SearchEntityModel>, colorings: SearchResultsViewColorings, numPagesReceived: Int, tokenContainer: PlaceLookupTokenAttemptsContainer?, locationUpdateRequestBlock: LocationUpdateRequestBlock)?
    var buildPropsSubmittedParamsAllEntitiesColoringsNumPagesReceivedTokenContainerLocationUpdateRequestBlockReceivedInvocations: [(submittedParams: SearchParams, allEntities: NonEmptyArray<SearchEntityModel>, colorings: SearchResultsViewColorings, numPagesReceived: Int, tokenContainer: PlaceLookupTokenAttemptsContainer?, locationUpdateRequestBlock: LocationUpdateRequestBlock)] = []
    var buildPropsSubmittedParamsAllEntitiesColoringsNumPagesReceivedTokenContainerLocationUpdateRequestBlockReturnValue: SearchResultsViewProps!
    var buildPropsSubmittedParamsAllEntitiesColoringsNumPagesReceivedTokenContainerLocationUpdateRequestBlockClosure: ((SearchParams, NonEmptyArray<SearchEntityModel>, SearchResultsViewColorings, Int, PlaceLookupTokenAttemptsContainer?, @escaping LocationUpdateRequestBlock) -> SearchResultsViewProps)?

    func buildProps(submittedParams: SearchParams, allEntities: NonEmptyArray<SearchEntityModel>, colorings: SearchResultsViewColorings, numPagesReceived: Int, tokenContainer: PlaceLookupTokenAttemptsContainer?, locationUpdateRequestBlock: @escaping LocationUpdateRequestBlock) -> SearchResultsViewProps {
        buildPropsSubmittedParamsAllEntitiesColoringsNumPagesReceivedTokenContainerLocationUpdateRequestBlockCallsCount += 1
        buildPropsSubmittedParamsAllEntitiesColoringsNumPagesReceivedTokenContainerLocationUpdateRequestBlockReceivedArguments = (submittedParams: submittedParams, allEntities: allEntities, colorings: colorings, numPagesReceived: numPagesReceived, tokenContainer: tokenContainer, locationUpdateRequestBlock: locationUpdateRequestBlock)
        buildPropsSubmittedParamsAllEntitiesColoringsNumPagesReceivedTokenContainerLocationUpdateRequestBlockReceivedInvocations.append((submittedParams: submittedParams, allEntities: allEntities, colorings: colorings, numPagesReceived: numPagesReceived, tokenContainer: tokenContainer, locationUpdateRequestBlock: locationUpdateRequestBlock))
        if let buildPropsSubmittedParamsAllEntitiesColoringsNumPagesReceivedTokenContainerLocationUpdateRequestBlockClosure = buildPropsSubmittedParamsAllEntitiesColoringsNumPagesReceivedTokenContainerLocationUpdateRequestBlockClosure {
            return buildPropsSubmittedParamsAllEntitiesColoringsNumPagesReceivedTokenContainerLocationUpdateRequestBlockClosure(submittedParams, allEntities, colorings, numPagesReceived, tokenContainer, locationUpdateRequestBlock)
        } else {
            return buildPropsSubmittedParamsAllEntitiesColoringsNumPagesReceivedTokenContainerLocationUpdateRequestBlockReturnValue
        }
    }

}
class SearchRetryPropsBuilderProtocolMock: SearchRetryPropsBuilderProtocol {



    //MARK: - buildProps

    var buildPropsColoringsRetryActionCallsCount = 0
    var buildPropsColoringsRetryActionCalled: Bool {
        return buildPropsColoringsRetryActionCallsCount > 0
    }
    var buildPropsColoringsRetryActionReceivedArguments: (colorings: SearchCTAViewColorings, retryAction: Search.Action)?
    var buildPropsColoringsRetryActionReceivedInvocations: [(colorings: SearchCTAViewColorings, retryAction: Search.Action)] = []
    var buildPropsColoringsRetryActionReturnValue: SearchRetryProps!
    var buildPropsColoringsRetryActionClosure: ((SearchCTAViewColorings, Search.Action) -> SearchRetryProps)?

    func buildProps(colorings: SearchCTAViewColorings, retryAction: Search.Action) -> SearchRetryProps {
        buildPropsColoringsRetryActionCallsCount += 1
        buildPropsColoringsRetryActionReceivedArguments = (colorings: colorings, retryAction: retryAction)
        buildPropsColoringsRetryActionReceivedInvocations.append((colorings: colorings, retryAction: retryAction))
        if let buildPropsColoringsRetryActionClosure = buildPropsColoringsRetryActionClosure {
            return buildPropsColoringsRetryActionClosure(colorings, retryAction)
        } else {
            return buildPropsColoringsRetryActionReturnValue
        }
    }

}
class SettingsCellPropsBuilderProtocolMock: SettingsCellPropsBuilderProtocol {



    //MARK: - buildDistanceCellProps

    var buildDistanceCellPropsCurrentDistanceTypeColoringsCallsCount = 0
    var buildDistanceCellPropsCurrentDistanceTypeColoringsCalled: Bool {
        return buildDistanceCellPropsCurrentDistanceTypeColoringsCallsCount > 0
    }
    var buildDistanceCellPropsCurrentDistanceTypeColoringsReceivedArguments: (currentDistanceType: SearchDistance, colorings: SettingsCellColorings)?
    var buildDistanceCellPropsCurrentDistanceTypeColoringsReceivedInvocations: [(currentDistanceType: SearchDistance, colorings: SettingsCellColorings)] = []
    var buildDistanceCellPropsCurrentDistanceTypeColoringsReturnValue: [SettingsCellProps]!
    var buildDistanceCellPropsCurrentDistanceTypeColoringsClosure: ((SearchDistance, SettingsCellColorings) -> [SettingsCellProps])?

    func buildDistanceCellProps(currentDistanceType: SearchDistance, colorings: SettingsCellColorings) -> [SettingsCellProps] {
        buildDistanceCellPropsCurrentDistanceTypeColoringsCallsCount += 1
        buildDistanceCellPropsCurrentDistanceTypeColoringsReceivedArguments = (currentDistanceType: currentDistanceType, colorings: colorings)
        buildDistanceCellPropsCurrentDistanceTypeColoringsReceivedInvocations.append((currentDistanceType: currentDistanceType, colorings: colorings))
        if let buildDistanceCellPropsCurrentDistanceTypeColoringsClosure = buildDistanceCellPropsCurrentDistanceTypeColoringsClosure {
            return buildDistanceCellPropsCurrentDistanceTypeColoringsClosure(currentDistanceType, colorings)
        } else {
            return buildDistanceCellPropsCurrentDistanceTypeColoringsReturnValue
        }
    }

    //MARK: - buildSortingCellProps

    var buildSortingCellPropsCurrentSortingColoringsCallsCount = 0
    var buildSortingCellPropsCurrentSortingColoringsCalled: Bool {
        return buildSortingCellPropsCurrentSortingColoringsCallsCount > 0
    }
    var buildSortingCellPropsCurrentSortingColoringsReceivedArguments: (currentSorting: PlaceLookupSorting, colorings: SettingsCellColorings)?
    var buildSortingCellPropsCurrentSortingColoringsReceivedInvocations: [(currentSorting: PlaceLookupSorting, colorings: SettingsCellColorings)] = []
    var buildSortingCellPropsCurrentSortingColoringsReturnValue: [SettingsCellProps]!
    var buildSortingCellPropsCurrentSortingColoringsClosure: ((PlaceLookupSorting, SettingsCellColorings) -> [SettingsCellProps])?

    func buildSortingCellProps(currentSorting: PlaceLookupSorting, colorings: SettingsCellColorings) -> [SettingsCellProps] {
        buildSortingCellPropsCurrentSortingColoringsCallsCount += 1
        buildSortingCellPropsCurrentSortingColoringsReceivedArguments = (currentSorting: currentSorting, colorings: colorings)
        buildSortingCellPropsCurrentSortingColoringsReceivedInvocations.append((currentSorting: currentSorting, colorings: colorings))
        if let buildSortingCellPropsCurrentSortingColoringsClosure = buildSortingCellPropsCurrentSortingColoringsClosure {
            return buildSortingCellPropsCurrentSortingColoringsClosure(currentSorting, colorings)
        } else {
            return buildSortingCellPropsCurrentSortingColoringsReturnValue
        }
    }

}
class SettingsPlainHeaderPropsBuilderProtocolMock: SettingsPlainHeaderPropsBuilderProtocol {



    //MARK: - buildProps

    var buildPropsTitleColoringsCallsCount = 0
    var buildPropsTitleColoringsCalled: Bool {
        return buildPropsTitleColoringsCallsCount > 0
    }
    var buildPropsTitleColoringsReceivedArguments: (title: String, colorings: SettingsHeaderViewColorings)?
    var buildPropsTitleColoringsReceivedInvocations: [(title: String, colorings: SettingsHeaderViewColorings)] = []
    var buildPropsTitleColoringsReturnValue: SettingsPlainHeaderProps!
    var buildPropsTitleColoringsClosure: ((String, SettingsHeaderViewColorings) -> SettingsPlainHeaderProps)?

    func buildProps(title: String, colorings: SettingsHeaderViewColorings) -> SettingsPlainHeaderProps {
        buildPropsTitleColoringsCallsCount += 1
        buildPropsTitleColoringsReceivedArguments = (title: title, colorings: colorings)
        buildPropsTitleColoringsReceivedInvocations.append((title: title, colorings: colorings))
        if let buildPropsTitleColoringsClosure = buildPropsTitleColoringsClosure {
            return buildPropsTitleColoringsClosure(title, colorings)
        } else {
            return buildPropsTitleColoringsReturnValue
        }
    }

}
class SettingsPresenterProtocolMock: SettingsPresenterProtocol {


    var rootNavController: UINavigationController {
        get { return underlyingRootNavController }
        set(value) { underlyingRootNavController = value }
    }
    var underlyingRootNavController: UINavigationController!

    //MARK: - loadSettingsView

    var loadSettingsViewViewModelTitlePropsAppSkinCallsCount = 0
    var loadSettingsViewViewModelTitlePropsAppSkinCalled: Bool {
        return loadSettingsViewViewModelTitlePropsAppSkinCallsCount > 0
    }
    var loadSettingsViewViewModelTitlePropsAppSkinReceivedArguments: (props: SettingsViewProps, viewModel: SettingsViewModel, titleProps: NavigationBarTitleViewProps, appSkin: AppSkin)?
    var loadSettingsViewViewModelTitlePropsAppSkinReceivedInvocations: [(props: SettingsViewProps, viewModel: SettingsViewModel, titleProps: NavigationBarTitleViewProps, appSkin: AppSkin)] = []
    var loadSettingsViewViewModelTitlePropsAppSkinClosure: ((SettingsViewProps, SettingsViewModel, NavigationBarTitleViewProps, AppSkin) -> Void)?

    func loadSettingsView(_ props: SettingsViewProps, viewModel: SettingsViewModel, titleProps: NavigationBarTitleViewProps, appSkin: AppSkin) {
        loadSettingsViewViewModelTitlePropsAppSkinCallsCount += 1
        loadSettingsViewViewModelTitlePropsAppSkinReceivedArguments = (props: props, viewModel: viewModel, titleProps: titleProps, appSkin: appSkin)
        loadSettingsViewViewModelTitlePropsAppSkinReceivedInvocations.append((props: props, viewModel: viewModel, titleProps: titleProps, appSkin: appSkin))
        loadSettingsViewViewModelTitlePropsAppSkinClosure?(props, viewModel, titleProps, appSkin)
    }

}
class SettingsUnitsHeaderPropsBuilderProtocolMock: SettingsUnitsHeaderPropsBuilderProtocol {



    //MARK: - buildProps

    var buildPropsTitleCurrentlyActiveSystemColoringsCallsCount = 0
    var buildPropsTitleCurrentlyActiveSystemColoringsCalled: Bool {
        return buildPropsTitleCurrentlyActiveSystemColoringsCallsCount > 0
    }
    var buildPropsTitleCurrentlyActiveSystemColoringsReceivedArguments: (title: String, currentlyActiveSystem: MeasurementSystem, colorings: SettingsHeaderViewColorings)?
    var buildPropsTitleCurrentlyActiveSystemColoringsReceivedInvocations: [(title: String, currentlyActiveSystem: MeasurementSystem, colorings: SettingsHeaderViewColorings)] = []
    var buildPropsTitleCurrentlyActiveSystemColoringsReturnValue: SettingsUnitsHeaderProps!
    var buildPropsTitleCurrentlyActiveSystemColoringsClosure: ((String, MeasurementSystem, SettingsHeaderViewColorings) -> SettingsUnitsHeaderProps)?

    func buildProps(title: String, currentlyActiveSystem: MeasurementSystem, colorings: SettingsHeaderViewColorings) -> SettingsUnitsHeaderProps {
        buildPropsTitleCurrentlyActiveSystemColoringsCallsCount += 1
        buildPropsTitleCurrentlyActiveSystemColoringsReceivedArguments = (title: title, currentlyActiveSystem: currentlyActiveSystem, colorings: colorings)
        buildPropsTitleCurrentlyActiveSystemColoringsReceivedInvocations.append((title: title, currentlyActiveSystem: currentlyActiveSystem, colorings: colorings))
        if let buildPropsTitleCurrentlyActiveSystemColoringsClosure = buildPropsTitleCurrentlyActiveSystemColoringsClosure {
            return buildPropsTitleCurrentlyActiveSystemColoringsClosure(title, currentlyActiveSystem, colorings)
        } else {
            return buildPropsTitleCurrentlyActiveSystemColoringsReturnValue
        }
    }

}
class SettingsViewPropsBuilderProtocolMock: SettingsViewPropsBuilderProtocol {



    //MARK: - buildProps

    var buildPropsSearchPreferencesStateAppDisplayNameColoringsCallsCount = 0
    var buildPropsSearchPreferencesStateAppDisplayNameColoringsCalled: Bool {
        return buildPropsSearchPreferencesStateAppDisplayNameColoringsCallsCount > 0
    }
    var buildPropsSearchPreferencesStateAppDisplayNameColoringsReceivedArguments: (searchPreferencesState: SearchPreferencesState, appDisplayName: NonEmptyString, colorings: SettingsViewColorings)?
    var buildPropsSearchPreferencesStateAppDisplayNameColoringsReceivedInvocations: [(searchPreferencesState: SearchPreferencesState, appDisplayName: NonEmptyString, colorings: SettingsViewColorings)] = []
    var buildPropsSearchPreferencesStateAppDisplayNameColoringsReturnValue: SettingsViewProps!
    var buildPropsSearchPreferencesStateAppDisplayNameColoringsClosure: ((SearchPreferencesState, NonEmptyString, SettingsViewColorings) -> SettingsViewProps)?

    func buildProps(searchPreferencesState: SearchPreferencesState, appDisplayName: NonEmptyString, colorings: SettingsViewColorings) -> SettingsViewProps {
        buildPropsSearchPreferencesStateAppDisplayNameColoringsCallsCount += 1
        buildPropsSearchPreferencesStateAppDisplayNameColoringsReceivedArguments = (searchPreferencesState: searchPreferencesState, appDisplayName: appDisplayName, colorings: colorings)
        buildPropsSearchPreferencesStateAppDisplayNameColoringsReceivedInvocations.append((searchPreferencesState: searchPreferencesState, appDisplayName: appDisplayName, colorings: colorings))
        if let buildPropsSearchPreferencesStateAppDisplayNameColoringsClosure = buildPropsSearchPreferencesStateAppDisplayNameColoringsClosure {
            return buildPropsSearchPreferencesStateAppDisplayNameColoringsClosure(searchPreferencesState, appDisplayName, colorings)
        } else {
            return buildPropsSearchPreferencesStateAppDisplayNameColoringsReturnValue
        }
    }

}
class TabCoordinatorProtocolMock: TabCoordinatorProtocol {


    var rootViewController: UIViewController {
        get { return underlyingRootViewController }
        set(value) { underlyingRootViewController = value }
    }
    var underlyingRootViewController: UIViewController!

    //MARK: - relinquishActive

    var relinquishActiveCompletionCallsCount = 0
    var relinquishActiveCompletionCalled: Bool {
        return relinquishActiveCompletionCallsCount > 0
    }
    var relinquishActiveCompletionReceivedCompletion: ((() -> Void))?
    var relinquishActiveCompletionReceivedInvocations: [((() -> Void))?] = []
    var relinquishActiveCompletionClosure: (((() -> Void)?) -> Void)?

    @MainActor
    func relinquishActive(completion: (() -> Void)?) {
        relinquishActiveCompletionCallsCount += 1
        relinquishActiveCompletionReceivedCompletion = completion
        relinquishActiveCompletionReceivedInvocations.append(completion)
        relinquishActiveCompletionClosure?(completion)
    }

}
class UserDefaultsListenerProtocolMock: UserDefaultsListenerProtocol {



    //MARK: - start

    var startCallsCount = 0
    var startCalled: Bool {
        return startCallsCount > 0
    }
    var startClosure: (() -> Void)?

    func start() {
        startCallsCount += 1
        startClosure?()
    }

}
class UserDefaultsServiceProtocolMock: UserDefaultsServiceProtocol {



    //MARK: - getSearchPreferences

    var getSearchPreferencesThrowableError: Error?
    var getSearchPreferencesCallsCount = 0
    var getSearchPreferencesCalled: Bool {
        return getSearchPreferencesCallsCount > 0
    }
    var getSearchPreferencesReturnValue: StoredSearchPreferences!
    var getSearchPreferencesClosure: (() throws -> StoredSearchPreferences)?

    func getSearchPreferences() throws -> StoredSearchPreferences {
        getSearchPreferencesCallsCount += 1
        if let error = getSearchPreferencesThrowableError {
            throw error
        }
        if let getSearchPreferencesClosure = getSearchPreferencesClosure {
            return try getSearchPreferencesClosure()
        } else {
            return getSearchPreferencesReturnValue
        }
    }

    //MARK: - setSearchPreferences

    var setSearchPreferencesThrowableError: Error?
    var setSearchPreferencesCallsCount = 0
    var setSearchPreferencesCalled: Bool {
        return setSearchPreferencesCallsCount > 0
    }
    var setSearchPreferencesReceivedSearchPreferences: StoredSearchPreferences?
    var setSearchPreferencesReceivedInvocations: [StoredSearchPreferences] = []
    var setSearchPreferencesClosure: ((StoredSearchPreferences) throws -> Void)?

    func setSearchPreferences(_ searchPreferences: StoredSearchPreferences) throws {
        setSearchPreferencesCallsCount += 1
        if let error = setSearchPreferencesThrowableError {
            throw error
        }
        setSearchPreferencesReceivedSearchPreferences = searchPreferences
        setSearchPreferencesReceivedInvocations.append(searchPreferences)
        try setSearchPreferencesClosure?(searchPreferences)
    }

}
