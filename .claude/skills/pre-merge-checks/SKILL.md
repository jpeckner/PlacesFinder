---
name: pre-merge-checks
description: Run PlacesFinder's final checks on the current branch before it is merged into `develop`. Syncs the branch with `develop`, regenerates the Sourcery, SwiftGen, CoordiNode and config files and commits the results (never the API key), fixes and commits what Periphery finds, does a clean build and runs the `PlacesFinderTests` unit tests, checks SwiftLint and compiler warnings, the SwiftLint analyzer rules, the project-vs-disk file list, the branch's commits for the API key and WIP leftovers, and reports pass/fail per check. Use when asked to run pre-merge checks, final checks, "get this branch ready to merge", or "check the branch before I merge it", even if the user doesn't name this skill.
argument-hint: [notes, e.g. "skip sync", "no commits"]
---

# Pre-merge checks

Get the current branch to a state the user can merge into `develop` without surprises. The skill fixes and commits two kinds of problems itself:
- files that `generate_placesfinder` regenerates differently;
- Periphery findings.

Everything else it reports. **It doesn't merge the branch into `develop` or push anything**; the user does that.

The integration and UI tests are left out on purpose. Don't run them.

## Input

Arguments: `$ARGUMENTS`

Anything given is a note from the user, and notes override this skill's defaults, e.g. "skip sync" or "don't commit". If the arguments are empty or still the placeholder text, run every step.

## Ground rules

- **Never commit `PlacesFinder/Config/AppConfig.plist`.** `generate_placesfinder` rewrites it with the real Yelp key from `fastlane/.env`, so it shows as modified for the whole run. Stage files by path, never with `git add -A`, `git add .` or `git commit -a`.
- **Never print the API key**, in commands, logs or the report. When a step needs it, read it into a shell variable as shown in step 7.
- Write logs to your scratchpad directory (`$LOGS` below means that directory). Run long commands (`fastlane`, Periphery, `xcodebuild`) in the background and wait for them to finish.
- Fastlane needs a UTF-8 locale, so prefix its commands with `LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8`.
- Commit messages follow the repo's style: one line, third-person present tense ("Regenerates…", "Resolves…"). Add any commit trailer your instructions call for.
- Don't run two builds at once. Periphery and `xcodebuild` share DerivedData.

## 1. Preconditions

