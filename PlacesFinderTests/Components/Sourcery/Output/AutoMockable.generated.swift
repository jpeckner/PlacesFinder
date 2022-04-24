// Generated using Sourcery 1.2.1 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT


















import Combine
import CoordiNode
import Foundation
import Shared
import SharedTestComponents
import SwiftDux
import UIKit

internal class AppCoordinatorChildFactoryProtocolMock<TStore: StoreProtocol>: AppCoordinatorChildFactoryProtocol where TStore.TState == AppState, TStore.TAction == AppAction {
    internal var store: TStore {
        get { return underlyingStore }
        set(value) { underlyingStore = value }
    }
    internal var underlyingStore: TStore!
    internal var serviceContainer: ServiceContainer {
        get { return underlyingServiceContainer }
        set(value) { underlyingServiceContainer = value }
    }
    internal var underlyingServiceContainer: ServiceContainer!
    internal var launchStatePrism: LaunchStatePrismProtocol {
        get { return underlyingLaunchStatePrism }
        set(value) { underlyingLaunchStatePrism = value }
    }
    internal var underlyingLaunchStatePrism: LaunchStatePrismProtocol!

    // MARK: - buildLaunchCoordinator

    internal var buildLaunchCoordinatorCallsCount = 0
    internal var buildLaunchCoordinatorCalled: Bool {
        return buildLaunchCoordinatorCallsCount > 0
    }
    internal var buildLaunchCoordinatorReturnValue: AppCoordinatorChildProtocol!
    internal var buildLaunchCoordinatorClosure: (() -> AppCoordinatorChildProtocol)?

    internal func buildLaunchCoordinator() -> AppCoordinatorChildProtocol {
        buildLaunchCoordinatorCallsCount += 1
        return buildLaunchCoordinatorClosure.map({ $0() }) ?? buildLaunchCoordinatorReturnValue
    }

    // MARK: - buildCoordinator

    internal var buildCoordinatorForCallsCount = 0
    internal var buildCoordinatorForCalled: Bool {
        return buildCoordinatorForCallsCount > 0
    }
    internal var buildCoordinatorForReceivedChildType: AppCoordinatorDestinationDescendent?
    internal var buildCoordinatorForReturnValue: AppCoordinatorChildProtocol!
    internal var buildCoordinatorForClosure: ((AppCoordinatorDestinationDescendent) -> AppCoordinatorChildProtocol)?

    internal func buildCoordinator(for childType: AppCoordinatorDestinationDescendent) -> AppCoordinatorChildProtocol {
        buildCoordinatorForCallsCount += 1
        buildCoordinatorForReceivedChildType = childType
        return buildCoordinatorForClosure.map({ $0(childType) }) ?? buildCoordinatorForReturnValue
    }

}
internal class AppGlobalStylingsHandlerProtocolMock: AppGlobalStylingsHandlerProtocol {

    // MARK: - apply

    internal var applyCallsCount = 0
    internal var applyCalled: Bool {
        return applyCallsCount > 0
    }
    internal var applyReceivedAppSkin: AppSkin?
    internal var applyClosure: ((AppSkin) -> Void)?

    internal func apply(_ appSkin: AppSkin) {
        applyCallsCount += 1
        applyReceivedAppSkin = appSkin
        applyClosure?(appSkin)
    }

}
internal class AppLinkTypeBuilderProtocolMock: AppLinkTypeBuilderProtocol {

    // MARK: - buildPayload

    internal var buildPayloadCallsCount = 0
    internal var buildPayloadCalled: Bool {
        return buildPayloadCallsCount > 0
    }
    internal var buildPayloadReceivedUrl: URL?
    internal var buildPayloadReturnValue: AppLinkType?
    internal var buildPayloadClosure: ((URL) -> AppLinkType?)?

    internal func buildPayload(_ url: URL) -> AppLinkType? {
        buildPayloadCallsCount += 1
        buildPayloadReceivedUrl = url
        return buildPayloadClosure.map({ $0(url) }) ?? buildPayloadReturnValue
    }

}
internal class AppSkinServiceProtocolMock: AppSkinServiceProtocol {

    // MARK: - fetchAppSkin

    internal var fetchAppSkinCompletionCallsCount = 0
    internal var fetchAppSkinCompletionCalled: Bool {
        return fetchAppSkinCompletionCallsCount > 0
    }
    internal var fetchAppSkinCompletionReceivedCompletion: (AppSkinServiceCompletion)?
    internal var fetchAppSkinCompletionClosure: ((@escaping AppSkinServiceCompletion) -> Void)?

    internal func fetchAppSkin(completion: @escaping AppSkinServiceCompletion) {
        fetchAppSkinCompletionCallsCount += 1
        fetchAppSkinCompletionReceivedCompletion = completion
        fetchAppSkinCompletionClosure?(completion)
    }

}
internal class ChildCoordinatorProtocolMock: ChildCoordinatorProtocol {
    internal var rootViewController: UIViewController {
        get { return underlyingRootViewController }
        set(value) { underlyingRootViewController = value }
    }
    internal var underlyingRootViewController: UIViewController!

    // MARK: - start

    internal var startCallsCount = 0
    internal var startCalled: Bool {
        return startCallsCount > 0
    }
    internal var startReceivedCompletion: (() -> Void)?
    internal var startClosure: ((() -> Void) -> Void)?

    internal func start(_ completion: () -> Void) {
        startCallsCount += 1
        startClosure?(completion)
    }

    // MARK: - finish

    internal var finishCallsCount = 0
    internal var finishCalled: Bool {
        return finishCallsCount > 0
    }
    internal var finishReceivedCompletion: (() -> Void)?
    internal var finishClosure: (((() -> Void)?) -> Void)?

    internal func finish(_ completion: (() -> Void)?) {
        finishCallsCount += 1
        finishClosure?(completion)
    }

}
internal class HomeCoordinatorChildFactoryProtocolMock<TStore: StoreProtocol>: HomeCoordinatorChildFactoryProtocol where TStore.TState == AppState, TStore.TAction == AppAction {

    // MARK: - buildCoordinator

    internal var buildCoordinatorForCallsCount = 0
    internal var buildCoordinatorForCalled: Bool {
        return buildCoordinatorForCallsCount > 0
    }
    internal var buildCoordinatorForReceivedDestinationDescendent: HomeCoordinatorDestinationDescendent?
    internal var buildCoordinatorForReturnValue: TabCoordinatorProtocol!
    internal var buildCoordinatorForClosure: ((HomeCoordinatorDestinationDescendent) -> TabCoordinatorProtocol)?

    internal func buildCoordinator(for destinationDescendent: HomeCoordinatorDestinationDescendent) -> TabCoordinatorProtocol {
        buildCoordinatorForCallsCount += 1
        buildCoordinatorForReceivedDestinationDescendent = destinationDescendent
        return buildCoordinatorForClosure.map({ $0(destinationDescendent) }) ?? buildCoordinatorForReturnValue
    }

}
internal class HomePresenterProtocolMock: HomePresenterProtocol {
    internal var delegate: HomePresenterDelegate?
    internal var rootViewController: UIViewController {
        get { return underlyingRootViewController }
        set(value) { underlyingRootViewController = value }
    }
    internal var underlyingRootViewController: UIViewController!

    // MARK: - setSelectedViewController

    internal var setSelectedViewControllerCallsCount = 0
    internal var setSelectedViewControllerCalled: Bool {
        return setSelectedViewControllerCallsCount > 0
    }
    internal var setSelectedViewControllerReceivedController: UIViewController?
    internal var setSelectedViewControllerClosure: ((UIViewController) -> Void)?

    internal func setSelectedViewController(_ controller: UIViewController) {
        setSelectedViewControllerCallsCount += 1
        setSelectedViewControllerReceivedController = controller
        setSelectedViewControllerClosure?(controller)
    }

}
internal class LaunchPresenterProtocolMock: LaunchPresenterProtocol {
    internal var rootViewController: UIViewController {
        get { return underlyingRootViewController }
        set(value) { underlyingRootViewController = value }
    }
    internal var underlyingRootViewController: UIViewController!

    // MARK: - startSpinner

