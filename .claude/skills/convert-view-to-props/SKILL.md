---
name: convert-view-to-props
description: Convert a PlacesFinder SwiftUI view off `@ObservedObject var viewModel: ValueObservable<…>` so it takes plain `props` (or, for a UIHostingController root, a `SinglePropsViewModel`), and rename the plain data types it consumes from `…ViewModel`/`…Model` to `…ViewProps`/`…Props`, along with related fields, builders, stubs, tests, mocks and project.pbxproj entries. Use when asked to convert, migrate or "props-ify" a view, remove `ValueObservable` from a view, or rename a view model type to props.
argument-hint: <ViewName> [notes, e.g. "use pattern B", "commit when done"]
---

# Convert a SwiftUI view to props

This skill repeats a refactor that has already been done twice. Read these commits before starting; they are the reference implementation:

- `7246b159`: `SearchResultCell` moved to plain props (pattern A); `SearchResultCellModel` renamed to `SearchResultCellProps`.
- `248cf657`: `DownloadedImageViewModel` renamed to `DownloadedImageProps`.
- `9c9c94be`..`bd8c59e3`:
  - `StaticInfoView` moved to plain props (pattern A).
  - `SearchNoInternetViewController` moved to `SinglePropsViewModel` (pattern B).
  - `StaticInfoViewModel`, `SearchMessageViewModel` and `SearchNoInternetViewModel` renamed to `…Props`.
  - Naming cleanup.

Handle **one view and the data types it consumes per run**. Don't commit unless the user asks.

## Input

Arguments: `$ARGUMENTS`

