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

    var buildTitlePropsCopyContentCallsCount = 0
    var buildTitlePropsCopyContentCalled: Bool {
        return buildTitlePropsCopyContentCallsCount > 0
    }
    var buildTitlePropsCopyContentReceivedCopyContent: DisplayNameCopyContent?
    var buildTitlePropsCopyContentReceivedInvocations: [DisplayNameCopyContent] = []
    var buildTitlePropsCopyContentReturnValue: NavigationBarTitleViewProps!
    var buildTitlePropsCopyContentClosure: ((DisplayNameCopyContent) -> NavigationBarTitleViewProps)?

    func buildTitleProps(copyContent: DisplayNameCopyContent) -> NavigationBarTitleViewProps {
        buildTitlePropsCopyContentCallsCount += 1
        buildTitlePropsCopyContentReceivedCopyContent = copyContent
        buildTitlePropsCopyContentReceivedInvocations.append(copyContent)
        if let buildTitlePropsCopyContentClosure = buildTitlePropsCopyContentClosure {
            return buildTitlePropsCopyContentClosure(copyContent)
        } else {
            return buildTitlePropsCopyContentReturnValue
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

    var buildPropsKeywordsAppCopyContentColoringsCallsCount = 0
    var buildPropsKeywordsAppCopyContentColoringsCalled: Bool {
        return buildPropsKeywordsAppCopyContentColoringsCallsCount > 0
    }
    var buildPropsKeywordsAppCopyContentColoringsReceivedArguments: (keywords: NonEmptyString?, appCopyContent: AppCopyContent, colorings: AppStandardColorings)?
    var buildPropsKeywordsAppCopyContentColoringsReceivedInvocations: [(keywords: NonEmptyString?, appCopyContent: AppCopyContent, colorings: AppStandardColorings)] = []
    var buildPropsKeywordsAppCopyContentColoringsReturnValue: SearchBackgroundViewProps!
    var buildPropsKeywordsAppCopyContentColoringsClosure: ((NonEmptyString?, AppCopyContent, AppStandardColorings) -> SearchBackgroundViewProps)?

    func buildProps(keywords: NonEmptyString?, appCopyContent: AppCopyContent, colorings: AppStandardColorings) -> SearchBackgroundViewProps {
        buildPropsKeywordsAppCopyContentColoringsCallsCount += 1
        buildPropsKeywordsAppCopyContentColoringsReceivedArguments = (keywords: keywords, appCopyContent: appCopyContent, colorings: colorings)
        buildPropsKeywordsAppCopyContentColoringsReceivedInvocations.append((keywords: keywords, appCopyContent: appCopyContent, colorings: colorings))
        if let buildPropsKeywordsAppCopyContentColoringsClosure = buildPropsKeywordsAppCopyContentColoringsClosure {
            return buildPropsKeywordsAppCopyContentColoringsClosure(keywords, appCopyContent, colorings)
        } else {
            return buildPropsKeywordsAppCopyContentColoringsReturnValue
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
    var formatCallablePhoneNumberDisplayPhoneReceivedArguments: (resultsCopyContent: SearchResultsCopyContent, displayPhone: NonEmptyString)?
    var formatCallablePhoneNumberDisplayPhoneReceivedInvocations: [(resultsCopyContent: SearchResultsCopyContent, displayPhone: NonEmptyString)] = []
    var formatCallablePhoneNumberDisplayPhoneReturnValue: String!
    var formatCallablePhoneNumberDisplayPhoneClosure: ((SearchResultsCopyContent, NonEmptyString) -> String)?

    func formatCallablePhoneNumber(_ resultsCopyContent: SearchResultsCopyContent, displayPhone: NonEmptyString) -> String {
        formatCallablePhoneNumberDisplayPhoneCallsCount += 1
        formatCallablePhoneNumberDisplayPhoneReceivedArguments = (resultsCopyContent: resultsCopyContent, displayPhone: displayPhone)
        formatCallablePhoneNumberDisplayPhoneReceivedInvocations.append((resultsCopyContent: resultsCopyContent, displayPhone: displayPhone))
        if let formatCallablePhoneNumberDisplayPhoneClosure = formatCallablePhoneNumberDisplayPhoneClosure {
            return formatCallablePhoneNumberDisplayPhoneClosure(resultsCopyContent, displayPhone)
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
    var formatRatingsNumRatingsReceivedArguments: (resultsCopyContent: SearchResultsCopyContent, numRatings: Int)?
    var formatRatingsNumRatingsReceivedInvocations: [(resultsCopyContent: SearchResultsCopyContent, numRatings: Int)] = []
    var formatRatingsNumRatingsReturnValue: String!
    var formatRatingsNumRatingsClosure: ((SearchResultsCopyContent, Int) -> String)?

    func formatRatings(_ resultsCopyContent: SearchResultsCopyContent, numRatings: Int) -> String {
        formatRatingsNumRatingsCallsCount += 1
        formatRatingsNumRatingsReceivedArguments = (resultsCopyContent: resultsCopyContent, numRatings: numRatings)
        formatRatingsNumRatingsReceivedInvocations.append((resultsCopyContent: resultsCopyContent, numRatings: numRatings))
        if let formatRatingsNumRatingsClosure = formatRatingsNumRatingsClosure {
            return formatRatingsNumRatingsClosure(resultsCopyContent, numRatings)
        } else {
            return formatRatingsNumRatingsReturnValue
        }
    }

    //MARK: - formatPricing

    var formatPricingPricingCallsCount = 0
    var formatPricingPricingCalled: Bool {
        return formatPricingPricingCallsCount > 0
    }
    var formatPricingPricingReceivedArguments: (resultsCopyContent: SearchResultsCopyContent, pricing: PlaceLookupPricing)?
    var formatPricingPricingReceivedInvocations: [(resultsCopyContent: SearchResultsCopyContent, pricing: PlaceLookupPricing)] = []
    var formatPricingPricingReturnValue: String!
    var formatPricingPricingClosure: ((SearchResultsCopyContent, PlaceLookupPricing) -> String)?

    func formatPricing(_ resultsCopyContent: SearchResultsCopyContent, pricing: PlaceLookupPricing) -> String {
        formatPricingPricingCallsCount += 1
        formatPricingPricingReceivedArguments = (resultsCopyContent: resultsCopyContent, pricing: pricing)
        formatPricingPricingReceivedInvocations.append((resultsCopyContent: resultsCopyContent, pricing: pricing))
        if let formatPricingPricingClosure = formatPricingPricingClosure {
            return formatPricingPricingClosure(resultsCopyContent, pricing)
        } else {
            return formatPricingPricingReturnValue
        }
    }

}
class SearchDetailsPropsBuilderProtocolMock: SearchDetailsPropsBuilderProtocol {



    //MARK: - buildProps

    var buildPropsResultsCopyContentColoringsCallsCount = 0
    var buildPropsResultsCopyContentColoringsCalled: Bool {
        return buildPropsResultsCopyContentColoringsCallsCount > 0
    }
    var buildPropsResultsCopyContentColoringsReceivedArguments: (entity: SearchEntityModel, resultsCopyContent: SearchResultsCopyContent, colorings: SearchDetailsViewColorings)?
    var buildPropsResultsCopyContentColoringsReceivedInvocations: [(entity: SearchEntityModel, resultsCopyContent: SearchResultsCopyContent, colorings: SearchDetailsViewColorings)] = []
    var buildPropsResultsCopyContentColoringsReturnValue: SearchDetailsProps!
    var buildPropsResultsCopyContentColoringsClosure: ((SearchEntityModel, SearchResultsCopyContent, SearchDetailsViewColorings) -> SearchDetailsProps)?

    func buildProps(_ entity: SearchEntityModel, resultsCopyContent: SearchResultsCopyContent, colorings: SearchDetailsViewColorings) -> SearchDetailsProps {
        buildPropsResultsCopyContentColoringsCallsCount += 1
        buildPropsResultsCopyContentColoringsReceivedArguments = (entity: entity, resultsCopyContent: resultsCopyContent, colorings: colorings)
        buildPropsResultsCopyContentColoringsReceivedInvocations.append((entity: entity, resultsCopyContent: resultsCopyContent, colorings: colorings))
        if let buildPropsResultsCopyContentColoringsClosure = buildPropsResultsCopyContentColoringsClosure {
            return buildPropsResultsCopyContentColoringsClosure(entity, resultsCopyContent, colorings)
        } else {
            return buildPropsResultsCopyContentColoringsReturnValue
        }
    }

}
class SearchDetailsViewContextBuilderProtocolMock: SearchDetailsViewContextBuilderProtocol {



    //MARK: - buildViewContext

    var buildViewContextAppCopyContentColoringsCallsCount = 0
    var buildViewContextAppCopyContentColoringsCalled: Bool {
        return buildViewContextAppCopyContentColoringsCallsCount > 0
    }
    var buildViewContextAppCopyContentColoringsReceivedArguments: (searchActivityState: Search.ActivityState, appCopyContent: AppCopyContent, colorings: SearchDetailsViewColorings)?
    var buildViewContextAppCopyContentColoringsReceivedInvocations: [(searchActivityState: Search.ActivityState, appCopyContent: AppCopyContent, colorings: SearchDetailsViewColorings)] = []
    var buildViewContextAppCopyContentColoringsReturnValue: SearchDetailsViewContext?
    var buildViewContextAppCopyContentColoringsClosure: ((Search.ActivityState, AppCopyContent, SearchDetailsViewColorings) -> SearchDetailsViewContext?)?

    func buildViewContext(_ searchActivityState: Search.ActivityState, appCopyContent: AppCopyContent, colorings: SearchDetailsViewColorings) -> SearchDetailsViewContext? {
        buildViewContextAppCopyContentColoringsCallsCount += 1
        buildViewContextAppCopyContentColoringsReceivedArguments = (searchActivityState: searchActivityState, appCopyContent: appCopyContent, colorings: colorings)
        buildViewContextAppCopyContentColoringsReceivedInvocations.append((searchActivityState: searchActivityState, appCopyContent: appCopyContent, colorings: colorings))
        if let buildViewContextAppCopyContentColoringsClosure = buildViewContextAppCopyContentColoringsClosure {
            return buildViewContextAppCopyContentColoringsClosure(searchActivityState, appCopyContent, colorings)
        } else {
            return buildViewContextAppCopyContentColoringsReturnValue
        }
    }

}
class SearchInputContentPropsBuilderProtocolMock: SearchInputContentPropsBuilderProtocol {



    //MARK: - buildProps

    var buildPropsKeywordsBarStateCopyContentCallsCount = 0
    var buildPropsKeywordsBarStateCopyContentCalled: Bool {
        return buildPropsKeywordsBarStateCopyContentCallsCount > 0
    }
    var buildPropsKeywordsBarStateCopyContentReceivedArguments: (keywords: NonEmptyString?, barState: SearchInputParams.BarState, copyContent: SearchInputCopyContent)?
    var buildPropsKeywordsBarStateCopyContentReceivedInvocations: [(keywords: NonEmptyString?, barState: SearchInputParams.BarState, copyContent: SearchInputCopyContent)] = []
    var buildPropsKeywordsBarStateCopyContentReturnValue: SearchInputContentProps!
    var buildPropsKeywordsBarStateCopyContentClosure: ((NonEmptyString?, SearchInputParams.BarState, SearchInputCopyContent) -> SearchInputContentProps)?

    func buildProps(keywords: NonEmptyString?, barState: SearchInputParams.BarState, copyContent: SearchInputCopyContent) -> SearchInputContentProps {
        buildPropsKeywordsBarStateCopyContentCallsCount += 1
        buildPropsKeywordsBarStateCopyContentReceivedArguments = (keywords: keywords, barState: barState, copyContent: copyContent)
        buildPropsKeywordsBarStateCopyContentReceivedInvocations.append((keywords: keywords, barState: barState, copyContent: copyContent))
        if let buildPropsKeywordsBarStateCopyContentClosure = buildPropsKeywordsBarStateCopyContentClosure {
            return buildPropsKeywordsBarStateCopyContentClosure(keywords, barState, copyContent)
        } else {
            return buildPropsKeywordsBarStateCopyContentReturnValue
        }
    }

}
class SearchInputPropsBuilderProtocolMock: SearchInputPropsBuilderProtocol {



    //MARK: - buildProps

    var buildPropsInputParamsCopyContentCallsCount = 0
    var buildPropsInputParamsCopyContentCalled: Bool {
        return buildPropsInputParamsCopyContentCallsCount > 0
    }
    var buildPropsInputParamsCopyContentReceivedArguments: (inputParams: SearchInputParams, copyContent: SearchInputCopyContent)?
    var buildPropsInputParamsCopyContentReceivedInvocations: [(inputParams: SearchInputParams, copyContent: SearchInputCopyContent)] = []
    var buildPropsInputParamsCopyContentReturnValue: SearchInputProps!
    var buildPropsInputParamsCopyContentClosure: ((SearchInputParams, SearchInputCopyContent) -> SearchInputProps)?

    func buildProps(inputParams: SearchInputParams, copyContent: SearchInputCopyContent) -> SearchInputProps {
        buildPropsInputParamsCopyContentCallsCount += 1
        buildPropsInputParamsCopyContentReceivedArguments = (inputParams: inputParams, copyContent: copyContent)
        buildPropsInputParamsCopyContentReceivedInvocations.append((inputParams: inputParams, copyContent: copyContent))
        if let buildPropsInputParamsCopyContentClosure = buildPropsInputParamsCopyContentClosure {
            return buildPropsInputParamsCopyContentClosure(inputParams, copyContent)
        } else {
            return buildPropsInputParamsCopyContentReturnValue
        }
    }

}
class SearchInstructionsPropsBuilderProtocolMock: SearchInstructionsPropsBuilderProtocol {



    //MARK: - buildProps

    var buildPropsCopyContentColoringsCallsCount = 0
    var buildPropsCopyContentColoringsCalled: Bool {
        return buildPropsCopyContentColoringsCallsCount > 0
    }
    var buildPropsCopyContentColoringsReceivedArguments: (copyContent: SearchInstructionsCopyContent, colorings: AppStandardColorings)?
    var buildPropsCopyContentColoringsReceivedInvocations: [(copyContent: SearchInstructionsCopyContent, colorings: AppStandardColorings)] = []
    var buildPropsCopyContentColoringsReturnValue: SearchInstructionsProps!
    var buildPropsCopyContentColoringsClosure: ((SearchInstructionsCopyContent, AppStandardColorings) -> SearchInstructionsProps)?

    func buildProps(copyContent: SearchInstructionsCopyContent, colorings: AppStandardColorings) -> SearchInstructionsProps {
        buildPropsCopyContentColoringsCallsCount += 1
        buildPropsCopyContentColoringsReceivedArguments = (copyContent: copyContent, colorings: colorings)
        buildPropsCopyContentColoringsReceivedInvocations.append((copyContent: copyContent, colorings: colorings))
        if let buildPropsCopyContentColoringsClosure = buildPropsCopyContentColoringsClosure {
            return buildPropsCopyContentColoringsClosure(copyContent, colorings)
        } else {
            return buildPropsCopyContentColoringsReturnValue
        }
    }

}
class SearchLookupChildBuilderProtocolMock: SearchLookupChildBuilderProtocol {



    //MARK: - buildChild

    var buildChildLoadStateAppCopyContentAppSkinLocationUpdateRequestBlockCallsCount = 0
    var buildChildLoadStateAppCopyContentAppSkinLocationUpdateRequestBlockCalled: Bool {
        return buildChildLoadStateAppCopyContentAppSkinLocationUpdateRequestBlockCallsCount > 0
    }
    var buildChildLoadStateAppCopyContentAppSkinLocationUpdateRequestBlockReceivedArguments: (loadState: Search.LoadState, appCopyContent: AppCopyContent, appSkin: AppSkin, locationUpdateRequestBlock: LocationUpdateRequestBlock)?
    var buildChildLoadStateAppCopyContentAppSkinLocationUpdateRequestBlockReceivedInvocations: [(loadState: Search.LoadState, appCopyContent: AppCopyContent, appSkin: AppSkin, locationUpdateRequestBlock: LocationUpdateRequestBlock)] = []
    var buildChildLoadStateAppCopyContentAppSkinLocationUpdateRequestBlockReturnValue: SearchLookupChild!
    var buildChildLoadStateAppCopyContentAppSkinLocationUpdateRequestBlockClosure: ((Search.LoadState, AppCopyContent, AppSkin, @escaping LocationUpdateRequestBlock) -> SearchLookupChild)?

    func buildChild(loadState: Search.LoadState, appCopyContent: AppCopyContent, appSkin: AppSkin, locationUpdateRequestBlock: @escaping LocationUpdateRequestBlock) -> SearchLookupChild {
        buildChildLoadStateAppCopyContentAppSkinLocationUpdateRequestBlockCallsCount += 1
        buildChildLoadStateAppCopyContentAppSkinLocationUpdateRequestBlockReceivedArguments = (loadState: loadState, appCopyContent: appCopyContent, appSkin: appSkin, locationUpdateRequestBlock: locationUpdateRequestBlock)
        buildChildLoadStateAppCopyContentAppSkinLocationUpdateRequestBlockReceivedInvocations.append((loadState: loadState, appCopyContent: appCopyContent, appSkin: appSkin, locationUpdateRequestBlock: locationUpdateRequestBlock))
        if let buildChildLoadStateAppCopyContentAppSkinLocationUpdateRequestBlockClosure = buildChildLoadStateAppCopyContentAppSkinLocationUpdateRequestBlockClosure {
            return buildChildLoadStateAppCopyContentAppSkinLocationUpdateRequestBlockClosure(loadState, appCopyContent, appSkin, locationUpdateRequestBlock)
        } else {
            return buildChildLoadStateAppCopyContentAppSkinLocationUpdateRequestBlockReturnValue
        }
    }

}
class SearchLookupPropsBuilderProtocolMock: SearchLookupPropsBuilderProtocol {



    //MARK: - buildProps

    var buildPropsSearchActivityStateAppCopyContentAppSkinLocationUpdateRequestBlockCallsCount = 0
    var buildPropsSearchActivityStateAppCopyContentAppSkinLocationUpdateRequestBlockCalled: Bool {
        return buildPropsSearchActivityStateAppCopyContentAppSkinLocationUpdateRequestBlockCallsCount > 0
    }
    var buildPropsSearchActivityStateAppCopyContentAppSkinLocationUpdateRequestBlockReceivedArguments: (searchActivityState: Search.ActivityState, appCopyContent: AppCopyContent, appSkin: AppSkin, locationUpdateRequestBlock: LocationUpdateRequestBlock)?
    var buildPropsSearchActivityStateAppCopyContentAppSkinLocationUpdateRequestBlockReceivedInvocations: [(searchActivityState: Search.ActivityState, appCopyContent: AppCopyContent, appSkin: AppSkin, locationUpdateRequestBlock: LocationUpdateRequestBlock)] = []
    var buildPropsSearchActivityStateAppCopyContentAppSkinLocationUpdateRequestBlockReturnValue: SearchLookupProps!
    var buildPropsSearchActivityStateAppCopyContentAppSkinLocationUpdateRequestBlockClosure: ((Search.ActivityState, AppCopyContent, AppSkin, @escaping LocationUpdateRequestBlock) -> SearchLookupProps)?

    func buildProps(searchActivityState: Search.ActivityState, appCopyContent: AppCopyContent, appSkin: AppSkin, locationUpdateRequestBlock: @escaping LocationUpdateRequestBlock) -> SearchLookupProps {
        buildPropsSearchActivityStateAppCopyContentAppSkinLocationUpdateRequestBlockCallsCount += 1
        buildPropsSearchActivityStateAppCopyContentAppSkinLocationUpdateRequestBlockReceivedArguments = (searchActivityState: searchActivityState, appCopyContent: appCopyContent, appSkin: appSkin, locationUpdateRequestBlock: locationUpdateRequestBlock)
        buildPropsSearchActivityStateAppCopyContentAppSkinLocationUpdateRequestBlockReceivedInvocations.append((searchActivityState: searchActivityState, appCopyContent: appCopyContent, appSkin: appSkin, locationUpdateRequestBlock: locationUpdateRequestBlock))
        if let buildPropsSearchActivityStateAppCopyContentAppSkinLocationUpdateRequestBlockClosure = buildPropsSearchActivityStateAppCopyContentAppSkinLocationUpdateRequestBlockClosure {
            return buildPropsSearchActivityStateAppCopyContentAppSkinLocationUpdateRequestBlockClosure(searchActivityState, appCopyContent, appSkin, locationUpdateRequestBlock)
        } else {
            return buildPropsSearchActivityStateAppCopyContentAppSkinLocationUpdateRequestBlockReturnValue
        }
    }

}
class SearchNoResultsFoundPropsBuilderProtocolMock: SearchNoResultsFoundPropsBuilderProtocol {



    //MARK: - buildProps

    var buildPropsCopyContentColoringsCallsCount = 0
    var buildPropsCopyContentColoringsCalled: Bool {
        return buildPropsCopyContentColoringsCallsCount > 0
    }
    var buildPropsCopyContentColoringsReceivedArguments: (copyContent: SearchNoResultsCopyContent, colorings: AppStandardColorings)?
    var buildPropsCopyContentColoringsReceivedInvocations: [(copyContent: SearchNoResultsCopyContent, colorings: AppStandardColorings)] = []
    var buildPropsCopyContentColoringsReturnValue: SearchNoResultsFoundProps!
    var buildPropsCopyContentColoringsClosure: ((SearchNoResultsCopyContent, AppStandardColorings) -> SearchNoResultsFoundProps)?

    func buildProps(copyContent: SearchNoResultsCopyContent, colorings: AppStandardColorings) -> SearchNoResultsFoundProps {
        buildPropsCopyContentColoringsCallsCount += 1
        buildPropsCopyContentColoringsReceivedArguments = (copyContent: copyContent, colorings: colorings)
        buildPropsCopyContentColoringsReceivedInvocations.append((copyContent: copyContent, colorings: colorings))
        if let buildPropsCopyContentColoringsClosure = buildPropsCopyContentColoringsClosure {
            return buildPropsCopyContentColoringsClosure(copyContent, colorings)
        } else {
            return buildPropsCopyContentColoringsReturnValue
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

    var loadLocationServicesDisabledViewsTitlePropsAppSkinCallsCount = 0
    var loadLocationServicesDisabledViewsTitlePropsAppSkinCalled: Bool {
        return loadLocationServicesDisabledViewsTitlePropsAppSkinCallsCount > 0
    }
    var loadLocationServicesDisabledViewsTitlePropsAppSkinReceivedArguments: (props: SearchLocationDisabledViewProps, titleProps: NavigationBarTitleViewProps, appSkin: AppSkin)?
    var loadLocationServicesDisabledViewsTitlePropsAppSkinReceivedInvocations: [(props: SearchLocationDisabledViewProps, titleProps: NavigationBarTitleViewProps, appSkin: AppSkin)] = []
    var loadLocationServicesDisabledViewsTitlePropsAppSkinClosure: ((SearchLocationDisabledViewProps, NavigationBarTitleViewProps, AppSkin) -> Void)?

    func loadLocationServicesDisabledViews(_ props: SearchLocationDisabledViewProps, titleProps: NavigationBarTitleViewProps, appSkin: AppSkin) {
        loadLocationServicesDisabledViewsTitlePropsAppSkinCallsCount += 1
        loadLocationServicesDisabledViewsTitlePropsAppSkinReceivedArguments = (props: props, titleProps: titleProps, appSkin: appSkin)
        loadLocationServicesDisabledViewsTitlePropsAppSkinReceivedInvocations.append((props: props, titleProps: titleProps, appSkin: appSkin))
        loadLocationServicesDisabledViewsTitlePropsAppSkinClosure?(props, titleProps, appSkin)
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

    var buildPropsModelResultsCopyContentColoringsCallsCount = 0
    var buildPropsModelResultsCopyContentColoringsCalled: Bool {
        return buildPropsModelResultsCopyContentColoringsCallsCount > 0
    }
    var buildPropsModelResultsCopyContentColoringsReceivedArguments: (model: SearchEntityModel, resultsCopyContent: SearchResultsCopyContent, colorings: SearchResultsViewColorings)?
    var buildPropsModelResultsCopyContentColoringsReceivedInvocations: [(model: SearchEntityModel, resultsCopyContent: SearchResultsCopyContent, colorings: SearchResultsViewColorings)] = []
    var buildPropsModelResultsCopyContentColoringsReturnValue: SearchResultCellProps!
    var buildPropsModelResultsCopyContentColoringsClosure: ((SearchEntityModel, SearchResultsCopyContent, SearchResultsViewColorings) -> SearchResultCellProps)?

    func buildProps(model: SearchEntityModel, resultsCopyContent: SearchResultsCopyContent, colorings: SearchResultsViewColorings) -> SearchResultCellProps {
        buildPropsModelResultsCopyContentColoringsCallsCount += 1
        buildPropsModelResultsCopyContentColoringsReceivedArguments = (model: model, resultsCopyContent: resultsCopyContent, colorings: colorings)
        buildPropsModelResultsCopyContentColoringsReceivedInvocations.append((model: model, resultsCopyContent: resultsCopyContent, colorings: colorings))
        if let buildPropsModelResultsCopyContentColoringsClosure = buildPropsModelResultsCopyContentColoringsClosure {
            return buildPropsModelResultsCopyContentColoringsClosure(model, resultsCopyContent, colorings)
        } else {
            return buildPropsModelResultsCopyContentColoringsReturnValue
        }
    }

}
class SearchResultPropsBuilderProtocolMock: SearchResultPropsBuilderProtocol {



    //MARK: - buildProps

    var buildPropsModelResultsCopyContentColoringsCallsCount = 0
    var buildPropsModelResultsCopyContentColoringsCalled: Bool {
        return buildPropsModelResultsCopyContentColoringsCallsCount > 0
    }
    var buildPropsModelResultsCopyContentColoringsReceivedArguments: (model: SearchEntityModel, resultsCopyContent: SearchResultsCopyContent, colorings: SearchResultsViewColorings)?
    var buildPropsModelResultsCopyContentColoringsReceivedInvocations: [(model: SearchEntityModel, resultsCopyContent: SearchResultsCopyContent, colorings: SearchResultsViewColorings)] = []
    var buildPropsModelResultsCopyContentColoringsReturnValue: SearchResultProps!
    var buildPropsModelResultsCopyContentColoringsClosure: ((SearchEntityModel, SearchResultsCopyContent, SearchResultsViewColorings) -> SearchResultProps)?

    func buildProps(model: SearchEntityModel, resultsCopyContent: SearchResultsCopyContent, colorings: SearchResultsViewColorings) -> SearchResultProps {
        buildPropsModelResultsCopyContentColoringsCallsCount += 1
        buildPropsModelResultsCopyContentColoringsReceivedArguments = (model: model, resultsCopyContent: resultsCopyContent, colorings: colorings)
        buildPropsModelResultsCopyContentColoringsReceivedInvocations.append((model: model, resultsCopyContent: resultsCopyContent, colorings: colorings))
        if let buildPropsModelResultsCopyContentColoringsClosure = buildPropsModelResultsCopyContentColoringsClosure {
            return buildPropsModelResultsCopyContentColoringsClosure(model, resultsCopyContent, colorings)
        } else {
            return buildPropsModelResultsCopyContentColoringsReturnValue
        }
    }

}
class SearchResultsViewPropsBuilderProtocolMock: SearchResultsViewPropsBuilderProtocol {



    //MARK: - buildProps

    var buildPropsSubmittedParamsAllEntitiesColoringsNumPagesReceivedTokenContainerResultsCopyContentLocationUpdateRequestBlockCallsCount = 0
    var buildPropsSubmittedParamsAllEntitiesColoringsNumPagesReceivedTokenContainerResultsCopyContentLocationUpdateRequestBlockCalled: Bool {
        return buildPropsSubmittedParamsAllEntitiesColoringsNumPagesReceivedTokenContainerResultsCopyContentLocationUpdateRequestBlockCallsCount > 0
    }
    var buildPropsSubmittedParamsAllEntitiesColoringsNumPagesReceivedTokenContainerResultsCopyContentLocationUpdateRequestBlockReceivedArguments: (submittedParams: SearchParams, allEntities: NonEmptyArray<SearchEntityModel>, colorings: SearchResultsViewColorings, numPagesReceived: Int, tokenContainer: PlaceLookupTokenAttemptsContainer?, resultsCopyContent: SearchResultsCopyContent, locationUpdateRequestBlock: LocationUpdateRequestBlock)?
    var buildPropsSubmittedParamsAllEntitiesColoringsNumPagesReceivedTokenContainerResultsCopyContentLocationUpdateRequestBlockReceivedInvocations: [(submittedParams: SearchParams, allEntities: NonEmptyArray<SearchEntityModel>, colorings: SearchResultsViewColorings, numPagesReceived: Int, tokenContainer: PlaceLookupTokenAttemptsContainer?, resultsCopyContent: SearchResultsCopyContent, locationUpdateRequestBlock: LocationUpdateRequestBlock)] = []
    var buildPropsSubmittedParamsAllEntitiesColoringsNumPagesReceivedTokenContainerResultsCopyContentLocationUpdateRequestBlockReturnValue: SearchResultsViewProps!
    var buildPropsSubmittedParamsAllEntitiesColoringsNumPagesReceivedTokenContainerResultsCopyContentLocationUpdateRequestBlockClosure: ((SearchParams, NonEmptyArray<SearchEntityModel>, SearchResultsViewColorings, Int, PlaceLookupTokenAttemptsContainer?, SearchResultsCopyContent, @escaping LocationUpdateRequestBlock) -> SearchResultsViewProps)?

    func buildProps(submittedParams: SearchParams, allEntities: NonEmptyArray<SearchEntityModel>, colorings: SearchResultsViewColorings, numPagesReceived: Int, tokenContainer: PlaceLookupTokenAttemptsContainer?, resultsCopyContent: SearchResultsCopyContent, locationUpdateRequestBlock: @escaping LocationUpdateRequestBlock) -> SearchResultsViewProps {
        buildPropsSubmittedParamsAllEntitiesColoringsNumPagesReceivedTokenContainerResultsCopyContentLocationUpdateRequestBlockCallsCount += 1
        buildPropsSubmittedParamsAllEntitiesColoringsNumPagesReceivedTokenContainerResultsCopyContentLocationUpdateRequestBlockReceivedArguments = (submittedParams: submittedParams, allEntities: allEntities, colorings: colorings, numPagesReceived: numPagesReceived, tokenContainer: tokenContainer, resultsCopyContent: resultsCopyContent, locationUpdateRequestBlock: locationUpdateRequestBlock)
        buildPropsSubmittedParamsAllEntitiesColoringsNumPagesReceivedTokenContainerResultsCopyContentLocationUpdateRequestBlockReceivedInvocations.append((submittedParams: submittedParams, allEntities: allEntities, colorings: colorings, numPagesReceived: numPagesReceived, tokenContainer: tokenContainer, resultsCopyContent: resultsCopyContent, locationUpdateRequestBlock: locationUpdateRequestBlock))
        if let buildPropsSubmittedParamsAllEntitiesColoringsNumPagesReceivedTokenContainerResultsCopyContentLocationUpdateRequestBlockClosure = buildPropsSubmittedParamsAllEntitiesColoringsNumPagesReceivedTokenContainerResultsCopyContentLocationUpdateRequestBlockClosure {
            return buildPropsSubmittedParamsAllEntitiesColoringsNumPagesReceivedTokenContainerResultsCopyContentLocationUpdateRequestBlockClosure(submittedParams, allEntities, colorings, numPagesReceived, tokenContainer, resultsCopyContent, locationUpdateRequestBlock)
        } else {
            return buildPropsSubmittedParamsAllEntitiesColoringsNumPagesReceivedTokenContainerResultsCopyContentLocationUpdateRequestBlockReturnValue
        }
    }

}
class SearchRetryPropsBuilderProtocolMock: SearchRetryPropsBuilderProtocol {



    //MARK: - buildProps

    var buildPropsCopyContentColoringsCtaBlockCallsCount = 0
    var buildPropsCopyContentColoringsCtaBlockCalled: Bool {
        return buildPropsCopyContentColoringsCtaBlockCallsCount > 0
    }
    var buildPropsCopyContentColoringsCtaBlockReceivedArguments: (copyContent: SearchRetryCopyContent, colorings: SearchCTAViewColorings, ctaBlock: SearchCTABlock)?
    var buildPropsCopyContentColoringsCtaBlockReceivedInvocations: [(copyContent: SearchRetryCopyContent, colorings: SearchCTAViewColorings, ctaBlock: SearchCTABlock)] = []
    var buildPropsCopyContentColoringsCtaBlockReturnValue: SearchRetryProps!
    var buildPropsCopyContentColoringsCtaBlockClosure: ((SearchRetryCopyContent, SearchCTAViewColorings, @escaping SearchCTABlock) -> SearchRetryProps)?

    func buildProps(copyContent: SearchRetryCopyContent, colorings: SearchCTAViewColorings, ctaBlock: @escaping SearchCTABlock) -> SearchRetryProps {
        buildPropsCopyContentColoringsCtaBlockCallsCount += 1
        buildPropsCopyContentColoringsCtaBlockReceivedArguments = (copyContent: copyContent, colorings: colorings, ctaBlock: ctaBlock)
        buildPropsCopyContentColoringsCtaBlockReceivedInvocations.append((copyContent: copyContent, colorings: colorings, ctaBlock: ctaBlock))
        if let buildPropsCopyContentColoringsCtaBlockClosure = buildPropsCopyContentColoringsCtaBlockClosure {
            return buildPropsCopyContentColoringsCtaBlockClosure(copyContent, colorings, ctaBlock)
        } else {
            return buildPropsCopyContentColoringsCtaBlockReturnValue
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

    var buildSortingCellPropsCurrentSortingCopyContentColoringsCallsCount = 0
    var buildSortingCellPropsCurrentSortingCopyContentColoringsCalled: Bool {
        return buildSortingCellPropsCurrentSortingCopyContentColoringsCallsCount > 0
    }
    var buildSortingCellPropsCurrentSortingCopyContentColoringsReceivedArguments: (currentSorting: PlaceLookupSorting, copyContent: SettingsSortPreferenceCopyContent, colorings: SettingsCellColorings)?
    var buildSortingCellPropsCurrentSortingCopyContentColoringsReceivedInvocations: [(currentSorting: PlaceLookupSorting, copyContent: SettingsSortPreferenceCopyContent, colorings: SettingsCellColorings)] = []
    var buildSortingCellPropsCurrentSortingCopyContentColoringsReturnValue: [SettingsCellProps]!
    var buildSortingCellPropsCurrentSortingCopyContentColoringsClosure: ((PlaceLookupSorting, SettingsSortPreferenceCopyContent, SettingsCellColorings) -> [SettingsCellProps])?

    func buildSortingCellProps(currentSorting: PlaceLookupSorting, copyContent: SettingsSortPreferenceCopyContent, colorings: SettingsCellColorings) -> [SettingsCellProps] {
        buildSortingCellPropsCurrentSortingCopyContentColoringsCallsCount += 1
        buildSortingCellPropsCurrentSortingCopyContentColoringsReceivedArguments = (currentSorting: currentSorting, copyContent: copyContent, colorings: colorings)
        buildSortingCellPropsCurrentSortingCopyContentColoringsReceivedInvocations.append((currentSorting: currentSorting, copyContent: copyContent, colorings: colorings))
        if let buildSortingCellPropsCurrentSortingCopyContentColoringsClosure = buildSortingCellPropsCurrentSortingCopyContentColoringsClosure {
            return buildSortingCellPropsCurrentSortingCopyContentColoringsClosure(currentSorting, copyContent, colorings)
        } else {
            return buildSortingCellPropsCurrentSortingCopyContentColoringsReturnValue
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

    var buildPropsTitleCurrentlyActiveSystemCopyContentColoringsCallsCount = 0
    var buildPropsTitleCurrentlyActiveSystemCopyContentColoringsCalled: Bool {
        return buildPropsTitleCurrentlyActiveSystemCopyContentColoringsCallsCount > 0
    }
    var buildPropsTitleCurrentlyActiveSystemCopyContentColoringsReceivedArguments: (title: String, currentlyActiveSystem: MeasurementSystem, copyContent: SettingsMeasurementSystemCopyContent, colorings: SettingsHeaderViewColorings)?
    var buildPropsTitleCurrentlyActiveSystemCopyContentColoringsReceivedInvocations: [(title: String, currentlyActiveSystem: MeasurementSystem, copyContent: SettingsMeasurementSystemCopyContent, colorings: SettingsHeaderViewColorings)] = []
    var buildPropsTitleCurrentlyActiveSystemCopyContentColoringsReturnValue: SettingsUnitsHeaderProps!
    var buildPropsTitleCurrentlyActiveSystemCopyContentColoringsClosure: ((String, MeasurementSystem, SettingsMeasurementSystemCopyContent, SettingsHeaderViewColorings) -> SettingsUnitsHeaderProps)?

    func buildProps(title: String, currentlyActiveSystem: MeasurementSystem, copyContent: SettingsMeasurementSystemCopyContent, colorings: SettingsHeaderViewColorings) -> SettingsUnitsHeaderProps {
        buildPropsTitleCurrentlyActiveSystemCopyContentColoringsCallsCount += 1
        buildPropsTitleCurrentlyActiveSystemCopyContentColoringsReceivedArguments = (title: title, currentlyActiveSystem: currentlyActiveSystem, copyContent: copyContent, colorings: colorings)
        buildPropsTitleCurrentlyActiveSystemCopyContentColoringsReceivedInvocations.append((title: title, currentlyActiveSystem: currentlyActiveSystem, copyContent: copyContent, colorings: colorings))
        if let buildPropsTitleCurrentlyActiveSystemCopyContentColoringsClosure = buildPropsTitleCurrentlyActiveSystemCopyContentColoringsClosure {
            return buildPropsTitleCurrentlyActiveSystemCopyContentColoringsClosure(title, currentlyActiveSystem, copyContent, colorings)
        } else {
            return buildPropsTitleCurrentlyActiveSystemCopyContentColoringsReturnValue
        }
    }

}
class SettingsViewPropsBuilderProtocolMock: SettingsViewPropsBuilderProtocol {



    //MARK: - buildProps

    var buildPropsSearchPreferencesStateAppCopyContentAppDisplayNameColoringsCallsCount = 0
    var buildPropsSearchPreferencesStateAppCopyContentAppDisplayNameColoringsCalled: Bool {
        return buildPropsSearchPreferencesStateAppCopyContentAppDisplayNameColoringsCallsCount > 0
    }
    var buildPropsSearchPreferencesStateAppCopyContentAppDisplayNameColoringsReceivedArguments: (searchPreferencesState: SearchPreferencesState, appCopyContent: AppCopyContent, appDisplayName: NonEmptyString, colorings: SettingsViewColorings)?
    var buildPropsSearchPreferencesStateAppCopyContentAppDisplayNameColoringsReceivedInvocations: [(searchPreferencesState: SearchPreferencesState, appCopyContent: AppCopyContent, appDisplayName: NonEmptyString, colorings: SettingsViewColorings)] = []
    var buildPropsSearchPreferencesStateAppCopyContentAppDisplayNameColoringsReturnValue: SettingsViewProps!
    var buildPropsSearchPreferencesStateAppCopyContentAppDisplayNameColoringsClosure: ((SearchPreferencesState, AppCopyContent, NonEmptyString, SettingsViewColorings) -> SettingsViewProps)?

    func buildProps(searchPreferencesState: SearchPreferencesState, appCopyContent: AppCopyContent, appDisplayName: NonEmptyString, colorings: SettingsViewColorings) -> SettingsViewProps {
        buildPropsSearchPreferencesStateAppCopyContentAppDisplayNameColoringsCallsCount += 1
        buildPropsSearchPreferencesStateAppCopyContentAppDisplayNameColoringsReceivedArguments = (searchPreferencesState: searchPreferencesState, appCopyContent: appCopyContent, appDisplayName: appDisplayName, colorings: colorings)
        buildPropsSearchPreferencesStateAppCopyContentAppDisplayNameColoringsReceivedInvocations.append((searchPreferencesState: searchPreferencesState, appCopyContent: appCopyContent, appDisplayName: appDisplayName, colorings: colorings))
        if let buildPropsSearchPreferencesStateAppCopyContentAppDisplayNameColoringsClosure = buildPropsSearchPreferencesStateAppCopyContentAppDisplayNameColoringsClosure {
            return buildPropsSearchPreferencesStateAppCopyContentAppDisplayNameColoringsClosure(searchPreferencesState, appCopyContent, appDisplayName, colorings)
        } else {
            return buildPropsSearchPreferencesStateAppCopyContentAppDisplayNameColoringsReturnValue
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