    internal var startSpinnerCallsCount = 0
    internal var startSpinnerCalled: Bool {
        return startSpinnerCallsCount > 0
    }
    internal var startSpinnerClosure: (() -> Void)?

    internal func startSpinner() {
        startSpinnerCallsCount += 1
        startSpinnerClosure?()
    }

    // MARK: - animateOut

    internal var animateOutCallsCount = 0
    internal var animateOutCalled: Bool {
        return animateOutCallsCount > 0
    }
    internal var animateOutReceivedCompletion: (() -> Void)?
    internal var animateOutClosure: (((() -> Void)?) -> Void)?

    internal func animateOut(_ completion: (() -> Void)?) {
        animateOutCallsCount += 1
        animateOutClosure?(completion)
    }

}
internal class LaunchStatePrismProtocolMock: LaunchStatePrismProtocol {
    internal var launchKeyPaths: Set<EquatableKeyPath<AppState>> {
        get { return underlyingLaunchKeyPaths }
        set(value) { underlyingLaunchKeyPaths = value }
    }
    internal var underlyingLaunchKeyPaths: Set<EquatableKeyPath<AppState>>!

    // MARK: - hasFinishedLaunching

    internal var hasFinishedLaunchingCallsCount = 0
    internal var hasFinishedLaunchingCalled: Bool {
        return hasFinishedLaunchingCallsCount > 0
    }
    internal var hasFinishedLaunchingReceivedState: AppState?
    internal var hasFinishedLaunchingReturnValue: Bool!
    internal var hasFinishedLaunchingClosure: ((AppState) -> Bool)?

    internal func hasFinishedLaunching(_ state: AppState) -> Bool {
        hasFinishedLaunchingCallsCount += 1
        hasFinishedLaunchingReceivedState = state
        return hasFinishedLaunchingClosure.map({ $0(state) }) ?? hasFinishedLaunchingReturnValue
    }

}
internal class LocationAuthListenerProtocolMock: LocationAuthListenerProtocol {
    internal var actionPublisher: AnyPublisher<LocationAuthAction, Never> {
        get { return underlyingActionPublisher }
        set(value) { underlyingActionPublisher = value }
    }
    internal var underlyingActionPublisher: AnyPublisher<LocationAuthAction, Never>!

    // MARK: - start

    internal var startCallsCount = 0
    internal var startCalled: Bool {
        return startCallsCount > 0
    }
    internal var startClosure: (() -> Void)?

    internal func start() {
        startCallsCount += 1
        startClosure?()
    }

    // MARK: - requestWhenInUseAuthorization

    internal var requestWhenInUseAuthorizationCallsCount = 0
    internal var requestWhenInUseAuthorizationCalled: Bool {
        return requestWhenInUseAuthorizationCallsCount > 0
    }
    internal var requestWhenInUseAuthorizationClosure: (() -> Void)?

    internal func requestWhenInUseAuthorization() {
        requestWhenInUseAuthorizationCallsCount += 1
        requestWhenInUseAuthorizationClosure?()
    }

}
internal class NavigationBarViewModelBuilderProtocolMock: NavigationBarViewModelBuilderProtocol {

    // MARK: - buildTitleViewModel

    internal var buildTitleViewModelCopyContentCallsCount = 0
    internal var buildTitleViewModelCopyContentCalled: Bool {
        return buildTitleViewModelCopyContentCallsCount > 0
    }
    internal var buildTitleViewModelCopyContentReceivedCopyContent: DisplayNameCopyContent?
    internal var buildTitleViewModelCopyContentReturnValue: NavigationBarTitleViewModel!
    internal var buildTitleViewModelCopyContentClosure: ((DisplayNameCopyContent) -> NavigationBarTitleViewModel)?

    internal func buildTitleViewModel(copyContent: DisplayNameCopyContent) -> NavigationBarTitleViewModel {
        buildTitleViewModelCopyContentCallsCount += 1
        buildTitleViewModelCopyContentReceivedCopyContent = copyContent
        return buildTitleViewModelCopyContentClosure.map({ $0(copyContent) }) ?? buildTitleViewModelCopyContentReturnValue
    }

}
internal class PlaceLookupServiceProtocolMock: PlaceLookupServiceProtocol {

    // MARK: - buildInitialPageRequestToken

    internal var buildInitialPageRequestTokenThrowableError: Error?
    internal var buildInitialPageRequestTokenCallsCount = 0
    internal var buildInitialPageRequestTokenCalled: Bool {
        return buildInitialPageRequestTokenCallsCount > 0
    }
    internal var buildInitialPageRequestTokenReceivedPlaceLookupParams: PlaceLookupParams?
    internal var buildInitialPageRequestTokenReturnValue: PlaceLookupPageRequestToken!
    internal var buildInitialPageRequestTokenClosure: ((PlaceLookupParams) throws -> PlaceLookupPageRequestToken)?

    internal func buildInitialPageRequestToken(_ placeLookupParams: PlaceLookupParams) throws -> PlaceLookupPageRequestToken {
        buildInitialPageRequestTokenCallsCount += 1
        buildInitialPageRequestTokenReceivedPlaceLookupParams = placeLookupParams
        if let error = buildInitialPageRequestTokenThrowableError { throw error }
        return try buildInitialPageRequestTokenClosure.map({ try $0(placeLookupParams) }) ?? buildInitialPageRequestTokenReturnValue
    }

    // MARK: - requestPage

    internal var requestPageCompletionCallsCount = 0
    internal var requestPageCompletionCalled: Bool {
        return requestPageCompletionCallsCount > 0
    }
    internal var requestPageCompletionReceivedArguments: (requestToken: PlaceLookupPageRequestToken, completion: PlaceLookupCompletion)?
    internal var requestPageCompletionClosure: ((PlaceLookupPageRequestToken, @escaping PlaceLookupCompletion) -> Void)?

    internal func requestPage(_ requestToken: PlaceLookupPageRequestToken,
                     completion: @escaping PlaceLookupCompletion) {
        requestPageCompletionCallsCount += 1
        requestPageCompletionReceivedArguments = (requestToken: requestToken, completion: completion)
        requestPageCompletionClosure?(requestToken, completion)
    }

}
internal class ReachabilityListenerProtocolMock: ReachabilityListenerProtocol {

    // MARK: - start

    internal var startThrowableError: Error?
    internal var startCallsCount = 0
    internal var startCalled: Bool {
        return startCallsCount > 0
    }
    internal var startClosure: (() throws -> Void)?

    internal func start() throws {
        startCallsCount += 1
        if let error = startThrowableError { throw error }
        try startClosure?()
    }

}
internal class ReachabilityProtocolMock: ReachabilityProtocol {

    // MARK: - startNotifier

    internal var startNotifierThrowableError: Error?
    internal var startNotifierCallsCount = 0
    internal var startNotifierCalled: Bool {
        return startNotifierCallsCount > 0
    }
    internal var startNotifierClosure: (() throws -> Void)?

    internal func startNotifier() throws {
        startNotifierCallsCount += 1
        if let error = startNotifierThrowableError { throw error }
        try startNotifierClosure?()
    }

    // MARK: - setReachabilityCallback

    internal var setReachabilityCallbackCallbackCallsCount = 0
    internal var setReachabilityCallbackCallbackCalled: Bool {
        return setReachabilityCallbackCallbackCallsCount > 0
    }
    internal var setReachabilityCallbackCallbackReceivedCallback: ((ReachabilityStatus) -> Void)?
    internal var setReachabilityCallbackCallbackClosure: ((@escaping (ReachabilityStatus) -> Void) -> Void)?

    internal func setReachabilityCallback(callback: @escaping (ReachabilityStatus) -> Void) {
        setReachabilityCallbackCallbackCallsCount += 1
        setReachabilityCallbackCallbackReceivedCallback = callback
        setReachabilityCallbackCallbackClosure?(callback)
    }

}
internal class SearchActivityActionPrismProtocolMock: SearchActivityActionPrismProtocol {
    internal var removeDetailedEntityAction: Search.ActivityAction {
        get { return underlyingRemoveDetailedEntityAction }
        set(value) { underlyingRemoveDetailedEntityAction = value }
    }
    internal var underlyingRemoveDetailedEntityAction: Search.ActivityAction!

