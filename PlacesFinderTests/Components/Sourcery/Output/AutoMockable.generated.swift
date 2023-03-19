// Generated using Sourcery 2.0.1 — https://github.com/krzysztofzablocki/Sourcery
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

    //MARK: - startSpinner

    var startSpinnerCallsCount = 0
    var startSpinnerCalled: Bool {
        return startSpinnerCallsCount > 0
    }
    var startSpinnerClosure: (() -> Void)?

    func startSpinner() {
        startSpinnerCallsCount += 1
        startSpinnerClosure?()
    }

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
class NavigationBarViewModelBuilderProtocolMock: NavigationBarViewModelBuilderProtocol {



    //MARK: - buildTitleViewModel

    var buildTitleViewModelCopyContentCallsCount = 0
    var buildTitleViewModelCopyContentCalled: Bool {
        return buildTitleViewModelCopyContentCallsCount > 0
    }
    var buildTitleViewModelCopyContentReceivedCopyContent: DisplayNameCopyContent?
    var buildTitleViewModelCopyContentReceivedInvocations: [DisplayNameCopyContent] = []
    var buildTitleViewModelCopyContentReturnValue: NavigationBarTitleViewModel!
    var buildTitleViewModelCopyContentClosure: ((DisplayNameCopyContent) -> NavigationBarTitleViewModel)?