1. `git branch --show-current` must not be `develop` or `master`. If it is, stop and say so. Note `git rev-parse HEAD` as the starting HEAD for the report.
2. `git status --porcelain` may list only `PlacesFinder/Config/AppConfig.plist` (and ignored files, which it doesn't show). If anything else is modified or untracked, stop and ask the user. The skill's commits would otherwise pick up their unfinished work, or its fixes would get mixed in with it.

## 2. Sync with `develop`

Run the checks against the code that will actually be merged. This repo merges `develop` into task branches (`Merge branch 'develop' into …`), so merge rather than rebase.

```bash
git fetch origin
# Fast-forward the local develop to origin/develop; this fails rather than rewriting if they've diverged
git fetch origin develop:develop
git rev-list --count HEAD..develop
```

- If the count is `0`, the branch already contains `develop`. Go on.
- Otherwise run `git merge --no-edit develop`.
- If `git fetch origin develop:develop` refuses because the local `develop` has diverged from `origin/develop`, stop and tell the user. Don't reset either one.
- If the merge has conflicts, stop. List the conflicting files and ask whether to resolve them or abort with `git merge --abort`.
- If git refuses to merge because `develop` changes `AppConfig.plist`, stop and tell the user.

## 3. Regenerate and commit generated files

```bash
LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 bundle exec fastlane generate_placesfinder open:false > "$LOGS/generate.log" 2>&1
```

`open:false` stops the lane from opening Xcode at the end. If the lane fails, show the end of the log and stop.

Then:

1. `git status --porcelain`. Everything other than `AppConfig.plist` is generated output that is out of date on the branch: Sourcery output, SwiftGen output, CoordiNode output.
2. Check whether `AppConfig.plist` differs from the committed copy in anything other than the key. Do this without displaying the key:
   ```bash
   git show HEAD:PlacesFinder/Config/AppConfig.plist > "$LOGS/AppConfig.committed.plist"
   cp PlacesFinder/Config/AppConfig.plist "$LOGS/AppConfig.generated.plist"
   plutil -replace placeLookup.apiKey -string your_Yelp_fusion_API_key_here "$LOGS/AppConfig.generated.plist"
   plutil -convert xml1 "$LOGS/AppConfig.committed.plist" "$LOGS/AppConfig.generated.plist"
   diff "$LOGS/AppConfig.committed.plist" "$LOGS/AppConfig.generated.plist"
   ```
   If `diff` prints anything, don't commit the plist anyway. Report the difference, e.g. a changed base URL; it means `generate_config.sh` or the committed placeholder has drifted.
3. If there are no other changes, go on to step 4.
4. Otherwise stage the changed and new files by path. New generated files also need entries in `project.pbxproj`. Step 6 catches it if one is missing; add it then with `.claude/skills/convert-view-to-props/add_to_pbxproj.py`.
5. Check what's staged before committing:
   ```bash
   git diff --cached --name-only    # must not list AppConfig.plist
   ```
   Also run the key search from step 7 against `git diff --cached`. It must find nothing.
6. Commit, e.g. `Regenerates Sourcery and SwiftGen files`. Name the generators whose output actually changed.

## 4. Periphery

```bash
PATH="$PATH:/opt/homebrew/bin" mint run peripheryapp/periphery scan > "$LOGS/periphery.log" 2>&1
grep -E ": warning: " "$LOGS/periphery.log"
```

Periphery reads `.periphery.yml`. That file scans the `PlacesFinder` and `PlacesFinderTests` schemes and leaves generated output out of the report. The scan builds the project first, which takes a few minutes. If the build fails, show the compile errors and stop. A clean scan ends with `* No unused code detected.` and has no `warning:` lines.

**Look for a configuration problem first.** If Periphery reports test classes as unused (`Unused class '…Tests'`), the findings are a symptom, not dead code. Every stub and mock those tests use gets reported too, so one cause can produce over a hundred findings. Usually it means the tests' base class is missing from `external_test_case_classes` in `.periphery.yml`; tests moved from `QuickSpec` to `AsyncSpec` once, for example. Fix the config, then rescan before you deal with anything else. **Never delete a test class because Periphery calls it unused.**

**Then look for an existing fix on another local branch.** The user often has unmerged branches waiting, and one of them may already fix the findings. List the commits on local branches that aren't on this one and touch the files in the findings:

```bash
git log --branches --not HEAD --format='%h %s' -- <files from the findings> .periphery.yml
git branch --contains <sha>    # for each candidate, the branches that have it
```

Cherry-pick a candidate (`git cherry-pick <sha>`) only if `git show <sha>` shows that **every** change in it fixes one of the current findings, with nothing unrelated mixed in. Cherry-picking keeps the user's authorship and message. When the user later merges the other branch, git sees the same change on both sides and merges it without a conflict. This doesn't work for a hand-written fix that differs even slightly.

- If the commit also contains unrelated changes, don't cherry-pick it. Write the fix yourself, copying its relevant changes exactly where they apply, so the two branches still merge cleanly.
- If the cherry-pick conflicts, run `git cherry-pick --abort` and write the fix yourself.
- After a cherry-pick, rescan. Fix whatever is left as described below, in a separate commit.

For example, `develop` was once missing `AsyncSpec` in `.periphery.yml`, which produced 130 findings. Commit `6f6a0638` on an unmerged branch made exactly the two changes needed, so cherry-picking it fixed every finding.

Fix every remaining finding, then commit the fixes yourself. Prefer the first of these that fits:

1. **Delete the unused code.** This is the usual case: an unused property, method, type, parameter, import or protocol conformance. Follow the deletion through: initializer parameters that only fed a deleted property, stubs, and tests that only exercised the deleted code.
2. **Ignore it with a comment**, but only when the code has to stay. Examples:
   - a parameter required by a protocol or a shared function signature, as in `RouterProtocol+App.swift` and `HomePresenter.swift`;
   - something used only by `#Preview` or reached through reflection.

   Use the narrowest form (`// periphery:ignore:parameters name`, or `// periphery:ignore` on that one declaration). Add a short reason after it if the reason isn't obvious from the code.
3. **Change `.periphery.yml`** only to describe the project correctly. For example, `AsyncSpec` was added to `external_test_case_classes`. Never add paths to `report_exclude` to hide real findings.

Never edit generated files under `*/Sourcery/Output/`, `PlacesFinder/SwiftGen/Output/` or `PlacesFinder/CoordiNode/Output/`. If a finding points into one, fix the source it is generated from.

After fixing:
- If you deleted or changed anything that a generator reads, rerun step 3's `fastlane` command so the output matches, and stage those files too. Examples: a type marked `AutoMockable`, a string in `Localizable.strings`, an asset, `ModuleStructure.yml`.
- Rerun the scan. Repeat until it reports no warnings. Deleting code often makes more code unused.
- Stage the fixes by path, check that `AppConfig.plist` isn't staged, and commit them: `Resolves issues found by Periphery`.

If a finding looks wrong and none of the three fixes fits, leave it, and list it in the report with your reasoning. Don't invent a workaround.

## 5. Clean build, unit tests, warnings

Use a clean build. It is what `ci_tests` does, it reports every warning rather than only those in recompiled files, and step 5c needs a complete compile log.

```bash
xcodebuild clean test -scheme PlacesFinder -destination 'platform=iOS Simulator,name=iPhone 17,OS=latest' -only-testing:PlacesFinderTests -collect-test-diagnostics never > "$LOGS/test.log" 2>&1
```

- If `iPhone 17` isn't available, pick any iPhone from `xcrun simctl list devices available`.
- Use the `PlacesFinder` scheme with `-only-testing`. The `PlacesFinderTests` scheme can't resolve a simulator destination from the command line.
- Keep `-collect-test-diagnostics never`. Without it, `xcodebuild` runs `simctl diagnose --timeout=600` after the tests finish, and the run looks hung for 10 minutes. If a run still stalls, follow "If `xcodebuild test` still hangs" in section 7 of `.claude/skills/convert-view-to-props/SKILL.md`.

### 5a. Tests

```bash
# Compile errors, test failures and the final result line
grep -E "\.swift:[0-9]+(:[0-9]+)?: error:|with [1-9][0-9]* failures?|\*\* (BUILD|TEST) (FAILED|SUCCEEDED) \*\*" "$LOGS/test.log"
# Test totals
grep -E "Executed [0-9]+ tests" "$LOGS/test.log" | tail -1
```

Don't grep for a bare `error:`, because test names such as `…throws_an_error:` match it.

The test plan runs tests in random order, so a failure may be a flaky test or an order dependency. For each failing test class, rerun it once in a single invocation (`-only-testing:PlacesFinderTests/<TestClass> -test-iterations 5`, same flags otherwise, no `clean`). Report each failure as either *consistent* or *flaky* (passes on some iterations).

- If a failure was caused by this run's Periphery or regeneration commits, fix it, then commit the fix: `Fixes tests broken by Periphery cleanup`.
- Otherwise don't fix it. Report it. Branch logic is the user's to change.

### 5b. SwiftLint and compiler warnings

```bash
python3 .claude/skills/pre-merge-checks/classify_warnings.py "$LOGS/test.log"
```

SwiftLint runs as a build phase, so its warnings appear here alongside the compiler's. Warnings don't fail the build, which is why they need checking here. `develop` itself has some, mostly Swift concurrency and `UnnecessaryEffectMarker` warnings in tests (11 as of October 2026). The script therefore sorts warnings by where they fall, using `git diff develop...HEAD`:

| Group | Meaning | Counts as |
|---|---|---|
| changed lines | on a line the branch added or changed | **fail** |
| touched files | in a file the branch changed, on a line it didn't | see below |
| elsewhere | already on `develop` | listed with a count, doesn't affect the verdict |

For **touched files**, treat `Superfluous Disable Command` warnings as **fail**. They are almost always caused by the branch: its edits made a `// swiftlint:disable` comment unnecessary while leaving the comment's own line unchanged, e.g. by shortening a function or a line. Report the others as worth fixing while the file is open, but they don't fail the check.

Don't use `grep -f` against a list of branch files for this. macOS `grep` matches *every* line when the pattern file is empty, so a branch with no Swift changes would look like it caused every warning.

Fix only warnings caused by this run's own commits, e.g. a `superfluous_disable_command` after a Periphery deletion. Fold that fix into the Periphery commit if it hasn't been made yet; otherwise make a separate commit.

### 5c. SwiftLint analyzer rules

`.swiftlint.yml` enables the analyzer rules `explicit_self` and `unused_import`. The build phase doesn't run them; only `swiftlint analyze` does, and it needs the compile log from the clean build. It takes about 3 minutes, so run it in the background:

```bash
PATH="$PATH:/opt/homebrew/bin" mint run realm/SwiftLint swiftlint analyze --quiet --compiler-log-path "$LOGS/test.log" > "$LOGS/analyze.log" 2>&1
python3 .claude/skills/pre-merge-checks/classify_warnings.py "$LOGS/analyze.log" | grep -E "^==|\((unused_import|explicit_self)\)$"
```

`analyze` recompiles, so its log repeats the compiler warnings from 5b; the second `grep` keeps only the analyzer rules. **This check is informational and doesn't affect the verdict.** Nothing ran these rules before this skill existed, so `develop` has about 1,030 violations (835 `explicit_self`, 196 `unused_import` as of October 2026).
- **`unused_import`:** list those in the *changed lines* and *touched files* groups. They are cheap to fix while the file is open. The rule can be wrong for imports needed only for a type's extensions, so let the user decide.
- **`explicit_self`:** give only the counts per group. The codebase doesn't follow this rule, so it isn't a useful signal on a branch until the user decides whether to adopt or drop it.

Don't run `swiftlint analyze --fix`.

## 6. Project file vs disk

```bash
python3 .claude/skills/pre-merge-checks/check_project_files.py
```

This compares the `.swift` files on disk with the ones `project.pbxproj` references. A file that's on disk but not in the project compiles into nothing, and Periphery can't see it. The usual cause is a rename the project file missed. If the script reports a mismatch, report it; don't guess which side is right.

## 7. Branch hygiene

Everything here compares against `develop`, which after step 2 is contained in the branch, so `develop..HEAD` is exactly what the user is about to merge.

**API key in the branch's history.** Read the key without echoing it, then search every commit on the branch, and the tree at HEAD:

```bash
KEY=$(sed -n 's/^PLACE_LOOKUP_KEY=//p' fastlane/.env)
[ -n "$KEY" ] || echo "PLACE_LOOKUP_KEY not set in fastlane/.env"
git log -S"$KEY" --format='%h %s' develop..HEAD
git grep -lF "$KEY" HEAD --
git log --format='%h %s' develop..HEAD -- PlacesFinder/Config/AppConfig.plist
```

- If `KEY` comes back empty, report the key search as not run. Don't search for an empty string, because it matches everything.
- The first two commands must print nothing.
- The third lists every commit on the branch that touches `AppConfig.plist`. Each one deserves a look, even when the key search is clean.
- If the key turns up, stop. Tell the user which commits contain it. Removing it means rewriting history, which is their decision. Remind them that the key should be rotated once it has been pushed anywhere.

**WIP commits.**
```bash
git log --format='%h %s' develop..HEAD | grep -iE '\bwip\b|^[0-9a-f]+ (fixup|squash|amend)!|\b(tmp|temp|todo)\b'
```
Report each match so the user can reword or squash before merging. Don't rewrite commits yourself.

**Leftovers in the diff.** New lines only, generated output excluded:
```bash
git diff develop...HEAD -- '*.swift' ':!*/Sourcery/Output/*' ':!PlacesFinder/SwiftGen/Output/*' ':!PlacesFinder/CoordiNode/Output/*' \
  | grep -nE '^\+.*(TODO|FIXME|XXX|HACK|\bprint\(|debugPrint\(|\bdump\()'
```
Report each match with its file. Some may be intentional, so don't remove them.

## 8. Final state

`git status --porcelain` must list only `PlacesFinder/Config/AppConfig.plist`. If anything else remains, say what and why. Check whether it should have been part of one of this run's commits.

## 9. Report

Start with a one-line verdict: **ready to merge** or **not ready**, and why.

Then a table with one row per check: sync, generation, AppConfig drift, Periphery, tests, warnings, analyzer, project files, API key, WIP commits, leftovers. Each row has its status (pass / fixed / fail / info / skipped) and a short detail. Include the test totals. The analyzer row is always *info*.

Then:
- the commits this run made (`git log --format='%h %s' <starting HEAD>..HEAD`; note the starting HEAD in step 1);
- each failure in full: file and line for warnings, test names with consistent/flaky for tests;
- warnings in touched files that don't fail the check, and the count of existing warnings elsewhere;
- `unused_import` hits in the branch's files, and the `explicit_self` counts;
- any Periphery findings you left alone, with your reasoning;
- for each commit you cherry-picked, the original commit and the branches that contain it. Say that merging those branches later won't conflict, and that the user can drop the cherry-pick if they'd rather merge one of those branches first;
- a reminder: **"If you'd like a review before merging, run `/code-review`."** Don't run it yourself.

Don't push, and don't merge into `develop`.