    // MARK: - detailEntityAction

    internal var detailEntityActionCallsCount = 0
    internal var detailEntityActionCalled: Bool {
        return detailEntityActionCallsCount > 0
    }
    internal var detailEntityActionReceivedEntity: SearchEntityModel?
    internal var detailEntityActionReturnValue: Search.ActivityAction!
    internal var detailEntityActionClosure: ((SearchEntityModel) -> Search.ActivityAction)?

    internal func detailEntityAction(_ entity: SearchEntityModel) -> Search.ActivityAction {
        detailEntityActionCallsCount += 1
        detailEntityActionReceivedEntity = entity
        return detailEntityActionClosure.map({ $0(entity) }) ?? detailEntityActionReturnValue
    }

    // MARK: - initialRequestAction

    internal var initialRequestActionLocationUpdateRequestBlockCallsCount = 0
    internal var initialRequestActionLocationUpdateRequestBlockCalled: Bool {
        return initialRequestActionLocationUpdateRequestBlockCallsCount > 0
    }
    internal var initialRequestActionLocationUpdateRequestBlockReceivedArguments: (searchParams: SearchParams, locationUpdateRequestBlock: LocationUpdateRequestBlock)?
    internal var initialRequestActionLocationUpdateRequestBlockReturnValue: Search.ActivityAction!
    internal var initialRequestActionLocationUpdateRequestBlockClosure: ((SearchParams, @escaping LocationUpdateRequestBlock) -> Search.ActivityAction)?

    internal func initialRequestAction(_ searchParams: SearchParams,
                              locationUpdateRequestBlock: @escaping LocationUpdateRequestBlock) -> Search.ActivityAction {
        initialRequestActionLocationUpdateRequestBlockCallsCount += 1
        initialRequestActionLocationUpdateRequestBlockReceivedArguments = (searchParams: searchParams, locationUpdateRequestBlock: locationUpdateRequestBlock)
        return initialRequestActionLocationUpdateRequestBlockClosure.map({ $0(searchParams, locationUpdateRequestBlock) }) ?? initialRequestActionLocationUpdateRequestBlockReturnValue
    }

    // MARK: - subsequentRequestAction

    internal var subsequentRequestActionAllEntitiesTokenContainerThrowableError: Error?
    internal var subsequentRequestActionAllEntitiesTokenContainerCallsCount = 0
    internal var subsequentRequestActionAllEntitiesTokenContainerCalled: Bool {
        return subsequentRequestActionAllEntitiesTokenContainerCallsCount > 0
    }
    internal var subsequentRequestActionAllEntitiesTokenContainerReceivedArguments: (searchParams: SearchParams, allEntities: NonEmptyArray<SearchEntityModel>, tokenContainer: PlaceLookupTokenAttemptsContainer)?
    internal var subsequentRequestActionAllEntitiesTokenContainerReturnValue: Search.ActivityAction!
    internal var subsequentRequestActionAllEntitiesTokenContainerClosure: ((SearchParams, NonEmptyArray<SearchEntityModel>, PlaceLookupTokenAttemptsContainer) throws -> Search.ActivityAction)?

    internal func subsequentRequestAction(_ searchParams: SearchParams,
                                 allEntities: NonEmptyArray<SearchEntityModel>,
                                 tokenContainer: PlaceLookupTokenAttemptsContainer) throws -> Search.ActivityAction {
        subsequentRequestActionAllEntitiesTokenContainerCallsCount += 1
        subsequentRequestActionAllEntitiesTokenContainerReceivedArguments = (searchParams: searchParams, allEntities: allEntities, tokenContainer: tokenContainer)
        if let error = subsequentRequestActionAllEntitiesTokenContainerThrowableError { throw error }
        return try subsequentRequestActionAllEntitiesTokenContainerClosure.map({ try $0(searchParams, allEntities, tokenContainer) }) ?? subsequentRequestActionAllEntitiesTokenContainerReturnValue
    }

    // MARK: - updateEditingAction

    internal var updateEditingActionCallsCount = 0
    internal var updateEditingActionCalled: Bool {
        return updateEditingActionCallsCount > 0
    }
    internal var updateEditingActionReceivedEditEvent: SearchBarEditEvent?
    internal var updateEditingActionReturnValue: Search.ActivityAction!
    internal var updateEditingActionClosure: ((SearchBarEditEvent) -> Search.ActivityAction)?

    internal func updateEditingAction(_ editEvent: SearchBarEditEvent) -> Search.ActivityAction {
        updateEditingActionCallsCount += 1
        updateEditingActionReceivedEditEvent = editEvent
        return updateEditingActionClosure.map({ $0(editEvent) }) ?? updateEditingActionReturnValue
    }

}
internal class SearchActivityStatePrismProtocolMock: SearchActivityStatePrismProtocol {

    // MARK: - presentationType

    internal var presentationTypeLocationAuthStateReachabilityStateCallsCount = 0
    internal var presentationTypeLocationAuthStateReachabilityStateCalled: Bool {
        return presentationTypeLocationAuthStateReachabilityStateCallsCount > 0
    }
    internal var presentationTypeLocationAuthStateReachabilityStateReceivedArguments: (locationAuthState: LocationAuthState, reachabilityState: ReachabilityState)?
    internal var presentationTypeLocationAuthStateReachabilityStateReturnValue: SearchPresentationType!
    internal var presentationTypeLocationAuthStateReachabilityStateClosure: ((LocationAuthState, ReachabilityState) -> SearchPresentationType)?

    internal func presentationType(locationAuthState: LocationAuthState,
                          reachabilityState: ReachabilityState) -> SearchPresentationType {
        presentationTypeLocationAuthStateReachabilityStateCallsCount += 1
        presentationTypeLocationAuthStateReachabilityStateReceivedArguments = (locationAuthState: locationAuthState, reachabilityState: reachabilityState)
        return presentationTypeLocationAuthStateReachabilityStateClosure.map({ $0(locationAuthState, reachabilityState) }) ?? presentationTypeLocationAuthStateReachabilityStateReturnValue
    }

}
internal class SearchBackgroundViewModelBuilderProtocolMock: SearchBackgroundViewModelBuilderProtocol {

    // MARK: - buildViewModel

    internal var buildViewModelAppCopyContentCallsCount = 0
    internal var buildViewModelAppCopyContentCalled: Bool {
        return buildViewModelAppCopyContentCallsCount > 0
    }
    internal var buildViewModelAppCopyContentReceivedArguments: (keywords: NonEmptyString?, appCopyContent: AppCopyContent)?
    internal var buildViewModelAppCopyContentReturnValue: SearchBackgroundViewModel!
    internal var buildViewModelAppCopyContentClosure: ((NonEmptyString?, AppCopyContent) -> SearchBackgroundViewModel)?

    internal func buildViewModel(_ keywords: NonEmptyString?,
                        appCopyContent: AppCopyContent) -> SearchBackgroundViewModel {
        buildViewModelAppCopyContentCallsCount += 1
        buildViewModelAppCopyContentReceivedArguments = (keywords: keywords, appCopyContent: appCopyContent)
        return buildViewModelAppCopyContentClosure.map({ $0(keywords, appCopyContent) }) ?? buildViewModelAppCopyContentReturnValue
    }

}
internal class SearchCopyFormatterProtocolMock: SearchCopyFormatterProtocol {

    // MARK: - formatAddress

    internal var formatAddressCallsCount = 0
    internal var formatAddressCalled: Bool {
        return formatAddressCallsCount > 0
    }
    internal var formatAddressReceivedAddress: PlaceLookupAddressLines?
    internal var formatAddressReturnValue: NonEmptyString!
    internal var formatAddressClosure: ((PlaceLookupAddressLines) -> NonEmptyString)?

    internal func formatAddress(_ address: PlaceLookupAddressLines) -> NonEmptyString {
        formatAddressCallsCount += 1
        formatAddressReceivedAddress = address
        return formatAddressClosure.map({ $0(address) }) ?? formatAddressReturnValue
    }

    // MARK: - formatCallablePhoneNumber

