---
name: convert-dispatch-to-callback
description: Remove the `actionSubscriber` that a PlacesFinder props or view-model data type carries, so the type holds only the Redux action values and the SwiftUI view reports them through an `actionTriggered` callback of type `(Action) -> Void` that is passed down from the hosting controller. Covers the data type, its builder, the view chain, the module view model that owns the subscriber, stubs, tests and Sourcery mocks. Use when asked to remove `actionSubscriber` from a props type or view model, add an `actionTriggered` callback to a view, stop props from dispatching actions themselves, or "do what we did for SearchResultsView" to another view, even if the user doesn't name this skill.
argument-hint: <TypeOrViewName> [notes, e.g. "commit when done"]
---

# Convert props that dispatch into an `actionTriggered` callback

Props should say *which* action a tap means, not *how* to send it. Before this refactor a props type stores an `AnySubscriber` next to each action and exposes `dispatch…()` methods, so every copy of the data drags the store connection along and the tests have to assert through a mock subscriber. After it, the props hold plain action values, the view calls `actionTriggered(action)`, and one closure at the hosting-controller root sends the action to the store.

## Reference implementation

`SearchResultsView` was converted first. Read the current state of these files before starting; they are the pattern to copy:

- `PlacesFinder/Modules/Search/ViewModels/PrimaryView/Children/SearchResultsViewProps.swift` and `SearchResultProps.swift`: props with action values and no subscriber.
- `PlacesFinder/Modules/Search/Views/PrimaryView/Components/SearchResultsView.swift`: the view calling `actionTriggered`.
- `PlacesFinder/Modules/Search/Views/PrimaryView/SearchLookupParentView.swift`: an intermediate view passing the callback down.
- `PlacesFinder/Modules/Search/ViewControllers/PrimaryView/SearchLookupParentController.swift`: the root closure.
- `PlacesFinder/Modules/Search/ViewModels/SearchViewModel.swift`: the module view model that owns the subscriber.
- `PlacesFinder/Components/SingleReadBox.swift`: the one-shot action holder.

The commits were `aeb7815a`..`75fc3778` on `task/UpdateSearchProgressView`. They were work-in-progress commits, so the hashes may no longer resolve; the files above are the source of truth.

Handle **one data type and the view that reads it per run**. Don't commit unless the user asks.

## Input

Arguments: `$ARGUMENTS`

- The first word is the props/view-model type or the view to convert, e.g. `SettingsCellViewModel`. Anything after it is a note from the user, and notes override this skill's defaults.
- If nothing was given, list the candidates with `grep -rn "actionSubscriber" --include='*.swift' PlacesFinder | grep -v Sourcery` and ask which one to convert.

## 1. Survey the target

1. Find where the type stores the subscriber, which actions it stores, and each `dispatch…()` method.
2. Find every caller of those methods (`grep -rn "dispatchX" --include='*.swift' PlacesFinder PlacesFinderTests`).
3. Trace the view chain from the view that calls them up to the `UIHostingController` root. Every view on that path will carry the callback.
4. Note the action type. Search uses `Search.Action`; Settings uses `SearchPreferencesAction`.
5. Decide which shape you have:

| Shape | Looks like | What to do |
|---|---|---|
| Stored action | `private let actionSubscriber` + `private let xAction` + `func dispatchX()` | Steps 2–5 as written. |
| One-shot action | A `mutating` dispatch that clears the action, or any action that must be sent at most once per props value | Use `SingleReadBox` (step 2). |
| Closure built by the builder | Props hold `IgnoredEquatable<() -> Void>` and the builder's closure captures the subscriber (e.g. `SettingsUnitsHeaderViewModel.SystemOption.selectionAction`, the retry `ctaBlock` in `SearchLookupChildBuilder`) | Replace the closure with the action value, if the closure does nothing but send one action. |
| UIKit caller | A `UIViewController` calls `viewModel.dispatchX()` (e.g. `SearchDetailsViewController`) | No precedent yet. Stop and ask. |

Stop and ask the user in these cases, because the reference doesn't settle them:
- The caller is UIKit code, not a SwiftUI view.
- The closure type is shared with something that isn't a store action. `SearchCTABlock` is also used for `urlOpenerService.openSettingsBlock`, so `SearchCTAView` can't simply switch to an action value.
- The module view model's name is already taken by a data struct (see step 4).

## 2. Change the data type

- Delete the subscriber field and its init parameter.
- Make each action a non-private `let xAction: IgnoredEquatable<Action>`. `IgnoredEquatable` stays, so the action doesn't take part in the props' `==`.
- Delete the `dispatch…()` methods. Don't replace one with a method that merely returns the action; the view reads the field.
- Leave building the action where it is. The builder still asks the action prism for it.
- Remove `import Combine` if nothing else in the file needs it.