- The first word is the view to convert, e.g. `SearchCTAView`. Anything after it is a note from the user. User notes override this skill's defaults, e.g. which pattern to use, a type to leave unrenamed, or "commit when done".
- If no view was given (the arguments are empty or the placeholder text above wasn't replaced), list the candidates with `grep -rn "ValueObservable" --include='*.swift' PlacesFinder` and ask the user which view to convert.
- If more than one view was given, ask which one to do first.

## 1. Survey the target

1. Find the view's data property, e.g. `@ObservedObject var viewModel: ValueObservable<XViewModel>`. To list candidates, run `grep -rn "ValueObservable" --include='*.swift' PlacesFinder`.
2. Find every place the view is created (`grep -rn "XView(" --include='*.swift' PlacesFinder PlacesFinderTests`). Also check whether any controller is a `UIHostingController<XView>`.
3. For each data type being renamed, list every reference:
   - the type name and its file;
   - fields and parameters that hold it;
   - any builder, builder protocol and `buildViewModel` method;
   - the `+Stub.swift` file and the tests;
   - `AutoMockable.generated.swift`;
   - its entries in `project.pbxproj`.
4. Choose the pattern:
   - **Pattern A** applies when the view is only created inside other SwiftUI views.
   - **Pattern B** applies when the view is a `UIHostingController`'s `rootView` and the controller updates it in `configure(...)` (today that looks like `rootView.viewModel.value = …`).
     - If the view is *also* used as a child elsewhere, convert the view itself with pattern A. Then add a thin pattern-B root view in its own file (see step 3). This is what happened with `StaticInfoView` and `SearchNoInternetView`.
     - If it's used only as that controller's root, it can hold the `SinglePropsViewModel` directly, as `SearchBackgroundView` does. Say so in your report.
   - **Neither pattern:** if the view creates its own state (e.g. `LaunchView`'s `ValueObservable(ProgressState.loading)`), stop and ask the user. This skill doesn't cover that case.

## 2. Rename the data types

Rename a plain data struct to props when either of these is true:
- **The view that reads it is being converted in this run.** For example, `SearchCTAViewModel` was renamed when `SearchCTAView` was converted.
- **Every field is a props value, and this run already has to change the type.** For example, `SearchRetryViewModel` held only the `SearchCTAViewModel` being renamed, so its field had to change anyway. It became `SearchRetryProps`, although `SearchLookupParentView`, which reads it, is unconverted.

Everything else keeps its `…ViewModel` name until the view that reads it is converted:
- **A wrapper this run doesn't otherwise touch**, even if every field is already a props value. For example, `SearchNoResultsFoundViewModel` (only `messageViewProps`) waits for `SearchLookupParentView`, and `AboutAppViewModel` (only `props`) waits for `AboutAppView`.
- **A type that also holds data for an unconverted view.** Only rename its fields (see step 4). For example, `SearchInstructionsProps` holds `props` plus `resultsSource`, which unconverted `SearchInstructionsView` reads. It would have kept its `SearchInstructionsViewModel` name, but the user asked for the rename.

Naming:
- `XViewModel` → `XViewProps` when a view named `XView` reads it (`StaticInfoViewProps`, `SearchCTAViewProps`).
- `XCellModel` → `XCellProps`.
- When no view is named after the type, drop `View`. For example, `SearchRetryViewModel` → `SearchRetryProps`, because there is no `SearchRetryView`.
- `SearchMessageViewProps` and `DownloadedImageProps` predate this rule, and the user chose the name `SearchInstructionsProps`. Leave them alone.

Steps:
1. `git mv` the source file, its `+Stub.swift`, and any builder test file (`XModelBuilderTests.swift` → `XPropsBuilderTests.swift`).
2. Rename the type across all Swift files using a word-boundary match, so `XViewModelBuilder` doesn't get changed by accident. This also updates the `//  X.swift` header comments.
   ```bash
   git grep -lzw OldName -- '*.swift' | xargs -0 sed -i '' 's/[[:<:]]OldName[[:>:]]/NewName/g'
   ```
   Repeat for `OldNameBuilder`, `OldNameBuilderProtocol` and `OldNameBuilderTests` if they exist, doing the longest names first. The generated mock class (`OldNameBuilderProtocolMock`) is renamed when Sourcery reruns (step 5), but tests still refer to it by name, so update those references by hand. If you loop over names in zsh, write `${old}` rather than `$old`, because zsh reads `$old[[:<:]]` as an array subscript.
3. Rename builder methods: `buildViewModel(...)` → `buildProps(...)`. This applies to the props builder protocol and class only, not to other builders with the same method name. Update callers and test `describe("buildProps()")` labels.
4. When a new name is a different length from the old one, realign any continuation lines that line up with an argument list, e.g. multi-line `buildProps(copyContent:…` calls. Same-length renames (`Model` → `Props`) need no realignment.
5. Update `project.pbxproj`. Object IDs stay the same; only the filenames change. Paths containing `+` are quoted, so match on a leading space or quote:
   ```bash
   sed -i '' 's/\([ "]\)OldName\.swift/\1NewName.swift/g; s/\([ "]\)OldName+Stub\.swift/\1NewName+Stub.swift/g' PlacesFinder.xcodeproj/project.pbxproj
   ```
   Then confirm that `grep -c OldName PlacesFinder.xcodeproj/project.pbxproj` finds nothing unexpected.

## 3. Convert the view

**Pattern A (plain props).** This is `StaticInfoView` and `SearchResultCell` today:
```swift
private let props: XViewProps

init(props: XViewProps) {
    self.props = props
}
```
In `body`, `viewModel.value.foo` becomes `props.foo`. Callers change from `XView(viewModel: …)` to `XView(props: …)`. Parents that still use `ValueObservable` themselves stay as they are.

**Pattern B (hosting-controller root).** Model it on `SearchNoInternetView.swift` and `SearchNoInternetViewController.swift`. The view and the controller each get their own file:
- the view in `PlacesFinder/Modules/<Module>/Views/…/XView.swift`, e.g. `Search/Views/PrimaryView/Components/`;
- the controller in `PlacesFinder/Modules/<Module>/ViewControllers/…/XViewController.swift`.

Neither file needs a `// MARK:` for its single type.

```swift
// XView.swift

struct XView: View {

    typealias ViewModel = SinglePropsViewModel<XViewProps>

    private let viewModel: ViewModel

    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        ChildView(props: viewModel.props.childProps)
    }

}
```
```swift
// XViewController.swift

class XViewController: UIHostingController<XView>, … {

    private let viewModel: XView.ViewModel

    init(props: XViewProps) {
        let viewModel = XView.ViewModel(props: props)
        self.viewModel = viewModel

        super.init(rootView: XView(viewModel: viewModel))
    }
    …
}

extension XViewController {

    func configure(props: XViewProps) {
        viewModel.props = props
    }

}
```
Rules for pattern B:
- Reuse the shared `SinglePropsViewModel` in `PlacesFinder/UI/Components/` (it's `@MainActor @Observable`). Don't create a new `@Observable` class for each view.
- The view stores the model as `private let viewModel: ViewModel`, **not** `@State`. SwiftUI only reads a `@State` initial value the first time the view appears, so a model passed in later would be silently ignored. `@State` is only for models the view creates itself.
- Never reassign `rootView` in `configure`. Change `viewModel.props` instead.
- If you create a new view file, copy the license header from a neighboring file, fixing the filename line and using the current year. Then register the file in `project.pbxproj` in the same targets as the controller:
  ```bash
  python3 .claude/skills/convert-view-to-props/add_to_pbxproj.py \
      PlacesFinder/Modules/<Module>/Views/…/XView.swift \
      --targets-like XViewController.swift \
      --group-like <any file already in the destination folder>
  ```
  The script adds a file reference, one build file for each Sources phase that compiles the controller, and a group entry in alphabetical order. Then run `plutil -lint PlacesFinder.xcodeproj/project.pbxproj`.
- Update the presenter and presenter protocol (`loadXViews(_ props: XViewProps, …)`, `buildXViewController(_ props: …)`) and the coordinator that builds the props.

Update every `#Preview` block that uses the changed initializers.

## 4. Rename fields, parameters and locals

| Holds | Name |
|---|---|
| The child view's primary props, as a field of a parent type | `props` (e.g. `SearchCTAViewModel.props`, `AboutAppViewModel.props`) |
| A named props type with a role | `<role>Props` (e.g. `messageViewProps`, `cellProps`) |
| An init label, parameter or local of a props type | `props` (or `<role>Props` if ambiguous), including `configure(_ props:)` |
| An enum case binding of a props type | `props` (e.g. `case let .failure(props):` in `SearchLookupParentView`) |
| A props builder | `<role>PropsBuilder`; test doubles `mock<Role>PropsBuilder`, `stub<Role>Props` |
| Test descriptions | e.g. `it("returns the expected props")` |

Don't flatten single-field wrappers such as `SearchMessageViewProps`. Longer chains like `viewModel.props.messageViewProps.props` are acceptable.

## 5. Regenerate Sourcery mocks

Never hand-edit files under `*/Sourcery/Output/`. Run:
```bash
LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 bundle exec fastlane run_sourcery
```
This lane only regenerates Sourcery output. It resolves Swift packages itself if the Shared `AutoMockable.stencil` template is missing. Don't use `generate_placesfinder`, which also rewrites `PlacesFinder/Config/AppConfig.plist` with the API key. If `AppConfig.plist` ever shows as modified, run `git restore PlacesFinder/Config/AppConfig.plist` and tell the user.

Then update tests that use renamed mock members, e.g. `buildViewModelModel…ReturnValue` → `buildPropsModel…ReturnValue`.

## 6. Check for leftover names

Each of these should print nothing, apart from the old names you're deliberately keeping per step 2:
```bash
# Old type, file, field and method names for this run (fill in)
git grep -nE "OldName|oldFieldName|oldBuilderName" -- '*.swift' PlacesFinder.xcodeproj/project.pbxproj

# Props-typed fields/params still named like models, e.g. `_ viewModel: DownloadedImageProps`, `cellModel: SearchResultCellProps`
grep -rnE "[A-Za-z]*[mM]odel[A-Za-z]*[[:space:]]*:[[:space:]]*[A-Za-z]*Props([^A-Za-z]|$)" --include='*.swift' PlacesFinder PlacesFinderTests | grep -v "Sourcery/Output"

# Locals named like models holding props, e.g. `let viewModel = SearchNoInternetViewProps(`
grep -rnE "(let|var) [A-Za-z]*[mM]odel[A-Za-z]*[[:space:]]*=[[:space:]]*[A-Za-z]*Props(<[^>]*>)?[(.]" --include='*.swift' PlacesFinder PlacesFinderTests | grep -v "Sourcery/Output"
```
Also list functions that return props, and check that each is named `build…Props`, `…Props` or `stubValue`:
```bash
grep -rnE --include='*.swift' -B4 -e "-> [A-Za-z]*Props(<[^>]*>)?" PlacesFinder PlacesFinderTests | grep -v "Sourcery/Output" | grep -E "func "
```
Fix whatever turns up, including leftovers from earlier conversions.

## 7. Verify

`xcodebuild test` builds the app and test targets and then runs the unit tests, so you don't need a separate build. Write its output to a log file in your scratchpad (or `/tmp`), and run it in the background:
```bash
LOG=<scratchpad>/convert-view-to-props-test.log
xcodebuild test -scheme PlacesFinder -destination 'platform=iOS Simulator,name=iPhone 17,OS=latest' -only-testing:PlacesFinderTests > "$LOG" 2>&1
```
If `iPhone 17` isn't available, pick any iPhone from `xcrun simctl list devices available`.

When it finishes, read the results from the log:
```bash
# Compile errors, test failures and the final result line
grep -E "\.swift:[0-9]+(:[0-9]+)?: error:|with [1-9][0-9]* failures?|\*\* (BUILD|TEST) (FAILED|SUCCEEDED) \*\*" "$LOG"
# Test totals
grep -E "Executed [0-9]+ tests" "$LOG" | tail -1
# Warnings in the files you touched (fill in their basenames)
grep -E "warning:" "$LOG" | grep -E "(FileOne|FileTwo)\.swift" | sort -u
```
Don't grep for a bare `error:`, because test names such as `…throws_an_error:` match it. SwiftLint runs as a build phase, so fix any new warnings in files you touched. Warnings elsewhere were already there; leave them.

Renames that shorten names (`…ViewModel…` → `…Props…` drops 4 characters) can make existing `swiftlint:disable` comments unnecessary. SwiftLint then reports `superfluous_disable_command` warnings. Two cases have come up:
- `// swiftlint:disable:next type_name` above a builder protocol whose name is now within the 40-character `type_name` limit.
- `// swiftlint:disable line_length` in a test file whose lines are now all within 120 characters.

Delete the disable comment in either case. After editing files following the test run, you can lint without rebuilding: `PATH="$PATH:/opt/homebrew/bin" mint run realm/SwiftLint swiftlint lint --quiet`, filtered to the files you touched.

**If `xcodebuild test` hangs:** it can hang after every test has finished, whether they passed or failed. If the log ends with `Test Suite 'All tests' passed` (or `failed`) followed by the `Executed N tests` totals, and it hasn't grown for about two minutes, stop only the process you started. A run limited with `-only-testing` prints `Test Suite 'Selected tests'` instead of `'All tests'`, so any automated watcher must match both, e.g. `grep -E "Test Suite '(All|Selected) tests' (passed|failed)"`. Find its PID with `pgrep -fl "xcodebuild test"`, then `kill <pid>`. The totals already in the log are the final results; `** TEST SUCCEEDED **` or `** TEST FAILED **` won't be printed in that case. Mention the hang in your report. Don't wait indefinitely, and don't kill `xcodebuild` processes you didn't start.

**If a test fails:** check whether the failing test covers anything this run changed, e.g. by running `git diff HEAD --stat` over its folder and the code it tests. If it doesn't, rerun just that test class in a single `xcodebuild` invocation with repeats: `-only-testing:PlacesFinderTests/<TestClass> -test-iterations 5`. One invocation means only one possible hang, which is better than a loop of separate runs. Report the result either way. Don't change unrelated tests to make them pass.
## 8. Report

Tell the user:
- which pattern you used and why;
- which types, files and fields were renamed;
- anything you left alone on purpose (e.g. wrapper types still using `ValueObservable`);
- the leftover-name check results;
- the build and unit test results.