    internal var formatCallablePhoneNumberDisplayPhoneCallsCount = 0
    internal var formatCallablePhoneNumberDisplayPhoneCalled: Bool {
        return formatCallablePhoneNumberDisplayPhoneCallsCount > 0
    }
    internal var formatCallablePhoneNumberDisplayPhoneReceivedArguments: (resultsCopyContent: SearchResultsCopyContent, displayPhone: NonEmptyString)?
    internal var formatCallablePhoneNumberDisplayPhoneReturnValue: String!
    internal var formatCallablePhoneNumberDisplayPhoneClosure: ((SearchResultsCopyContent, NonEmptyString) -> String)?

    internal func formatCallablePhoneNumber(_ resultsCopyContent: SearchResultsCopyContent,
                                   displayPhone: NonEmptyString) -> String {
        formatCallablePhoneNumberDisplayPhoneCallsCount += 1
        formatCallablePhoneNumberDisplayPhoneReceivedArguments = (resultsCopyContent: resultsCopyContent, displayPhone: displayPhone)
        return formatCallablePhoneNumberDisplayPhoneClosure.map({ $0(resultsCopyContent, displayPhone) }) ?? formatCallablePhoneNumberDisplayPhoneReturnValue
    }

    // MARK: - formatNonCallablePhoneNumber

    internal var formatNonCallablePhoneNumberCallsCount = 0
    internal var formatNonCallablePhoneNumberCalled: Bool {
        return formatNonCallablePhoneNumberCallsCount > 0
    }
    internal var formatNonCallablePhoneNumberReceivedDisplayPhone: NonEmptyString?
    internal var formatNonCallablePhoneNumberReturnValue: String!
    internal var formatNonCallablePhoneNumberClosure: ((NonEmptyString) -> String)?

    internal func formatNonCallablePhoneNumber(_ displayPhone: NonEmptyString) -> String {
        formatNonCallablePhoneNumberCallsCount += 1
        formatNonCallablePhoneNumberReceivedDisplayPhone = displayPhone
        return formatNonCallablePhoneNumberClosure.map({ $0(displayPhone) }) ?? formatNonCallablePhoneNumberReturnValue
    }

    // MARK: - formatRatings

    internal var formatRatingsNumRatingsCallsCount = 0
    internal var formatRatingsNumRatingsCalled: Bool {
        return formatRatingsNumRatingsCallsCount > 0
    }
    internal var formatRatingsNumRatingsReceivedArguments: (resultsCopyContent: SearchResultsCopyContent, numRatings: Int)?
    internal var formatRatingsNumRatingsReturnValue: String!
    internal var formatRatingsNumRatingsClosure: ((SearchResultsCopyContent, Int) -> String)?

    internal func formatRatings(_ resultsCopyContent: SearchResultsCopyContent,
                       numRatings: Int) -> String {
        formatRatingsNumRatingsCallsCount += 1
        formatRatingsNumRatingsReceivedArguments = (resultsCopyContent: resultsCopyContent, numRatings: numRatings)
        return formatRatingsNumRatingsClosure.map({ $0(resultsCopyContent, numRatings) }) ?? formatRatingsNumRatingsReturnValue
    }

    // MARK: - formatPricing

    internal var formatPricingPricingCallsCount = 0
    internal var formatPricingPricingCalled: Bool {
        return formatPricingPricingCallsCount > 0
    }
    internal var formatPricingPricingReceivedArguments: (resultsCopyContent: SearchResultsCopyContent, pricing: PlaceLookupPricing)?
    internal var formatPricingPricingReturnValue: String!
    internal var formatPricingPricingClosure: ((SearchResultsCopyContent, PlaceLookupPricing) -> String)?

    internal func formatPricing(_ resultsCopyContent: SearchResultsCopyContent,
                       pricing: PlaceLookupPricing) -> String {
        formatPricingPricingCallsCount += 1
        formatPricingPricingReceivedArguments = (resultsCopyContent: resultsCopyContent, pricing: pricing)
        return formatPricingPricingClosure.map({ $0(resultsCopyContent, pricing) }) ?? formatPricingPricingReturnValue
    }

}
internal class SearchDetailsViewContextBuilderProtocolMock: SearchDetailsViewContextBuilderProtocol {

    // MARK: - buildViewContext

    internal var buildViewContextAppCopyContentCallsCount = 0
    internal var buildViewContextAppCopyContentCalled: Bool {
        return buildViewContextAppCopyContentCallsCount > 0
    }
    internal var buildViewContextAppCopyContentReceivedArguments: (searchActivityState: Search.ActivityState, appCopyContent: AppCopyContent)?
    internal var buildViewContextAppCopyContentReturnValue: SearchDetailsViewContext?
    internal var buildViewContextAppCopyContentClosure: ((Search.ActivityState, AppCopyContent) -> SearchDetailsViewContext?)?

    internal func buildViewContext(_ searchActivityState: Search.ActivityState,
                          appCopyContent: AppCopyContent) -> SearchDetailsViewContext? {
        buildViewContextAppCopyContentCallsCount += 1
        buildViewContextAppCopyContentReceivedArguments = (searchActivityState: searchActivityState, appCopyContent: appCopyContent)
        return buildViewContextAppCopyContentClosure.map({ $0(searchActivityState, appCopyContent) }) ?? buildViewContextAppCopyContentReturnValue
    }

}
internal class SearchDetailsViewModelBuilderProtocolMock: SearchDetailsViewModelBuilderProtocol {

    // MARK: - buildViewModel

    internal var buildViewModelResultsCopyContentCallsCount = 0
    internal var buildViewModelResultsCopyContentCalled: Bool {
        return buildViewModelResultsCopyContentCallsCount > 0
    }
    internal var buildViewModelResultsCopyContentReceivedArguments: (entity: SearchEntityModel, resultsCopyContent: SearchResultsCopyContent)?
    internal var buildViewModelResultsCopyContentReturnValue: SearchDetailsViewModel!
    internal var buildViewModelResultsCopyContentClosure: ((SearchEntityModel, SearchResultsCopyContent) -> SearchDetailsViewModel)?

    internal func buildViewModel(_ entity: SearchEntityModel,
                        resultsCopyContent: SearchResultsCopyContent) -> SearchDetailsViewModel {
        buildViewModelResultsCopyContentCallsCount += 1
        buildViewModelResultsCopyContentReceivedArguments = (entity: entity, resultsCopyContent: resultsCopyContent)
        return buildViewModelResultsCopyContentClosure.map({ $0(entity, resultsCopyContent) }) ?? buildViewModelResultsCopyContentReturnValue
    }

}
internal class SearchEntityModelBuilderProtocolMock: SearchEntityModelBuilderProtocol {

    // MARK: - buildEntityModels

    internal var buildEntityModelsCallsCount = 0
    internal var buildEntityModelsCalled: Bool {
        return buildEntityModelsCallsCount > 0
    }
    internal var buildEntityModelsReceivedEntities: [PlaceLookupEntity]?
    internal var buildEntityModelsReturnValue: [SearchEntityModel]!
    internal var buildEntityModelsClosure: (([PlaceLookupEntity]) -> [SearchEntityModel])?

    internal func buildEntityModels(_ entities: [PlaceLookupEntity]) -> [SearchEntityModel] {
        buildEntityModelsCallsCount += 1
        buildEntityModelsReceivedEntities = entities
        return buildEntityModelsClosure.map({ $0(entities) }) ?? buildEntityModelsReturnValue
    }

    // MARK: - buildEntityModel

    internal var buildEntityModelCallsCount = 0
    internal var buildEntityModelCalled: Bool {
        return buildEntityModelCallsCount > 0
    }
    internal var buildEntityModelReceivedEntity: PlaceLookupEntity?
    internal var buildEntityModelReturnValue: SearchEntityModel?
    internal var buildEntityModelClosure: ((PlaceLookupEntity) -> SearchEntityModel?)?

    internal func buildEntityModel(_ entity: PlaceLookupEntity) -> SearchEntityModel? {
        buildEntityModelCallsCount += 1
        buildEntityModelReceivedEntity = entity
        return buildEntityModelClosure.map({ $0(entity) }) ?? buildEntityModelReturnValue
    }

}
internal class SearchInputContentViewModelBuilderProtocolMock: SearchInputContentViewModelBuilderProtocol {