    func buildTitleViewModel(copyContent: DisplayNameCopyContent) -> NavigationBarTitleViewModel {
        buildTitleViewModelCopyContentCallsCount += 1
        buildTitleViewModelCopyContentReceivedCopyContent = copyContent
        buildTitleViewModelCopyContentReceivedInvocations.append(copyContent)
        if let buildTitleViewModelCopyContentClosure = buildTitleViewModelCopyContentClosure {
            return buildTitleViewModelCopyContentClosure(copyContent)
        } else {
            return buildTitleViewModelCopyContentReturnValue
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

    var startThrowableError: Error?
    var startCallsCount = 0
    var startCalled: Bool {
        return startCallsCount > 0
    }
    var startClosure: (() throws -> Void)?

    func start() throws {
        startCallsCount += 1
        if let error = startThrowableError {
            throw error
        }
        try startClosure?()
    }

}
class ReachabilityProtocolMock: ReachabilityProtocol {



    //MARK: - startNotifier

    var startNotifierThrowableError: Error?
    var startNotifierCallsCount = 0
    var startNotifierCalled: Bool {
        return startNotifierCallsCount > 0
    }
    var startNotifierClosure: (() throws -> Void)?

    func startNotifier() throws {
        startNotifierCallsCount += 1
        if let error = startNotifierThrowableError {
            throw error
        }
        try startNotifierClosure?()
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
class SearchBackgroundViewModelBuilderProtocolMock: SearchBackgroundViewModelBuilderProtocol {



    //MARK: - buildViewModel

    var buildViewModelKeywordsAppCopyContentColoringsCallsCount = 0
    var buildViewModelKeywordsAppCopyContentColoringsCalled: Bool {
        return buildViewModelKeywordsAppCopyContentColoringsCallsCount > 0
    }
    var buildViewModelKeywordsAppCopyContentColoringsReceivedArguments: (keywords: NonEmptyString?, appCopyContent: AppCopyContent, colorings: AppStandardColorings)?
    var buildViewModelKeywordsAppCopyContentColoringsReceivedInvocations: [(keywords: NonEmptyString?, appCopyContent: AppCopyContent, colorings: AppStandardColorings)] = []
    var buildViewModelKeywordsAppCopyContentColoringsReturnValue: SearchBackgroundViewModel!
    var buildViewModelKeywordsAppCopyContentColoringsClosure: ((NonEmptyString?, AppCopyContent, AppStandardColorings) -> SearchBackgroundViewModel)?

    func buildViewModel(keywords: NonEmptyString?, appCopyContent: AppCopyContent, colorings: AppStandardColorings) -> SearchBackgroundViewModel {
        buildViewModelKeywordsAppCopyContentColoringsCallsCount += 1
        buildViewModelKeywordsAppCopyContentColoringsReceivedArguments = (keywords: keywords, appCopyContent: appCopyContent, colorings: colorings)
        buildViewModelKeywordsAppCopyContentColoringsReceivedInvocations.append((keywords: keywords, appCopyContent: appCopyContent, colorings: colorings))
        if let buildViewModelKeywordsAppCopyContentColoringsClosure = buildViewModelKeywordsAppCopyContentColoringsClosure {
            return buildViewModelKeywordsAppCopyContentColoringsClosure(keywords, appCopyContent, colorings)
        } else {
            return buildViewModelKeywordsAppCopyContentColoringsReturnValue
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
class SearchDetailsViewContextBuilderProtocolMock: SearchDetailsViewContextBuilderProtocol {



    //MARK: - buildViewContext

    var buildViewContextAppCopyContentCallsCount = 0
    var buildViewContextAppCopyContentCalled: Bool {
        return buildViewContextAppCopyContentCallsCount > 0
    }
    var buildViewContextAppCopyContentReceivedArguments: (searchActivityState: Search.ActivityState, appCopyContent: AppCopyContent)?
    var buildViewContextAppCopyContentReceivedInvocations: [(searchActivityState: Search.ActivityState, appCopyContent: AppCopyContent)] = []
    var buildViewContextAppCopyContentReturnValue: SearchDetailsViewContext?
    var buildViewContextAppCopyContentClosure: ((Search.ActivityState, AppCopyContent) -> SearchDetailsViewContext?)?

    func buildViewContext(_ searchActivityState: Search.ActivityState, appCopyContent: AppCopyContent) -> SearchDetailsViewContext? {
        buildViewContextAppCopyContentCallsCount += 1
        buildViewContextAppCopyContentReceivedArguments = (searchActivityState: searchActivityState, appCopyContent: appCopyContent)
        buildViewContextAppCopyContentReceivedInvocations.append((searchActivityState: searchActivityState, appCopyContent: appCopyContent))
        if let buildViewContextAppCopyContentClosure = buildViewContextAppCopyContentClosure {
            return buildViewContextAppCopyContentClosure(searchActivityState, appCopyContent)
        } else {
            return buildViewContextAppCopyContentReturnValue
        }
    }

}
class SearchDetailsViewModelBuilderProtocolMock: SearchDetailsViewModelBuilderProtocol {



    //MARK: - buildViewModel

    var buildViewModelResultsCopyContentCallsCount = 0
    var buildViewModelResultsCopyContentCalled: Bool {
        return buildViewModelResultsCopyContentCallsCount > 0
    }
    var buildViewModelResultsCopyContentReceivedArguments: (entity: SearchEntityModel, resultsCopyContent: SearchResultsCopyContent)?
    var buildViewModelResultsCopyContentReceivedInvocations: [(entity: SearchEntityModel, resultsCopyContent: SearchResultsCopyContent)] = []
    var buildViewModelResultsCopyContentReturnValue: SearchDetailsViewModel!
    var buildViewModelResultsCopyContentClosure: ((SearchEntityModel, SearchResultsCopyContent) -> SearchDetailsViewModel)?

    func buildViewModel(_ entity: SearchEntityModel, resultsCopyContent: SearchResultsCopyContent) -> SearchDetailsViewModel {
        buildViewModelResultsCopyContentCallsCount += 1
        buildViewModelResultsCopyContentReceivedArguments = (entity: entity, resultsCopyContent: resultsCopyContent)
        buildViewModelResultsCopyContentReceivedInvocations.append((entity: entity, resultsCopyContent: resultsCopyContent))
        if let buildViewModelResultsCopyContentClosure = buildViewModelResultsCopyContentClosure {
            return buildViewModelResultsCopyContentClosure(entity, resultsCopyContent)
        } else {
            return buildViewModelResultsCopyContentReturnValue
        }
    }

}
class SearchEntityModelBuilderProtocolMock: SearchEntityModelBuilderProtocol, @unchecked Sendable {



    //MARK: - buildEntityModels

    var buildEntityModelsCallsCount = 0
    var buildEntityModelsCalled: Bool {
        return buildEntityModelsCallsCount > 0
    }
    var buildEntityModelsReceivedEntities: [PlaceLookupEntity]?
    var buildEntityModelsReceivedInvocations: [[PlaceLookupEntity]] = []
    var buildEntityModelsReturnValue: [SearchEntityModel]!
    var buildEntityModelsClosure: (([PlaceLookupEntity]) -> [SearchEntityModel])?

    func buildEntityModels(_ entities: [PlaceLookupEntity]) -> [SearchEntityModel] {
        buildEntityModelsCallsCount += 1
        buildEntityModelsReceivedEntities = entities
        buildEntityModelsReceivedInvocations.append(entities)
        if let buildEntityModelsClosure = buildEntityModelsClosure {
            return buildEntityModelsClosure(entities)
        } else {
            return buildEntityModelsReturnValue
        }
    }

    //MARK: - buildEntityModel

    var buildEntityModelCallsCount = 0
    var buildEntityModelCalled: Bool {
        return buildEntityModelCallsCount > 0
    }
    var buildEntityModelReceivedEntity: PlaceLookupEntity?
    var buildEntityModelReceivedInvocations: [PlaceLookupEntity] = []
    var buildEntityModelReturnValue: SearchEntityModel?
    var buildEntityModelClosure: ((PlaceLookupEntity) -> SearchEntityModel?)?

    func buildEntityModel(_ entity: PlaceLookupEntity) -> SearchEntityModel? {
        buildEntityModelCallsCount += 1
        buildEntityModelReceivedEntity = entity
        buildEntityModelReceivedInvocations.append(entity)
        if let buildEntityModelClosure = buildEntityModelClosure {
            return buildEntityModelClosure(entity)
        } else {
            return buildEntityModelReturnValue
        }
    }

}
class SearchInputContentViewModelBuilderProtocolMock: SearchInputContentViewModelBuilderProtocol {



    //MARK: - buildViewModel

    var buildViewModelKeywordsBarStateCopyContentCallsCount = 0
    var buildViewModelKeywordsBarStateCopyContentCalled: Bool {
        return buildViewModelKeywordsBarStateCopyContentCallsCount > 0
    }
    var buildViewModelKeywordsBarStateCopyContentReceivedArguments: (keywords: NonEmptyString?, barState: SearchInputParams.BarState, copyContent: SearchInputCopyContent)?
    var buildViewModelKeywordsBarStateCopyContentReceivedInvocations: [(keywords: NonEmptyString?, barState: SearchInputParams.BarState, copyContent: SearchInputCopyContent)] = []
    var buildViewModelKeywordsBarStateCopyContentReturnValue: SearchInputContentViewModel!
    var buildViewModelKeywordsBarStateCopyContentClosure: ((NonEmptyString?, SearchInputParams.BarState, SearchInputCopyContent) -> SearchInputContentViewModel)?

    func buildViewModel(keywords: NonEmptyString?, barState: SearchInputParams.BarState, copyContent: SearchInputCopyContent) -> SearchInputContentViewModel {
        buildViewModelKeywordsBarStateCopyContentCallsCount += 1
        buildViewModelKeywordsBarStateCopyContentReceivedArguments = (keywords: keywords, barState: barState, copyContent: copyContent)
        buildViewModelKeywordsBarStateCopyContentReceivedInvocations.append((keywords: keywords, barState: barState, copyContent: copyContent))
        if let buildViewModelKeywordsBarStateCopyContentClosure = buildViewModelKeywordsBarStateCopyContentClosure {
            return buildViewModelKeywordsBarStateCopyContentClosure(keywords, barState, copyContent)
        } else {
            return buildViewModelKeywordsBarStateCopyContentReturnValue
        }
    }

}
class SearchInputViewModelBuilderProtocolMock: SearchInputViewModelBuilderProtocol {



    //MARK: - buildDispatchingViewModel

    var buildDispatchingViewModelInputParamsCopyContentLocationUpdateRequestBlockCallsCount = 0
    var buildDispatchingViewModelInputParamsCopyContentLocationUpdateRequestBlockCalled: Bool {
        return buildDispatchingViewModelInputParamsCopyContentLocationUpdateRequestBlockCallsCount > 0
    }
    var buildDispatchingViewModelInputParamsCopyContentLocationUpdateRequestBlockReceivedArguments: (inputParams: SearchInputParams, copyContent: SearchInputCopyContent, locationUpdateRequestBlock: LocationUpdateRequestBlock)?
    var buildDispatchingViewModelInputParamsCopyContentLocationUpdateRequestBlockReceivedInvocations: [(inputParams: SearchInputParams, copyContent: SearchInputCopyContent, locationUpdateRequestBlock: LocationUpdateRequestBlock)] = []
    var buildDispatchingViewModelInputParamsCopyContentLocationUpdateRequestBlockReturnValue: SearchInputViewModel!
    var buildDispatchingViewModelInputParamsCopyContentLocationUpdateRequestBlockClosure: ((SearchInputParams, SearchInputCopyContent, @escaping LocationUpdateRequestBlock) -> SearchInputViewModel)?

    func buildDispatchingViewModel(inputParams: SearchInputParams, copyContent: SearchInputCopyContent, locationUpdateRequestBlock: @escaping LocationUpdateRequestBlock) -> SearchInputViewModel {
        buildDispatchingViewModelInputParamsCopyContentLocationUpdateRequestBlockCallsCount += 1
        buildDispatchingViewModelInputParamsCopyContentLocationUpdateRequestBlockReceivedArguments = (inputParams: inputParams, copyContent: copyContent, locationUpdateRequestBlock: locationUpdateRequestBlock)
        buildDispatchingViewModelInputParamsCopyContentLocationUpdateRequestBlockReceivedInvocations.append((inputParams: inputParams, copyContent: copyContent, locationUpdateRequestBlock: locationUpdateRequestBlock))
        if let buildDispatchingViewModelInputParamsCopyContentLocationUpdateRequestBlockClosure = buildDispatchingViewModelInputParamsCopyContentLocationUpdateRequestBlockClosure {
            return buildDispatchingViewModelInputParamsCopyContentLocationUpdateRequestBlockClosure(inputParams, copyContent, locationUpdateRequestBlock)
        } else {
            return buildDispatchingViewModelInputParamsCopyContentLocationUpdateRequestBlockReturnValue
        }
    }

}
class SearchInstructionsViewModelBuilderProtocolMock: SearchInstructionsViewModelBuilderProtocol {



    //MARK: - buildViewModel

    var buildViewModelCopyContentColoringsCallsCount = 0
    var buildViewModelCopyContentColoringsCalled: Bool {
        return buildViewModelCopyContentColoringsCallsCount > 0
    }
    var buildViewModelCopyContentColoringsReceivedArguments: (copyContent: SearchInstructionsCopyContent, colorings: AppStandardColorings)?
    var buildViewModelCopyContentColoringsReceivedInvocations: [(copyContent: SearchInstructionsCopyContent, colorings: AppStandardColorings)] = []
    var buildViewModelCopyContentColoringsReturnValue: SearchInstructionsViewModel!
    var buildViewModelCopyContentColoringsClosure: ((SearchInstructionsCopyContent, AppStandardColorings) -> SearchInstructionsViewModel)?

    func buildViewModel(copyContent: SearchInstructionsCopyContent, colorings: AppStandardColorings) -> SearchInstructionsViewModel {
        buildViewModelCopyContentColoringsCallsCount += 1
        buildViewModelCopyContentColoringsReceivedArguments = (copyContent: copyContent, colorings: colorings)
        buildViewModelCopyContentColoringsReceivedInvocations.append((copyContent: copyContent, colorings: colorings))
        if let buildViewModelCopyContentColoringsClosure = buildViewModelCopyContentColoringsClosure {
            return buildViewModelCopyContentColoringsClosure(copyContent, colorings)
        } else {
            return buildViewModelCopyContentColoringsReturnValue
        }
    }

}
class SearchLookupChildBuilderProtocolMock: SearchLookupChildBuilderProtocol {



    //MARK: - buildChild

    var buildChildLoadStateAppCopyContentStandardColoringsSearchCTAColoringsLocationUpdateRequestBlockCallsCount = 0
    var buildChildLoadStateAppCopyContentStandardColoringsSearchCTAColoringsLocationUpdateRequestBlockCalled: Bool {
        return buildChildLoadStateAppCopyContentStandardColoringsSearchCTAColoringsLocationUpdateRequestBlockCallsCount > 0
    }
    var buildChildLoadStateAppCopyContentStandardColoringsSearchCTAColoringsLocationUpdateRequestBlockReceivedArguments: (loadState: Search.LoadState, appCopyContent: AppCopyContent, standardColorings: AppStandardColorings, searchCTAColorings: SearchCTAViewColorings, locationUpdateRequestBlock: LocationUpdateRequestBlock)?
    var buildChildLoadStateAppCopyContentStandardColoringsSearchCTAColoringsLocationUpdateRequestBlockReceivedInvocations: [(loadState: Search.LoadState, appCopyContent: AppCopyContent, standardColorings: AppStandardColorings, searchCTAColorings: SearchCTAViewColorings, locationUpdateRequestBlock: LocationUpdateRequestBlock)] = []
    var buildChildLoadStateAppCopyContentStandardColoringsSearchCTAColoringsLocationUpdateRequestBlockReturnValue: SearchLookupChild!
    var buildChildLoadStateAppCopyContentStandardColoringsSearchCTAColoringsLocationUpdateRequestBlockClosure: ((Search.LoadState, AppCopyContent, AppStandardColorings, SearchCTAViewColorings, @escaping LocationUpdateRequestBlock) -> SearchLookupChild)?

    func buildChild(loadState: Search.LoadState, appCopyContent: AppCopyContent, standardColorings: AppStandardColorings, searchCTAColorings: SearchCTAViewColorings, locationUpdateRequestBlock: @escaping LocationUpdateRequestBlock) -> SearchLookupChild {
        buildChildLoadStateAppCopyContentStandardColoringsSearchCTAColoringsLocationUpdateRequestBlockCallsCount += 1
        buildChildLoadStateAppCopyContentStandardColoringsSearchCTAColoringsLocationUpdateRequestBlockReceivedArguments = (loadState: loadState, appCopyContent: appCopyContent, standardColorings: standardColorings, searchCTAColorings: searchCTAColorings, locationUpdateRequestBlock: locationUpdateRequestBlock)
        buildChildLoadStateAppCopyContentStandardColoringsSearchCTAColoringsLocationUpdateRequestBlockReceivedInvocations.append((loadState: loadState, appCopyContent: appCopyContent, standardColorings: standardColorings, searchCTAColorings: searchCTAColorings, locationUpdateRequestBlock: locationUpdateRequestBlock))
        if let buildChildLoadStateAppCopyContentStandardColoringsSearchCTAColoringsLocationUpdateRequestBlockClosure = buildChildLoadStateAppCopyContentStandardColoringsSearchCTAColoringsLocationUpdateRequestBlockClosure {
            return buildChildLoadStateAppCopyContentStandardColoringsSearchCTAColoringsLocationUpdateRequestBlockClosure(loadState, appCopyContent, standardColorings, searchCTAColorings, locationUpdateRequestBlock)
        } else {
            return buildChildLoadStateAppCopyContentStandardColoringsSearchCTAColoringsLocationUpdateRequestBlockReturnValue
        }
    }

}
class SearchLookupViewModelBuilderProtocolMock: SearchLookupViewModelBuilderProtocol {



    //MARK: - buildViewModel

    var buildViewModelSearchActivityStateAppCopyContentStandardColoringsSearchCTAColoringsLocationUpdateRequestBlockCallsCount = 0
    var buildViewModelSearchActivityStateAppCopyContentStandardColoringsSearchCTAColoringsLocationUpdateRequestBlockCalled: Bool {
        return buildViewModelSearchActivityStateAppCopyContentStandardColoringsSearchCTAColoringsLocationUpdateRequestBlockCallsCount > 0
    }
    var buildViewModelSearchActivityStateAppCopyContentStandardColoringsSearchCTAColoringsLocationUpdateRequestBlockReceivedArguments: (searchActivityState: Search.ActivityState, appCopyContent: AppCopyContent, standardColorings: AppStandardColorings, searchCTAColorings: SearchCTAViewColorings, locationUpdateRequestBlock: LocationUpdateRequestBlock)?
    var buildViewModelSearchActivityStateAppCopyContentStandardColoringsSearchCTAColoringsLocationUpdateRequestBlockReceivedInvocations: [(searchActivityState: Search.ActivityState, appCopyContent: AppCopyContent, standardColorings: AppStandardColorings, searchCTAColorings: SearchCTAViewColorings, locationUpdateRequestBlock: LocationUpdateRequestBlock)] = []
    var buildViewModelSearchActivityStateAppCopyContentStandardColoringsSearchCTAColoringsLocationUpdateRequestBlockReturnValue: SearchLookupViewModel!
    var buildViewModelSearchActivityStateAppCopyContentStandardColoringsSearchCTAColoringsLocationUpdateRequestBlockClosure: ((Search.ActivityState, AppCopyContent, AppStandardColorings, SearchCTAViewColorings, @escaping LocationUpdateRequestBlock) -> SearchLookupViewModel)?

    func buildViewModel(searchActivityState: Search.ActivityState, appCopyContent: AppCopyContent, standardColorings: AppStandardColorings, searchCTAColorings: SearchCTAViewColorings, locationUpdateRequestBlock: @escaping LocationUpdateRequestBlock) -> SearchLookupViewModel {
        buildViewModelSearchActivityStateAppCopyContentStandardColoringsSearchCTAColoringsLocationUpdateRequestBlockCallsCount += 1
        buildViewModelSearchActivityStateAppCopyContentStandardColoringsSearchCTAColoringsLocationUpdateRequestBlockReceivedArguments = (searchActivityState: searchActivityState, appCopyContent: appCopyContent, standardColorings: standardColorings, searchCTAColorings: searchCTAColorings, locationUpdateRequestBlock: locationUpdateRequestBlock)
        buildViewModelSearchActivityStateAppCopyContentStandardColoringsSearchCTAColoringsLocationUpdateRequestBlockReceivedInvocations.append((searchActivityState: searchActivityState, appCopyContent: appCopyContent, standardColorings: standardColorings, searchCTAColorings: searchCTAColorings, locationUpdateRequestBlock: locationUpdateRequestBlock))
        if let buildViewModelSearchActivityStateAppCopyContentStandardColoringsSearchCTAColoringsLocationUpdateRequestBlockClosure = buildViewModelSearchActivityStateAppCopyContentStandardColoringsSearchCTAColoringsLocationUpdateRequestBlockClosure {
            return buildViewModelSearchActivityStateAppCopyContentStandardColoringsSearchCTAColoringsLocationUpdateRequestBlockClosure(searchActivityState, appCopyContent, standardColorings, searchCTAColorings, locationUpdateRequestBlock)
        } else {
            return buildViewModelSearchActivityStateAppCopyContentStandardColoringsSearchCTAColoringsLocationUpdateRequestBlockReturnValue
        }
    }

}
class SearchNoResultsFoundViewModelBuilderProtocolMock: SearchNoResultsFoundViewModelBuilderProtocol {



    //MARK: - buildViewModel

    var buildViewModelCopyContentColoringsCallsCount = 0
    var buildViewModelCopyContentColoringsCalled: Bool {
        return buildViewModelCopyContentColoringsCallsCount > 0
    }
    var buildViewModelCopyContentColoringsReceivedArguments: (copyContent: SearchNoResultsCopyContent, colorings: AppStandardColorings)?
    var buildViewModelCopyContentColoringsReceivedInvocations: [(copyContent: SearchNoResultsCopyContent, colorings: AppStandardColorings)] = []
    var buildViewModelCopyContentColoringsReturnValue: SearchNoResultsFoundViewModel!
    var buildViewModelCopyContentColoringsClosure: ((SearchNoResultsCopyContent, AppStandardColorings) -> SearchNoResultsFoundViewModel)?

    func buildViewModel(copyContent: SearchNoResultsCopyContent, colorings: AppStandardColorings) -> SearchNoResultsFoundViewModel {
        buildViewModelCopyContentColoringsCallsCount += 1
        buildViewModelCopyContentColoringsReceivedArguments = (copyContent: copyContent, colorings: colorings)
        buildViewModelCopyContentColoringsReceivedInvocations.append((copyContent: copyContent, colorings: colorings))
        if let buildViewModelCopyContentColoringsClosure = buildViewModelCopyContentColoringsClosure {
            return buildViewModelCopyContentColoringsClosure(copyContent, colorings)
        } else {
            return buildViewModelCopyContentColoringsReturnValue
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

    var loadNoInternetViewsTitleViewModelAppSkinCallsCount = 0
    var loadNoInternetViewsTitleViewModelAppSkinCalled: Bool {
        return loadNoInternetViewsTitleViewModelAppSkinCallsCount > 0
    }
    var loadNoInternetViewsTitleViewModelAppSkinReceivedArguments: (viewModel: SearchNoInternetViewModel, titleViewModel: NavigationBarTitleViewModel, appSkin: AppSkin)?
    var loadNoInternetViewsTitleViewModelAppSkinReceivedInvocations: [(viewModel: SearchNoInternetViewModel, titleViewModel: NavigationBarTitleViewModel, appSkin: AppSkin)] = []
    var loadNoInternetViewsTitleViewModelAppSkinClosure: ((SearchNoInternetViewModel, NavigationBarTitleViewModel, AppSkin) -> Void)?

    func loadNoInternetViews(_ viewModel: SearchNoInternetViewModel, titleViewModel: NavigationBarTitleViewModel, appSkin: AppSkin) {
        loadNoInternetViewsTitleViewModelAppSkinCallsCount += 1
        loadNoInternetViewsTitleViewModelAppSkinReceivedArguments = (viewModel: viewModel, titleViewModel: titleViewModel, appSkin: appSkin)
        loadNoInternetViewsTitleViewModelAppSkinReceivedInvocations.append((viewModel: viewModel, titleViewModel: titleViewModel, appSkin: appSkin))
        loadNoInternetViewsTitleViewModelAppSkinClosure?(viewModel, titleViewModel, appSkin)
    }

    //MARK: - loadLocationServicesDisabledViews

    var loadLocationServicesDisabledViewsTitleViewModelAppSkinCallsCount = 0
    var loadLocationServicesDisabledViewsTitleViewModelAppSkinCalled: Bool {
        return loadLocationServicesDisabledViewsTitleViewModelAppSkinCallsCount > 0
    }
    var loadLocationServicesDisabledViewsTitleViewModelAppSkinReceivedArguments: (viewModel: SearchLocationDisabledViewModel, titleViewModel: NavigationBarTitleViewModel, appSkin: AppSkin)?
    var loadLocationServicesDisabledViewsTitleViewModelAppSkinReceivedInvocations: [(viewModel: SearchLocationDisabledViewModel, titleViewModel: NavigationBarTitleViewModel, appSkin: AppSkin)] = []
    var loadLocationServicesDisabledViewsTitleViewModelAppSkinClosure: ((SearchLocationDisabledViewModel, NavigationBarTitleViewModel, AppSkin) -> Void)?

    func loadLocationServicesDisabledViews(_ viewModel: SearchLocationDisabledViewModel, titleViewModel: NavigationBarTitleViewModel, appSkin: AppSkin) {
        loadLocationServicesDisabledViewsTitleViewModelAppSkinCallsCount += 1
        loadLocationServicesDisabledViewsTitleViewModelAppSkinReceivedArguments = (viewModel: viewModel, titleViewModel: titleViewModel, appSkin: appSkin)
        loadLocationServicesDisabledViewsTitleViewModelAppSkinReceivedInvocations.append((viewModel: viewModel, titleViewModel: titleViewModel, appSkin: appSkin))
        loadLocationServicesDisabledViewsTitleViewModelAppSkinClosure?(viewModel, titleViewModel, appSkin)
    }

    //MARK: - loadSearchBackgroundView

    var loadSearchBackgroundViewTitleViewModelAppSkinCallsCount = 0
    var loadSearchBackgroundViewTitleViewModelAppSkinCalled: Bool {
        return loadSearchBackgroundViewTitleViewModelAppSkinCallsCount > 0
    }
    var loadSearchBackgroundViewTitleViewModelAppSkinReceivedArguments: (viewModel: SearchBackgroundViewModel, titleViewModel: NavigationBarTitleViewModel, appSkin: AppSkin)?
    var loadSearchBackgroundViewTitleViewModelAppSkinReceivedInvocations: [(viewModel: SearchBackgroundViewModel, titleViewModel: NavigationBarTitleViewModel, appSkin: AppSkin)] = []
    var loadSearchBackgroundViewTitleViewModelAppSkinClosure: ((SearchBackgroundViewModel, NavigationBarTitleViewModel, AppSkin) -> Void)?

    func loadSearchBackgroundView(_ viewModel: SearchBackgroundViewModel, titleViewModel: NavigationBarTitleViewModel, appSkin: AppSkin) {
        loadSearchBackgroundViewTitleViewModelAppSkinCallsCount += 1
        loadSearchBackgroundViewTitleViewModelAppSkinReceivedArguments = (viewModel: viewModel, titleViewModel: titleViewModel, appSkin: appSkin)
        loadSearchBackgroundViewTitleViewModelAppSkinReceivedInvocations.append((viewModel: viewModel, titleViewModel: titleViewModel, appSkin: appSkin))
        loadSearchBackgroundViewTitleViewModelAppSkinClosure?(viewModel, titleViewModel, appSkin)
    }

    //MARK: - loadSearchViews

    var loadSearchViewsDetailsViewContextTitleViewModelAppSkinCallsCount = 0
    var loadSearchViewsDetailsViewContextTitleViewModelAppSkinCalled: Bool {
        return loadSearchViewsDetailsViewContextTitleViewModelAppSkinCallsCount > 0
    }
    var loadSearchViewsDetailsViewContextTitleViewModelAppSkinReceivedArguments: (viewModel: SearchLookupViewModel, detailsViewContext: SearchDetailsViewContext?, titleViewModel: NavigationBarTitleViewModel, appSkin: AppSkin)?
    var loadSearchViewsDetailsViewContextTitleViewModelAppSkinReceivedInvocations: [(viewModel: SearchLookupViewModel, detailsViewContext: SearchDetailsViewContext?, titleViewModel: NavigationBarTitleViewModel, appSkin: AppSkin)] = []
    var loadSearchViewsDetailsViewContextTitleViewModelAppSkinClosure: ((SearchLookupViewModel, SearchDetailsViewContext?, NavigationBarTitleViewModel, AppSkin) -> Void)?

    func loadSearchViews(_ viewModel: SearchLookupViewModel, detailsViewContext: SearchDetailsViewContext?, titleViewModel: NavigationBarTitleViewModel, appSkin: AppSkin) {
        loadSearchViewsDetailsViewContextTitleViewModelAppSkinCallsCount += 1
        loadSearchViewsDetailsViewContextTitleViewModelAppSkinReceivedArguments = (viewModel: viewModel, detailsViewContext: detailsViewContext, titleViewModel: titleViewModel, appSkin: appSkin)
        loadSearchViewsDetailsViewContextTitleViewModelAppSkinReceivedInvocations.append((viewModel: viewModel, detailsViewContext: detailsViewContext, titleViewModel: titleViewModel, appSkin: appSkin))
        loadSearchViewsDetailsViewContextTitleViewModelAppSkinClosure?(viewModel, detailsViewContext, titleViewModel, appSkin)
    }

}
class SearchResultCellModelBuilderProtocolMock: SearchResultCellModelBuilderProtocol {



    //MARK: - buildViewModel

    var buildViewModelResultsCopyContentCallsCount = 0
    var buildViewModelResultsCopyContentCalled: Bool {
        return buildViewModelResultsCopyContentCallsCount > 0
    }
    var buildViewModelResultsCopyContentReceivedArguments: (model: SearchEntityModel, resultsCopyContent: SearchResultsCopyContent)?
    var buildViewModelResultsCopyContentReceivedInvocations: [(model: SearchEntityModel, resultsCopyContent: SearchResultsCopyContent)] = []
    var buildViewModelResultsCopyContentReturnValue: SearchResultCellModel!
    var buildViewModelResultsCopyContentClosure: ((SearchEntityModel, SearchResultsCopyContent) -> SearchResultCellModel)?

    func buildViewModel(_ model: SearchEntityModel, resultsCopyContent: SearchResultsCopyContent) -> SearchResultCellModel {
        buildViewModelResultsCopyContentCallsCount += 1
        buildViewModelResultsCopyContentReceivedArguments = (model: model, resultsCopyContent: resultsCopyContent)
        buildViewModelResultsCopyContentReceivedInvocations.append((model: model, resultsCopyContent: resultsCopyContent))
        if let buildViewModelResultsCopyContentClosure = buildViewModelResultsCopyContentClosure {
            return buildViewModelResultsCopyContentClosure(model, resultsCopyContent)
        } else {
            return buildViewModelResultsCopyContentReturnValue
        }
    }

}
class SearchResultViewModelBuilderProtocolMock: SearchResultViewModelBuilderProtocol {



    //MARK: - buildViewModel

    var buildViewModelResultsCopyContentCallsCount = 0
    var buildViewModelResultsCopyContentCalled: Bool {
        return buildViewModelResultsCopyContentCallsCount > 0
    }
    var buildViewModelResultsCopyContentReceivedArguments: (model: SearchEntityModel, resultsCopyContent: SearchResultsCopyContent)?
    var buildViewModelResultsCopyContentReceivedInvocations: [(model: SearchEntityModel, resultsCopyContent: SearchResultsCopyContent)] = []
    var buildViewModelResultsCopyContentReturnValue: SearchResultViewModel!
    var buildViewModelResultsCopyContentClosure: ((SearchEntityModel, SearchResultsCopyContent) -> SearchResultViewModel)?

    func buildViewModel(_ model: SearchEntityModel, resultsCopyContent: SearchResultsCopyContent) -> SearchResultViewModel {
        buildViewModelResultsCopyContentCallsCount += 1
        buildViewModelResultsCopyContentReceivedArguments = (model: model, resultsCopyContent: resultsCopyContent)
        buildViewModelResultsCopyContentReceivedInvocations.append((model: model, resultsCopyContent: resultsCopyContent))
        if let buildViewModelResultsCopyContentClosure = buildViewModelResultsCopyContentClosure {
            return buildViewModelResultsCopyContentClosure(model, resultsCopyContent)
        } else {
            return buildViewModelResultsCopyContentReturnValue
        }
    }

}
class SearchResultsViewModelBuilderProtocolMock: SearchResultsViewModelBuilderProtocol {



    //MARK: - buildViewModel

    var buildViewModelSubmittedParamsAllEntitiesNumPagesReceivedTokenContainerResultsCopyContentActionSubscriberLocationUpdateRequestBlockCallsCount = 0
    var buildViewModelSubmittedParamsAllEntitiesNumPagesReceivedTokenContainerResultsCopyContentActionSubscriberLocationUpdateRequestBlockCalled: Bool {
        return buildViewModelSubmittedParamsAllEntitiesNumPagesReceivedTokenContainerResultsCopyContentActionSubscriberLocationUpdateRequestBlockCallsCount > 0
    }
    var buildViewModelSubmittedParamsAllEntitiesNumPagesReceivedTokenContainerResultsCopyContentActionSubscriberLocationUpdateRequestBlockReceivedArguments: (submittedParams: SearchParams, allEntities: NonEmptyArray<SearchEntityModel>, numPagesReceived: Int, tokenContainer: PlaceLookupTokenAttemptsContainer?, resultsCopyContent: SearchResultsCopyContent, actionSubscriber: AnySubscriber<Search.Action, Never>, locationUpdateRequestBlock: LocationUpdateRequestBlock)?
    var buildViewModelSubmittedParamsAllEntitiesNumPagesReceivedTokenContainerResultsCopyContentActionSubscriberLocationUpdateRequestBlockReceivedInvocations: [(submittedParams: SearchParams, allEntities: NonEmptyArray<SearchEntityModel>, numPagesReceived: Int, tokenContainer: PlaceLookupTokenAttemptsContainer?, resultsCopyContent: SearchResultsCopyContent, actionSubscriber: AnySubscriber<Search.Action, Never>, locationUpdateRequestBlock: LocationUpdateRequestBlock)] = []
    var buildViewModelSubmittedParamsAllEntitiesNumPagesReceivedTokenContainerResultsCopyContentActionSubscriberLocationUpdateRequestBlockReturnValue: SearchResultsViewModel!
    var buildViewModelSubmittedParamsAllEntitiesNumPagesReceivedTokenContainerResultsCopyContentActionSubscriberLocationUpdateRequestBlockClosure: ((SearchParams, NonEmptyArray<SearchEntityModel>, Int, PlaceLookupTokenAttemptsContainer?, SearchResultsCopyContent, AnySubscriber<Search.Action, Never>, @escaping LocationUpdateRequestBlock) -> SearchResultsViewModel)?

    func buildViewModel(submittedParams: SearchParams, allEntities: NonEmptyArray<SearchEntityModel>, numPagesReceived: Int, tokenContainer: PlaceLookupTokenAttemptsContainer?, resultsCopyContent: SearchResultsCopyContent, actionSubscriber: AnySubscriber<Search.Action, Never>, locationUpdateRequestBlock: @escaping LocationUpdateRequestBlock) -> SearchResultsViewModel {
        buildViewModelSubmittedParamsAllEntitiesNumPagesReceivedTokenContainerResultsCopyContentActionSubscriberLocationUpdateRequestBlockCallsCount += 1
        buildViewModelSubmittedParamsAllEntitiesNumPagesReceivedTokenContainerResultsCopyContentActionSubscriberLocationUpdateRequestBlockReceivedArguments = (submittedParams: submittedParams, allEntities: allEntities, numPagesReceived: numPagesReceived, tokenContainer: tokenContainer, resultsCopyContent: resultsCopyContent, actionSubscriber: actionSubscriber, locationUpdateRequestBlock: locationUpdateRequestBlock)
        buildViewModelSubmittedParamsAllEntitiesNumPagesReceivedTokenContainerResultsCopyContentActionSubscriberLocationUpdateRequestBlockReceivedInvocations.append((submittedParams: submittedParams, allEntities: allEntities, numPagesReceived: numPagesReceived, tokenContainer: tokenContainer, resultsCopyContent: resultsCopyContent, actionSubscriber: actionSubscriber, locationUpdateRequestBlock: locationUpdateRequestBlock))
        if let buildViewModelSubmittedParamsAllEntitiesNumPagesReceivedTokenContainerResultsCopyContentActionSubscriberLocationUpdateRequestBlockClosure = buildViewModelSubmittedParamsAllEntitiesNumPagesReceivedTokenContainerResultsCopyContentActionSubscriberLocationUpdateRequestBlockClosure {
            return buildViewModelSubmittedParamsAllEntitiesNumPagesReceivedTokenContainerResultsCopyContentActionSubscriberLocationUpdateRequestBlockClosure(submittedParams, allEntities, numPagesReceived, tokenContainer, resultsCopyContent, actionSubscriber, locationUpdateRequestBlock)
        } else {
            return buildViewModelSubmittedParamsAllEntitiesNumPagesReceivedTokenContainerResultsCopyContentActionSubscriberLocationUpdateRequestBlockReturnValue
        }
    }

}
class SearchRetryViewModelBuilderProtocolMock: SearchRetryViewModelBuilderProtocol {



    //MARK: - buildViewModel

    var buildViewModelCopyContentColoringsCtaBlockCallsCount = 0
    var buildViewModelCopyContentColoringsCtaBlockCalled: Bool {
        return buildViewModelCopyContentColoringsCtaBlockCallsCount > 0
    }
    var buildViewModelCopyContentColoringsCtaBlockReceivedArguments: (copyContent: SearchRetryCopyContent, colorings: SearchCTAViewColorings, ctaBlock: SearchCTABlock)?
    var buildViewModelCopyContentColoringsCtaBlockReceivedInvocations: [(copyContent: SearchRetryCopyContent, colorings: SearchCTAViewColorings, ctaBlock: SearchCTABlock)] = []
    var buildViewModelCopyContentColoringsCtaBlockReturnValue: SearchRetryViewModel!
    var buildViewModelCopyContentColoringsCtaBlockClosure: ((SearchRetryCopyContent, SearchCTAViewColorings, @escaping SearchCTABlock) -> SearchRetryViewModel)?

    func buildViewModel(copyContent: SearchRetryCopyContent, colorings: SearchCTAViewColorings, ctaBlock: @escaping SearchCTABlock) -> SearchRetryViewModel {
        buildViewModelCopyContentColoringsCtaBlockCallsCount += 1
        buildViewModelCopyContentColoringsCtaBlockReceivedArguments = (copyContent: copyContent, colorings: colorings, ctaBlock: ctaBlock)
        buildViewModelCopyContentColoringsCtaBlockReceivedInvocations.append((copyContent: copyContent, colorings: colorings, ctaBlock: ctaBlock))
        if let buildViewModelCopyContentColoringsCtaBlockClosure = buildViewModelCopyContentColoringsCtaBlockClosure {
            return buildViewModelCopyContentColoringsCtaBlockClosure(copyContent, colorings, ctaBlock)
        } else {
            return buildViewModelCopyContentColoringsCtaBlockReturnValue
        }
    }

}
class SettingsCellViewModelBuilderProtocolMock: SettingsCellViewModelBuilderProtocol {



    //MARK: - buildDistanceCellModels

    var buildDistanceCellModelsCurrentDistanceTypeCallsCount = 0
    var buildDistanceCellModelsCurrentDistanceTypeCalled: Bool {
        return buildDistanceCellModelsCurrentDistanceTypeCallsCount > 0
    }
    var buildDistanceCellModelsCurrentDistanceTypeReceivedCurrentDistanceType: SearchDistance?
    var buildDistanceCellModelsCurrentDistanceTypeReceivedInvocations: [SearchDistance] = []
    var buildDistanceCellModelsCurrentDistanceTypeReturnValue: [SettingsCellViewModel]!
    var buildDistanceCellModelsCurrentDistanceTypeClosure: ((SearchDistance) -> [SettingsCellViewModel])?

    func buildDistanceCellModels(currentDistanceType: SearchDistance) -> [SettingsCellViewModel] {
        buildDistanceCellModelsCurrentDistanceTypeCallsCount += 1
        buildDistanceCellModelsCurrentDistanceTypeReceivedCurrentDistanceType = currentDistanceType
        buildDistanceCellModelsCurrentDistanceTypeReceivedInvocations.append(currentDistanceType)
        if let buildDistanceCellModelsCurrentDistanceTypeClosure = buildDistanceCellModelsCurrentDistanceTypeClosure {
            return buildDistanceCellModelsCurrentDistanceTypeClosure(currentDistanceType)
        } else {
            return buildDistanceCellModelsCurrentDistanceTypeReturnValue
        }
    }

    //MARK: - buildSortingCellModels

    var buildSortingCellModelsCurrentSortingCopyContentCallsCount = 0
    var buildSortingCellModelsCurrentSortingCopyContentCalled: Bool {
        return buildSortingCellModelsCurrentSortingCopyContentCallsCount > 0
    }
    var buildSortingCellModelsCurrentSortingCopyContentReceivedArguments: (currentSorting: PlaceLookupSorting, copyContent: SettingsSortPreferenceCopyContent)?
    var buildSortingCellModelsCurrentSortingCopyContentReceivedInvocations: [(currentSorting: PlaceLookupSorting, copyContent: SettingsSortPreferenceCopyContent)] = []
    var buildSortingCellModelsCurrentSortingCopyContentReturnValue: [SettingsCellViewModel]!
    var buildSortingCellModelsCurrentSortingCopyContentClosure: ((PlaceLookupSorting, SettingsSortPreferenceCopyContent) -> [SettingsCellViewModel])?

    func buildSortingCellModels(currentSorting: PlaceLookupSorting, copyContent: SettingsSortPreferenceCopyContent) -> [SettingsCellViewModel] {
        buildSortingCellModelsCurrentSortingCopyContentCallsCount += 1
        buildSortingCellModelsCurrentSortingCopyContentReceivedArguments = (currentSorting: currentSorting, copyContent: copyContent)
        buildSortingCellModelsCurrentSortingCopyContentReceivedInvocations.append((currentSorting: currentSorting, copyContent: copyContent))
        if let buildSortingCellModelsCurrentSortingCopyContentClosure = buildSortingCellModelsCurrentSortingCopyContentClosure {
            return buildSortingCellModelsCurrentSortingCopyContentClosure(currentSorting, copyContent)
        } else {
            return buildSortingCellModelsCurrentSortingCopyContentReturnValue
        }
    }

}
class SettingsPlainHeaderViewModelBuilderProtocolMock: SettingsPlainHeaderViewModelBuilderProtocol {



    //MARK: - buildViewModel

    var buildViewModelCallsCount = 0
    var buildViewModelCalled: Bool {
        return buildViewModelCallsCount > 0
    }
    var buildViewModelReceivedTitle: String?
    var buildViewModelReceivedInvocations: [String] = []
    var buildViewModelReturnValue: SettingsPlainHeaderViewModel!
    var buildViewModelClosure: ((String) -> SettingsPlainHeaderViewModel)?

    func buildViewModel(_ title: String) -> SettingsPlainHeaderViewModel {
        buildViewModelCallsCount += 1
        buildViewModelReceivedTitle = title
        buildViewModelReceivedInvocations.append(title)
        if let buildViewModelClosure = buildViewModelClosure {
            return buildViewModelClosure(title)
        } else {
            return buildViewModelReturnValue
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

    var loadSettingsViewTitleViewModelAppSkinCallsCount = 0
    var loadSettingsViewTitleViewModelAppSkinCalled: Bool {
        return loadSettingsViewTitleViewModelAppSkinCallsCount > 0
    }
    var loadSettingsViewTitleViewModelAppSkinReceivedArguments: (viewModel: SettingsViewModel, titleViewModel: NavigationBarTitleViewModel, appSkin: AppSkin)?
    var loadSettingsViewTitleViewModelAppSkinReceivedInvocations: [(viewModel: SettingsViewModel, titleViewModel: NavigationBarTitleViewModel, appSkin: AppSkin)] = []
    var loadSettingsViewTitleViewModelAppSkinClosure: ((SettingsViewModel, NavigationBarTitleViewModel, AppSkin) -> Void)?

    func loadSettingsView(_ viewModel: SettingsViewModel, titleViewModel: NavigationBarTitleViewModel, appSkin: AppSkin) {
        loadSettingsViewTitleViewModelAppSkinCallsCount += 1
        loadSettingsViewTitleViewModelAppSkinReceivedArguments = (viewModel: viewModel, titleViewModel: titleViewModel, appSkin: appSkin)
        loadSettingsViewTitleViewModelAppSkinReceivedInvocations.append((viewModel: viewModel, titleViewModel: titleViewModel, appSkin: appSkin))
        loadSettingsViewTitleViewModelAppSkinClosure?(viewModel, titleViewModel, appSkin)
    }

}
class SettingsUnitsHeaderViewModelBuilderProtocolMock: SettingsUnitsHeaderViewModelBuilderProtocol {



    //MARK: - buildViewModel

    var buildViewModelCurrentlyActiveSystemCopyContentCallsCount = 0
    var buildViewModelCurrentlyActiveSystemCopyContentCalled: Bool {
        return buildViewModelCurrentlyActiveSystemCopyContentCallsCount > 0
    }
    var buildViewModelCurrentlyActiveSystemCopyContentReceivedArguments: (title: String, currentlyActiveSystem: MeasurementSystem, copyContent: SettingsMeasurementSystemCopyContent)?
    var buildViewModelCurrentlyActiveSystemCopyContentReceivedInvocations: [(title: String, currentlyActiveSystem: MeasurementSystem, copyContent: SettingsMeasurementSystemCopyContent)] = []
    var buildViewModelCurrentlyActiveSystemCopyContentReturnValue: SettingsUnitsHeaderViewModel!
    var buildViewModelCurrentlyActiveSystemCopyContentClosure: ((String, MeasurementSystem, SettingsMeasurementSystemCopyContent) -> SettingsUnitsHeaderViewModel)?

    func buildViewModel(_ title: String, currentlyActiveSystem: MeasurementSystem, copyContent: SettingsMeasurementSystemCopyContent) -> SettingsUnitsHeaderViewModel {
        buildViewModelCurrentlyActiveSystemCopyContentCallsCount += 1
        buildViewModelCurrentlyActiveSystemCopyContentReceivedArguments = (title: title, currentlyActiveSystem: currentlyActiveSystem, copyContent: copyContent)
        buildViewModelCurrentlyActiveSystemCopyContentReceivedInvocations.append((title: title, currentlyActiveSystem: currentlyActiveSystem, copyContent: copyContent))
        if let buildViewModelCurrentlyActiveSystemCopyContentClosure = buildViewModelCurrentlyActiveSystemCopyContentClosure {
            return buildViewModelCurrentlyActiveSystemCopyContentClosure(title, currentlyActiveSystem, copyContent)
        } else {
            return buildViewModelCurrentlyActiveSystemCopyContentReturnValue
        }
    }

}
class SettingsViewModelBuilderProtocolMock: SettingsViewModelBuilderProtocol {



    //MARK: - buildViewModel

    var buildViewModelSearchPreferencesStateAppCopyContentCallsCount = 0
    var buildViewModelSearchPreferencesStateAppCopyContentCalled: Bool {
        return buildViewModelSearchPreferencesStateAppCopyContentCallsCount > 0
    }
    var buildViewModelSearchPreferencesStateAppCopyContentReceivedArguments: (searchPreferencesState: SearchPreferencesState, appCopyContent: AppCopyContent)?
    var buildViewModelSearchPreferencesStateAppCopyContentReceivedInvocations: [(searchPreferencesState: SearchPreferencesState, appCopyContent: AppCopyContent)] = []
    var buildViewModelSearchPreferencesStateAppCopyContentReturnValue: SettingsViewModel!
    var buildViewModelSearchPreferencesStateAppCopyContentClosure: ((SearchPreferencesState, AppCopyContent) -> SettingsViewModel)?

    func buildViewModel(searchPreferencesState: SearchPreferencesState, appCopyContent: AppCopyContent) -> SettingsViewModel {
        buildViewModelSearchPreferencesStateAppCopyContentCallsCount += 1
        buildViewModelSearchPreferencesStateAppCopyContentReceivedArguments = (searchPreferencesState: searchPreferencesState, appCopyContent: appCopyContent)
        buildViewModelSearchPreferencesStateAppCopyContentReceivedInvocations.append((searchPreferencesState: searchPreferencesState, appCopyContent: appCopyContent))
        if let buildViewModelSearchPreferencesStateAppCopyContentClosure = buildViewModelSearchPreferencesStateAppCopyContentClosure {
            return buildViewModelSearchPreferencesStateAppCopyContentClosure(searchPreferencesState, appCopyContent)
        } else {
            return buildViewModelSearchPreferencesStateAppCopyContentReturnValue
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