```swift
struct SearchResultProps: Equatable {
    let cellProps: SearchResultCellProps
    let detailEntityAction: IgnoredEquatable<Search.Action>

    init(cellProps: SearchResultCellProps,
         detailEntityAction: Search.Action) {
        self.cellProps = cellProps
        self.detailEntityAction = IgnoredEquatable(detailEntityAction)
    }
}
```

**One-shot actions.** Some actions must be sent only once per props value. The next-page request is the example: several cells appear in the same render pass, each holding a copy of the same props, and the store update that clears the token only reaches the view on the next render. Store these as `IgnoredEquatable<SingleReadBox<Action>>`, built from an optional action in the init:

```swift
let nextRequestAction: IgnoredEquatable<SingleReadBox<Search.Action>>
…
self.nextRequestAction = IgnoredEquatable(SingleReadBox(nextRequestAction))
```

`consume()` hands the action out once and returns `nil` afterwards, and it removes the action even if the caller then decides not to send it. So the view must check every other condition first and call `consume()` last:

```swift
Task {
    guard currentIndex >= props.resultProps.value.count - 30,
          let nextRequestAction = await props.nextRequestAction.value.consume()
    else {
        return
    }

    actionTriggered(nextRequestAction)
}
```

Getting this order wrong consumes the action from a row that doesn't qualify, and the action is never sent. Pagination stopped for good that way during the first conversion.

## 3. Update the builders

- Remove `actionSubscriber` from the builder's `buildProps`/`buildViewModel` parameters and from the builder protocol.
- Remove it from the builder's stored properties and init, and from `HomeCoordinatorChildFactory`, when the builder no longer uses it for anything.
- Keep it where it is still used. `SearchLookupChildBuilder` kept its subscriber for the retry closure.

Check afterwards that no init still accepts a subscriber and ignores it; that happened in the first conversion and compiled silently.

## 4. Change the views and the root

**The view that triggers the action** gets the callback after `props`:

```swift
private let props: SearchResultsViewProps
private let actionTriggered: (Search.Action) -> Void

init(
    props: SearchResultsViewProps,
    actionTriggered: @escaping (Search.Action) -> Void
) {
    self.props = props
    self.actionTriggered = actionTriggered
}
```

Call sites become `actionTriggered(props.refreshAction.value)`. In a `List` or `ForEach`, read the action from the row's own element (`resultProps.detailEntityAction.value`) instead of looking it up by index.

**Every view between it and the root** takes the same `actionTriggered` parameter and passes it on. Pass it as an init parameter; don't put it in the props (it isn't data) or the environment.

**The hosting controller** builds the closure once, from the module view model:

```swift
let lookupView = SearchLookupParentView(
    viewModel: propsViewModel,
    searchBar: searchBar
) { [weak viewModel] searchAction in
    viewModel?.dispatchAction(searchAction)
}
```

**The module view model** is a small class that owns the subscriber. At minimum it looks like this:

```swift
class SearchViewModel {
    private let inputs: Inputs

    init(actionSubscriber: AnySubscriber<Search.Action, Never>) {
        self.inputs = Inputs(actionSubscriber: actionSubscriber)
    }
}

extension SearchViewModel {

    struct Inputs {
        let actionSubscriber: AnySubscriber<Search.Action, Never>
    }

}

extension SearchViewModel {

    func dispatchAction(_ action: Search.Action) {
        _ = inputs.actionSubscriber.receive(action)
    }

}
```

It is also the place for dispatches that can't be a prebuilt action value, because the action depends on input that only exists at the time of the event. `SearchViewModel` takes the action prism and the `locationUpdateRequestBlock` as well for that reason, and has `dispatchEditEvent(_:)` and `dispatchSearchParams(_:)`, which `SearchLookupParentController` calls for search-bar events. These replaced the old `SearchInputDispatcher` that used to ride along in the props. Give the view model its dependencies at init when they don't change with the state, so the hosting controller doesn't have to keep a copy of the props just to read them back.

- Search already has `SearchViewModel`, and `SearchLookupParentController` already holds it. Reuse them for anything under that controller.
- For a module without one, create `PlacesFinder/Modules/<Module>/ViewModels/<Module>ViewModel.swift` and wire it the way Search does:
  1. `HomeCoordinatorChildFactory` creates it from the module's existing action subscriber.
  2. The coordinator takes it as `viewModel:` and stores it.
  3. The presenter method takes `(_ props: …, viewModel: …)`.
  4. The controller takes `init(props:viewModel:)`.

  Copy the license header from a neighboring file. Register the file with the script in the sibling skill, then lint the project file:
  ```bash
  python3 .claude/skills/convert-view-to-props/add_to_pbxproj.py \
      PlacesFinder/Modules/<Module>/ViewModels/<Module>ViewModel.swift \
      --targets-like <Module>Coordinator.swift \
      --group-like <any file already in that folder>
  ```
  ```bash
  plutil -lint PlacesFinder.xcodeproj/project.pbxproj
  ```