    // MARK: - buildViewModel

    internal var buildViewModelKeywordsIsEditingCopyContentCallsCount = 0
    internal var buildViewModelKeywordsIsEditingCopyContentCalled: Bool {
        return buildViewModelKeywordsIsEditingCopyContentCallsCount > 0
    }
    internal var buildViewModelKeywordsIsEditingCopyContentReceivedArguments: (keywords: NonEmptyString?, isEditing: Bool, copyContent: SearchInputCopyContent)?
    internal var buildViewModelKeywordsIsEditingCopyContentReturnValue: SearchInputContentViewModel!
    internal var buildViewModelKeywordsIsEditingCopyContentClosure: ((NonEmptyString?, Bool, SearchInputCopyContent) -> SearchInputContentViewModel)?

    internal func buildViewModel(keywords: NonEmptyString?,
                        isEditing: Bool,
                        copyContent: SearchInputCopyContent) -> SearchInputContentViewModel {
        buildViewModelKeywordsIsEditingCopyContentCallsCount += 1
        buildViewModelKeywordsIsEditingCopyContentReceivedArguments = (keywords: keywords, isEditing: isEditing, copyContent: copyContent)
        return buildViewModelKeywordsIsEditingCopyContentClosure.map({ $0(keywords, isEditing, copyContent) }) ?? buildViewModelKeywordsIsEditingCopyContentReturnValue
    }

}
internal class SearchInputViewModelBuilderProtocolMock: SearchInputViewModelBuilderProtocol {

    // MARK: - buildDispatchingViewModel

    internal var buildDispatchingViewModelCopyContentLocationUpdateRequestBlockCallsCount = 0
    internal var buildDispatchingViewModelCopyContentLocationUpdateRequestBlockCalled: Bool {
        return buildDispatchingViewModelCopyContentLocationUpdateRequestBlockCallsCount > 0
    }
    internal var buildDispatchingViewModelCopyContentLocationUpdateRequestBlockReceivedArguments: (inputParams: SearchInputParams, copyContent: SearchInputCopyContent, locationUpdateRequestBlock: LocationUpdateRequestBlock)?
    internal var buildDispatchingViewModelCopyContentLocationUpdateRequestBlockReturnValue: SearchInputViewModel!
    internal var buildDispatchingViewModelCopyContentLocationUpdateRequestBlockClosure: ((SearchInputParams, SearchInputCopyContent, @escaping LocationUpdateRequestBlock) -> SearchInputViewModel)?

    internal func buildDispatchingViewModel(
        _ inputParams: SearchInputParams,
        copyContent: SearchInputCopyContent,
        locationUpdateRequestBlock: @escaping LocationUpdateRequestBlock
    ) -> SearchInputViewModel {
        buildDispatchingViewModelCopyContentLocationUpdateRequestBlockCallsCount += 1
        buildDispatchingViewModelCopyContentLocationUpdateRequestBlockReceivedArguments = (inputParams: inputParams, copyContent: copyContent, locationUpdateRequestBlock: locationUpdateRequestBlock)
        return buildDispatchingViewModelCopyContentLocationUpdateRequestBlockClosure.map({ $0(inputParams, copyContent, locationUpdateRequestBlock) }) ?? buildDispatchingViewModelCopyContentLocationUpdateRequestBlockReturnValue
    }

}
internal class SearchInstructionsViewModelBuilderProtocolMock: SearchInstructionsViewModelBuilderProtocol {

    // MARK: - buildViewModel

    internal var buildViewModelCopyContentCallsCount = 0
    internal var buildViewModelCopyContentCalled: Bool {
        return buildViewModelCopyContentCallsCount > 0
    }
    internal var buildViewModelCopyContentReceivedCopyContent: SearchInstructionsCopyContent?
    internal var buildViewModelCopyContentReturnValue: SearchInstructionsViewModel!
    internal var buildViewModelCopyContentClosure: ((SearchInstructionsCopyContent) -> SearchInstructionsViewModel)?

    internal func buildViewModel(copyContent: SearchInstructionsCopyContent) -> SearchInstructionsViewModel {
        buildViewModelCopyContentCallsCount += 1
        buildViewModelCopyContentReceivedCopyContent = copyContent
        return buildViewModelCopyContentClosure.map({ $0(copyContent) }) ?? buildViewModelCopyContentReturnValue
    }

}
internal class SearchLookupChildBuilderProtocolMock: SearchLookupChildBuilderProtocol {

    // MARK: - buildChild

    internal var buildChildAppCopyContentLocationUpdateRequestBlockCallsCount = 0
    internal var buildChildAppCopyContentLocationUpdateRequestBlockCalled: Bool {
        return buildChildAppCopyContentLocationUpdateRequestBlockCallsCount > 0
    }
    internal var buildChildAppCopyContentLocationUpdateRequestBlockReceivedArguments: (loadState: Search.LoadState, appCopyContent: AppCopyContent, locationUpdateRequestBlock: LocationUpdateRequestBlock)?
    internal var buildChildAppCopyContentLocationUpdateRequestBlockReturnValue: SearchLookupChild!
    internal var buildChildAppCopyContentLocationUpdateRequestBlockClosure: ((Search.LoadState, AppCopyContent, @escaping LocationUpdateRequestBlock) -> SearchLookupChild)?

    internal func buildChild(_ loadState: Search.LoadState,
                    appCopyContent: AppCopyContent,
                    locationUpdateRequestBlock: @escaping LocationUpdateRequestBlock) -> SearchLookupChild {
        buildChildAppCopyContentLocationUpdateRequestBlockCallsCount += 1
        buildChildAppCopyContentLocationUpdateRequestBlockReceivedArguments = (loadState: loadState, appCopyContent: appCopyContent, locationUpdateRequestBlock: locationUpdateRequestBlock)
        return buildChildAppCopyContentLocationUpdateRequestBlockClosure.map({ $0(loadState, appCopyContent, locationUpdateRequestBlock) }) ?? buildChildAppCopyContentLocationUpdateRequestBlockReturnValue
    }

}
internal class SearchLookupViewModelBuilderProtocolMock: SearchLookupViewModelBuilderProtocol {

    // MARK: - buildViewModel

    internal var buildViewModelAppCopyContentLocationUpdateRequestBlockCallsCount = 0
    internal var buildViewModelAppCopyContentLocationUpdateRequestBlockCalled: Bool {
        return buildViewModelAppCopyContentLocationUpdateRequestBlockCallsCount > 0
    }
    internal var buildViewModelAppCopyContentLocationUpdateRequestBlockReceivedArguments: (searchActivityState: Search.ActivityState, appCopyContent: AppCopyContent, locationUpdateRequestBlock: LocationUpdateRequestBlock)?
    internal var buildViewModelAppCopyContentLocationUpdateRequestBlockReturnValue: SearchLookupViewModel!
    internal var buildViewModelAppCopyContentLocationUpdateRequestBlockClosure: ((Search.ActivityState, AppCopyContent, @escaping LocationUpdateRequestBlock) -> SearchLookupViewModel)?

    internal func buildViewModel(_ searchActivityState: Search.ActivityState,
                        appCopyContent: AppCopyContent,
                        locationUpdateRequestBlock: @escaping LocationUpdateRequestBlock) -> SearchLookupViewModel {
        buildViewModelAppCopyContentLocationUpdateRequestBlockCallsCount += 1
        buildViewModelAppCopyContentLocationUpdateRequestBlockReceivedArguments = (searchActivityState: searchActivityState, appCopyContent: appCopyContent, locationUpdateRequestBlock: locationUpdateRequestBlock)
        return buildViewModelAppCopyContentLocationUpdateRequestBlockClosure.map({ $0(searchActivityState, appCopyContent, locationUpdateRequestBlock) }) ?? buildViewModelAppCopyContentLocationUpdateRequestBlockReturnValue
    }

}
internal class SearchNoResultsFoundViewModelBuilderProtocolMock: SearchNoResultsFoundViewModelBuilderProtocol {

    // MARK: - buildViewModel

    internal var buildViewModelCallsCount = 0
    internal var buildViewModelCalled: Bool {
        return buildViewModelCallsCount > 0
    }
    internal var buildViewModelReceivedCopyContent: SearchNoResultsCopyContent?
    internal var buildViewModelReturnValue: SearchNoResultsFoundViewModel!
    internal var buildViewModelClosure: ((SearchNoResultsCopyContent) -> SearchNoResultsFoundViewModel)?

    internal func buildViewModel(_ copyContent: SearchNoResultsCopyContent) -> SearchNoResultsFoundViewModel {
        buildViewModelCallsCount += 1
        buildViewModelReceivedCopyContent = copyContent
        return buildViewModelClosure.map({ $0(copyContent) }) ?? buildViewModelReturnValue
    }

}
internal class SearchPresenterProtocolMock: SearchPresenterProtocol {
    internal var rootViewController: UIViewController {
        get { return underlyingRootViewController }
        set(value) { underlyingRootViewController = value }
    }
    internal var underlyingRootViewController: UIViewController!

    // MARK: - loadNoInternetViews

    internal var loadNoInternetViewsTitleViewModelAppSkinCallsCount = 0
    internal var loadNoInternetViewsTitleViewModelAppSkinCalled: Bool {
        return loadNoInternetViewsTitleViewModelAppSkinCallsCount > 0
    }
    internal var loadNoInternetViewsTitleViewModelAppSkinReceivedArguments: (viewModel: SearchNoInternetViewModel, titleViewModel: NavigationBarTitleViewModel, appSkin: AppSkin)?
    internal var loadNoInternetViewsTitleViewModelAppSkinClosure: ((SearchNoInternetViewModel, NavigationBarTitleViewModel, AppSkin) -> Void)?

    internal func loadNoInternetViews(_ viewModel: SearchNoInternetViewModel,
                             titleViewModel: NavigationBarTitleViewModel,
                             appSkin: AppSkin) {
        loadNoInternetViewsTitleViewModelAppSkinCallsCount += 1
        loadNoInternetViewsTitleViewModelAppSkinReceivedArguments = (viewModel: viewModel, titleViewModel: titleViewModel, appSkin: appSkin)
        loadNoInternetViewsTitleViewModelAppSkinClosure?(viewModel, titleViewModel, appSkin)
    }

    // MARK: - loadLocationServicesDisabledViews

    internal var loadLocationServicesDisabledViewsTitleViewModelAppSkinCallsCount = 0
    internal var loadLocationServicesDisabledViewsTitleViewModelAppSkinCalled: Bool {
        return loadLocationServicesDisabledViewsTitleViewModelAppSkinCallsCount > 0
    }
    internal var loadLocationServicesDisabledViewsTitleViewModelAppSkinReceivedArguments: (viewModel: SearchLocationDisabledViewModel, titleViewModel: NavigationBarTitleViewModel, appSkin: AppSkin)?
    internal var loadLocationServicesDisabledViewsTitleViewModelAppSkinClosure: ((SearchLocationDisabledViewModel, NavigationBarTitleViewModel, AppSkin) -> Void)?

    internal func loadLocationServicesDisabledViews(_ viewModel: SearchLocationDisabledViewModel,
                                           titleViewModel: NavigationBarTitleViewModel,
                                           appSkin: AppSkin) {
        loadLocationServicesDisabledViewsTitleViewModelAppSkinCallsCount += 1
        loadLocationServicesDisabledViewsTitleViewModelAppSkinReceivedArguments = (viewModel: viewModel, titleViewModel: titleViewModel, appSkin: appSkin)
        loadLocationServicesDisabledViewsTitleViewModelAppSkinClosure?(viewModel, titleViewModel, appSkin)
    }

    // MARK: - loadSearchBackgroundView

    internal var loadSearchBackgroundViewTitleViewModelAppSkinCallsCount = 0
    internal var loadSearchBackgroundViewTitleViewModelAppSkinCalled: Bool {
        return loadSearchBackgroundViewTitleViewModelAppSkinCallsCount > 0
    }
    internal var loadSearchBackgroundViewTitleViewModelAppSkinReceivedArguments: (viewModel: SearchBackgroundViewModel, titleViewModel: NavigationBarTitleViewModel, appSkin: AppSkin)?
    internal var loadSearchBackgroundViewTitleViewModelAppSkinClosure: ((SearchBackgroundViewModel, NavigationBarTitleViewModel, AppSkin) -> Void)?

    internal func loadSearchBackgroundView(_ viewModel: SearchBackgroundViewModel,
                                  titleViewModel: NavigationBarTitleViewModel,
                                  appSkin: AppSkin) {
        loadSearchBackgroundViewTitleViewModelAppSkinCallsCount += 1
        loadSearchBackgroundViewTitleViewModelAppSkinReceivedArguments = (viewModel: viewModel, titleViewModel: titleViewModel, appSkin: appSkin)
        loadSearchBackgroundViewTitleViewModelAppSkinClosure?(viewModel, titleViewModel, appSkin)
    }

    // MARK: - loadSearchViews

    internal var loadSearchViewsDetailsViewContextTitleViewModelAppSkinCallsCount = 0
    internal var loadSearchViewsDetailsViewContextTitleViewModelAppSkinCalled: Bool {
        return loadSearchViewsDetailsViewContextTitleViewModelAppSkinCallsCount > 0
    }
    internal var loadSearchViewsDetailsViewContextTitleViewModelAppSkinReceivedArguments: (viewModel: SearchLookupViewModel, detailsViewContext: SearchDetailsViewContext?, titleViewModel: NavigationBarTitleViewModel, appSkin: AppSkin)?
    internal var loadSearchViewsDetailsViewContextTitleViewModelAppSkinClosure: ((SearchLookupViewModel, SearchDetailsViewContext?, NavigationBarTitleViewModel, AppSkin) -> Void)?

    internal func loadSearchViews(_ viewModel: SearchLookupViewModel,
                         detailsViewContext: SearchDetailsViewContext?,
                         titleViewModel: NavigationBarTitleViewModel,
                         appSkin: AppSkin) {
        loadSearchViewsDetailsViewContextTitleViewModelAppSkinCallsCount += 1
        loadSearchViewsDetailsViewContextTitleViewModelAppSkinReceivedArguments = (viewModel: viewModel, detailsViewContext: detailsViewContext, titleViewModel: titleViewModel, appSkin: appSkin)
        loadSearchViewsDetailsViewContextTitleViewModelAppSkinClosure?(viewModel, detailsViewContext, titleViewModel, appSkin)
    }

}
internal class SearchResultCellModelBuilderProtocolMock: SearchResultCellModelBuilderProtocol {

    // MARK: - buildViewModel

    internal var buildViewModelResultsCopyContentCallsCount = 0
    internal var buildViewModelResultsCopyContentCalled: Bool {
        return buildViewModelResultsCopyContentCallsCount > 0
    }
    internal var buildViewModelResultsCopyContentReceivedArguments: (model: SearchEntityModel, resultsCopyContent: SearchResultsCopyContent)?
    internal var buildViewModelResultsCopyContentReturnValue: SearchResultCellModel!
    internal var buildViewModelResultsCopyContentClosure: ((SearchEntityModel, SearchResultsCopyContent) -> SearchResultCellModel)?

    internal func buildViewModel(_ model: SearchEntityModel,
                        resultsCopyContent: SearchResultsCopyContent) -> SearchResultCellModel {
        buildViewModelResultsCopyContentCallsCount += 1
        buildViewModelResultsCopyContentReceivedArguments = (model: model, resultsCopyContent: resultsCopyContent)
        return buildViewModelResultsCopyContentClosure.map({ $0(model, resultsCopyContent) }) ?? buildViewModelResultsCopyContentReturnValue
    }

}
internal class SearchResultViewModelBuilderProtocolMock: SearchResultViewModelBuilderProtocol {

    // MARK: - buildViewModel