- If `<Module>ViewModel` is already the name of a data struct (`SettingsViewModel` is one today), stop and ask. The usual answer is to run `convert-view-to-props` on that view first, which renames the struct to `…Props` and frees the name.

**Naming.** The data is `props` and the class is `viewModel`, everywhere they travel together: `loadSearchViews(_ props:viewModel:…)`, `init(props:viewModel:)`. Avoid names like `parentViewModel`, and don't leave a local called `viewModel` holding props next to `self.viewModel`; the two get swapped easily.

Update every `#Preview` that uses a changed initializer. `actionTriggered: { _ in }` is enough there.

## 5. Stubs, mocks and tests

1. Remove the subscriber parameter from the type's `+Stub.swift` and from every `stubValue(actionSubscriber: …)` call.
2. Regenerate the Sourcery mocks. Never hand-edit `*/Sourcery/Output/`:
   ```bash
   LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 bundle exec fastlane run_sourcery
   ```
   Removing or adding a parameter changes the generated member names, so update the tests that use them. Two that changed last time:
   - `buildProps…ResultsCopyContentActionSubscriberLocationUpdateRequestBlock…` lost `ActionSubscriber`.
   - `loadSearchViewsDetailsViewContext…` became `loadSearchViewsViewModelDetailsViewContext…`.
3. Rewrite tests that called `dispatchX()` and then inspected `mockActionSubscriber.receivedInputs`. They now assert on the value:
   ```swift
   expect(result.detailEntityAction.value) == .searchActivity(.detailedEntity(stubEntityModel))
   ```
   For a `SingleReadBox`, test three things: the first `consume()` returns the action, a second returns `nil`, and a copy of the props also gets `nil` after the original has consumed it.
   ```swift
   let nextRequestAction = await result.nextRequestAction.value.consume()
   expect(nextRequestAction) == .searchActivity(stubSubsequentRequestAction)
   ```
4. Delete `mockActionSubscriber` and `import Combine` from test files that no longer use them.
5. Pass the new `viewModel:` argument where tests build the coordinator, e.g. `SearchViewModel(actionSubscriber: AnySubscriber(MockSubscriber<Search.Action>()), actionPrism: mockSearchActivityActionPrism) { .success(.stubValue()) }`.

## 6. Check for leftovers

Each of these should print nothing, apart from subscribers you kept on purpose in step 3:

```bash
# The dispatch methods and subscriber uses you removed (fill in)
git grep -nE "dispatchX|dispatchY" -- '*.swift'
```
```bash
# Subscriber still mentioned in the converted type's file, stub or tests (fill in the type name)
git grep -n "actionSubscriber" -- '*TypeName*.swift'
```
```bash
# Props-typed values still named like models
grep -rnE "[A-Za-z]*[mM]odel[A-Za-z]*[[:space:]]*:[[:space:]]*[A-Za-z]*Props([^A-Za-z]|$)" --include='*.swift' PlacesFinder PlacesFinderTests | grep -v "Sourcery/Output"
```

## 7. Verify

Build and run the unit tests exactly as section 7 of `.claude/skills/convert-view-to-props/SKILL.md` describes. That section has the `xcodebuild test` command, how to read the log, the SwiftLint follow-up, and what to do if a test fails. Copy the command from there each time rather than retyping it from memory: its `-collect-test-diagnostics never` flag is what stops `xcodebuild` from stalling for ten minutes after the tests finish. Two lint warnings came up in this refactor:

- `nimble_operator`: write `expect(x) == nil`, not `expect(x).to(beNil())`.
- `superfluous_disable_command`: delete a `// swiftlint:disable line_length` that shorter lines no longer need.

The unit tests don't render the views, so they can't show that a tap still reaches the store. List the interactions that need a manual check in the app (each tap, pull-to-refresh, paging past the first few pages for a one-shot action).

## 8. Report

Tell the user:
- which type and views were converted, and which shape from step 1 it was;
- what was removed (subscriber fields, `dispatch…()` methods, builder parameters) and what was added (`actionTriggered` on which views, any new module view model);
- anything left alone on purpose, such as a builder that still needs its subscriber;
- the leftover-check results;
- the build and unit test results, and the interactions that still need a manual check.