    internal var buildViewModelResultsCopyContentCallsCount = 0
    internal var buildViewModelResultsCopyContentCalled: Bool {
        return buildViewModelResultsCopyContentCallsCount > 0
    }
    internal var buildViewModelResultsCopyContentReceivedArguments: (model: SearchEntityModel, resultsCopyContent: SearchResultsCopyContent)?
    internal var buildViewModelResultsCopyContentReturnValue: SearchResultViewModel!
    internal var buildViewModelResultsCopyContentClosure: ((SearchEntityModel, SearchResultsCopyContent) -> SearchResultViewModel)?

    internal func buildViewModel(_ model: SearchEntityModel,
                        resultsCopyContent: SearchResultsCopyContent) -> SearchResultViewModel {
        buildViewModelResultsCopyContentCallsCount += 1
        buildViewModelResultsCopyContentReceivedArguments = (model: model, resultsCopyContent: resultsCopyContent)
        return buildViewModelResultsCopyContentClosure.map({ $0(model, resultsCopyContent) }) ?? buildViewModelResultsCopyContentReturnValue
    }

}
internal class SearchResultsViewModelBuilderProtocolMock: SearchResultsViewModelBuilderProtocol {

    // MARK: - buildViewModel

    internal var buildViewModelSubmittedParamsAllEntitiesTokenContainerResultsCopyContentActionSubscriberLocationUpdateRequestBlockCallsCount = 0
    internal var buildViewModelSubmittedParamsAllEntitiesTokenContainerResultsCopyContentActionSubscriberLocationUpdateRequestBlockCalled: Bool {
        return buildViewModelSubmittedParamsAllEntitiesTokenContainerResultsCopyContentActionSubscriberLocationUpdateRequestBlockCallsCount > 0
    }
    internal var buildViewModelSubmittedParamsAllEntitiesTokenContainerResultsCopyContentActionSubscriberLocationUpdateRequestBlockReceivedArguments: (submittedParams: SearchParams, allEntities: NonEmptyArray<SearchEntityModel>, tokenContainer: PlaceLookupTokenAttemptsContainer?, resultsCopyContent: SearchResultsCopyContent, actionSubscriber: AnySubscriber<Search.Action, Never>, locationUpdateRequestBlock: LocationUpdateRequestBlock)?
    internal var buildViewModelSubmittedParamsAllEntitiesTokenContainerResultsCopyContentActionSubscriberLocationUpdateRequestBlockReturnValue: SearchResultsViewModel!
    internal var buildViewModelSubmittedParamsAllEntitiesTokenContainerResultsCopyContentActionSubscriberLocationUpdateRequestBlockClosure: ((SearchParams, NonEmptyArray<SearchEntityModel>, PlaceLookupTokenAttemptsContainer?, SearchResultsCopyContent, AnySubscriber<Search.Action, Never>, @escaping LocationUpdateRequestBlock) -> SearchResultsViewModel)?

    internal func buildViewModel(submittedParams: SearchParams,
                        allEntities: NonEmptyArray<SearchEntityModel>,
                        tokenContainer: PlaceLookupTokenAttemptsContainer?,
                        resultsCopyContent: SearchResultsCopyContent,
                        actionSubscriber: AnySubscriber<Search.Action, Never>,
                        locationUpdateRequestBlock: @escaping LocationUpdateRequestBlock) -> SearchResultsViewModel {
        buildViewModelSubmittedParamsAllEntitiesTokenContainerResultsCopyContentActionSubscriberLocationUpdateRequestBlockCallsCount += 1
        buildViewModelSubmittedParamsAllEntitiesTokenContainerResultsCopyContentActionSubscriberLocationUpdateRequestBlockReceivedArguments = (submittedParams: submittedParams, allEntities: allEntities, tokenContainer: tokenContainer, resultsCopyContent: resultsCopyContent, actionSubscriber: actionSubscriber, locationUpdateRequestBlock: locationUpdateRequestBlock)
        return buildViewModelSubmittedParamsAllEntitiesTokenContainerResultsCopyContentActionSubscriberLocationUpdateRequestBlockClosure.map({ $0(submittedParams, allEntities, tokenContainer, resultsCopyContent, actionSubscriber, locationUpdateRequestBlock) }) ?? buildViewModelSubmittedParamsAllEntitiesTokenContainerResultsCopyContentActionSubscriberLocationUpdateRequestBlockReturnValue
    }

}
internal class SearchRetryViewModelBuilderProtocolMock: SearchRetryViewModelBuilderProtocol {

    // MARK: - buildViewModel

    internal var buildViewModelCtaBlockCallsCount = 0
    internal var buildViewModelCtaBlockCalled: Bool {
        return buildViewModelCtaBlockCallsCount > 0
    }
    internal var buildViewModelCtaBlockReceivedArguments: (copyContent: SearchRetryCopyContent, ctaBlock: SearchCTABlock)?
    internal var buildViewModelCtaBlockReturnValue: SearchRetryViewModel!
    internal var buildViewModelCtaBlockClosure: ((SearchRetryCopyContent, @escaping SearchCTABlock) -> SearchRetryViewModel)?

    internal func buildViewModel(_ copyContent: SearchRetryCopyContent,
                        ctaBlock: @escaping SearchCTABlock) -> SearchRetryViewModel {
        buildViewModelCtaBlockCallsCount += 1
        buildViewModelCtaBlockReceivedArguments = (copyContent: copyContent, ctaBlock: ctaBlock)
        return buildViewModelCtaBlockClosure.map({ $0(copyContent, ctaBlock) }) ?? buildViewModelCtaBlockReturnValue
    }

}
internal class SettingsCellViewModelBuilderProtocolMock: SettingsCellViewModelBuilderProtocol {

    // MARK: - buildDistanceCellModels

    internal var buildDistanceCellModelsCallsCount = 0
    internal var buildDistanceCellModelsCalled: Bool {
        return buildDistanceCellModelsCallsCount > 0
    }
    internal var buildDistanceCellModelsReceivedDistance: SearchDistance?
    internal var buildDistanceCellModelsReturnValue: [SettingsCellViewModel]!
    internal var buildDistanceCellModelsClosure: ((SearchDistance) -> [SettingsCellViewModel])?

    internal func buildDistanceCellModels(_ distance: SearchDistance) -> [SettingsCellViewModel] {
        buildDistanceCellModelsCallsCount += 1
        buildDistanceCellModelsReceivedDistance = distance
        return buildDistanceCellModelsClosure.map({ $0(distance) }) ?? buildDistanceCellModelsReturnValue
    }

    // MARK: - buildSortingCellModels

    internal var buildSortingCellModelsCopyContentCallsCount = 0
    internal var buildSortingCellModelsCopyContentCalled: Bool {
        return buildSortingCellModelsCopyContentCallsCount > 0
    }
    internal var buildSortingCellModelsCopyContentReceivedArguments: (sorting: PlaceLookupSorting, copyContent: SettingsSortPreferenceCopyContent)?
    internal var buildSortingCellModelsCopyContentReturnValue: [SettingsCellViewModel]!
    internal var buildSortingCellModelsCopyContentClosure: ((PlaceLookupSorting, SettingsSortPreferenceCopyContent) -> [SettingsCellViewModel])?

    internal func buildSortingCellModels(_ sorting: PlaceLookupSorting,
                                copyContent: SettingsSortPreferenceCopyContent) -> [SettingsCellViewModel] {
        buildSortingCellModelsCopyContentCallsCount += 1
        buildSortingCellModelsCopyContentReceivedArguments = (sorting: sorting, copyContent: copyContent)
        return buildSortingCellModelsCopyContentClosure.map({ $0(sorting, copyContent) }) ?? buildSortingCellModelsCopyContentReturnValue
    }

}
internal class SettingsPlainHeaderViewModelBuilderProtocolMock: SettingsPlainHeaderViewModelBuilderProtocol {

    // MARK: - buildViewModel

    internal var buildViewModelCallsCount = 0
    internal var buildViewModelCalled: Bool {
        return buildViewModelCallsCount > 0
    }
    internal var buildViewModelReceivedTitle: String?
    internal var buildViewModelReturnValue: SettingsPlainHeaderViewModel!
    internal var buildViewModelClosure: ((String) -> SettingsPlainHeaderViewModel)?

    internal func buildViewModel(_ title: String) -> SettingsPlainHeaderViewModel {
        buildViewModelCallsCount += 1
        buildViewModelReceivedTitle = title
        return buildViewModelClosure.map({ $0(title) }) ?? buildViewModelReturnValue
    }

}
internal class SettingsPresenterProtocolMock: SettingsPresenterProtocol {
    internal var rootNavController: UINavigationController {
        get { return underlyingRootNavController }
        set(value) { underlyingRootNavController = value }
    }
    internal var underlyingRootNavController: UINavigationController!

    // MARK: - loadSettingsView

    internal var loadSettingsViewTitleViewModelAppSkinCallsCount = 0
    internal var loadSettingsViewTitleViewModelAppSkinCalled: Bool {
        return loadSettingsViewTitleViewModelAppSkinCallsCount > 0
    }
    internal var loadSettingsViewTitleViewModelAppSkinReceivedArguments: (viewModel: SettingsViewModel, titleViewModel: NavigationBarTitleViewModel, appSkin: AppSkin)?
    internal var loadSettingsViewTitleViewModelAppSkinClosure: ((SettingsViewModel, NavigationBarTitleViewModel, AppSkin) -> Void)?

    internal func loadSettingsView(_ viewModel: SettingsViewModel,
                          titleViewModel: NavigationBarTitleViewModel,
                          appSkin: AppSkin) {
        loadSettingsViewTitleViewModelAppSkinCallsCount += 1
        loadSettingsViewTitleViewModelAppSkinReceivedArguments = (viewModel: viewModel, titleViewModel: titleViewModel, appSkin: appSkin)
        loadSettingsViewTitleViewModelAppSkinClosure?(viewModel, titleViewModel, appSkin)
    }

}
internal class SettingsUnitsHeaderViewModelBuilderProtocolMock: SettingsUnitsHeaderViewModelBuilderProtocol {

    // MARK: - buildViewModel

    internal var buildViewModelCurrentlyActiveSystemCopyContentCallsCount = 0
    internal var buildViewModelCurrentlyActiveSystemCopyContentCalled: Bool {
        return buildViewModelCurrentlyActiveSystemCopyContentCallsCount > 0
    }
    internal var buildViewModelCurrentlyActiveSystemCopyContentReceivedArguments: (title: String, currentlyActiveSystem: MeasurementSystem, copyContent: SettingsMeasurementSystemCopyContent)?
    internal var buildViewModelCurrentlyActiveSystemCopyContentReturnValue: SettingsUnitsHeaderViewModel!
    internal var buildViewModelCurrentlyActiveSystemCopyContentClosure: ((String, MeasurementSystem, SettingsMeasurementSystemCopyContent) -> SettingsUnitsHeaderViewModel)?

    internal func buildViewModel(_ title: String,
                        currentlyActiveSystem: MeasurementSystem,
                        copyContent: SettingsMeasurementSystemCopyContent) -> SettingsUnitsHeaderViewModel {
        buildViewModelCurrentlyActiveSystemCopyContentCallsCount += 1
        buildViewModelCurrentlyActiveSystemCopyContentReceivedArguments = (title: title, currentlyActiveSystem: currentlyActiveSystem, copyContent: copyContent)
        return buildViewModelCurrentlyActiveSystemCopyContentClosure.map({ $0(title, currentlyActiveSystem, copyContent) }) ?? buildViewModelCurrentlyActiveSystemCopyContentReturnValue
    }

}
internal class SettingsViewModelBuilderProtocolMock: SettingsViewModelBuilderProtocol {

    // MARK: - buildViewModel

    internal var buildViewModelSearchPreferencesStateAppCopyContentSettingsChildRequestActionCallsCount = 0
    internal var buildViewModelSearchPreferencesStateAppCopyContentSettingsChildRequestActionCalled: Bool {
        return buildViewModelSearchPreferencesStateAppCopyContentSettingsChildRequestActionCallsCount > 0
    }
    internal var buildViewModelSearchPreferencesStateAppCopyContentSettingsChildRequestActionReceivedArguments: (searchPreferencesState: SearchPreferencesState, appCopyContent: AppCopyContent, settingsChildRequestAction: AppAction)?
    internal var buildViewModelSearchPreferencesStateAppCopyContentSettingsChildRequestActionReturnValue: SettingsViewModel!
    internal var buildViewModelSearchPreferencesStateAppCopyContentSettingsChildRequestActionClosure: ((SearchPreferencesState, AppCopyContent, AppAction) -> SettingsViewModel)?

    internal func buildViewModel(searchPreferencesState: SearchPreferencesState,
                        appCopyContent: AppCopyContent,
                        settingsChildRequestAction: AppAction) -> SettingsViewModel {
        buildViewModelSearchPreferencesStateAppCopyContentSettingsChildRequestActionCallsCount += 1
        buildViewModelSearchPreferencesStateAppCopyContentSettingsChildRequestActionReceivedArguments = (searchPreferencesState: searchPreferencesState, appCopyContent: appCopyContent, settingsChildRequestAction: settingsChildRequestAction)
        return buildViewModelSearchPreferencesStateAppCopyContentSettingsChildRequestActionClosure.map({ $0(searchPreferencesState, appCopyContent, settingsChildRequestAction) }) ?? buildViewModelSearchPreferencesStateAppCopyContentSettingsChildRequestActionReturnValue
    }

}
internal class TabCoordinatorProtocolMock: TabCoordinatorProtocol {
    internal var rootViewController: UIViewController {
        get { return underlyingRootViewController }
        set(value) { underlyingRootViewController = value }
    }
    internal var underlyingRootViewController: UIViewController!

    // MARK: - relinquishActive

    internal var relinquishActiveCompletionCallsCount = 0
    internal var relinquishActiveCompletionCalled: Bool {
        return relinquishActiveCompletionCallsCount > 0
    }
    internal var relinquishActiveCompletionReceivedCompletion: (() -> Void)?
    internal var relinquishActiveCompletionClosure: (((() -> Void)?) -> Void)?

    internal func relinquishActive(completion: (() -> Void)?) {
        relinquishActiveCompletionCallsCount += 1
        relinquishActiveCompletionClosure?(completion)
    }

}
internal class UserDefaultsListenerProtocolMock: UserDefaultsListenerProtocol {

    // MARK: - start

    internal var startCallsCount = 0
    internal var startCalled: Bool {
        return startCallsCount > 0
    }
    internal var startClosure: (() -> Void)?

    internal func start() {
        startCallsCount += 1
        startClosure?()
    }

}
internal class UserDefaultsServiceProtocolMock: UserDefaultsServiceProtocol {

    // MARK: - getSearchPreferences

    internal var getSearchPreferencesThrowableError: Error?
    internal var getSearchPreferencesCallsCount = 0
    internal var getSearchPreferencesCalled: Bool {
        return getSearchPreferencesCallsCount > 0
    }
    internal var getSearchPreferencesReturnValue: StoredSearchPreferences!
    internal var getSearchPreferencesClosure: (() throws -> StoredSearchPreferences)?

    internal func getSearchPreferences() throws -> StoredSearchPreferences {
        getSearchPreferencesCallsCount += 1
        if let error = getSearchPreferencesThrowableError { throw error }
        return try getSearchPreferencesClosure.map({ try $0() }) ?? getSearchPreferencesReturnValue
    }

    // MARK: - setSearchPreferences

    internal var setSearchPreferencesThrowableError: Error?
    internal var setSearchPreferencesCallsCount = 0
    internal var setSearchPreferencesCalled: Bool {
        return setSearchPreferencesCallsCount > 0
    }
    internal var setSearchPreferencesReceivedSearchPreferences: StoredSearchPreferences?
    internal var setSearchPreferencesClosure: ((StoredSearchPreferences) throws -> Void)?

    internal func setSearchPreferences(_ searchPreferences: StoredSearchPreferences) throws {
        setSearchPreferencesCallsCount += 1
        setSearchPreferencesReceivedSearchPreferences = searchPreferences
        if let error = setSearchPreferencesThrowableError { throw error }
        try setSearchPreferencesClosure?(searchPreferences)
    }

}
