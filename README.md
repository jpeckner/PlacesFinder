# jpeckner/PlacesFinder

PlacesFinder is a universal iOS app that searches for nearby places, using the [Yelp Fusion API](https://www.yelp.com/developers/documentation/v3/get_started) as its source backend. Its primary purpose is to demonstrate advanced iOS programming practices, including:

* Coordinators
* Redux
* Deep linking
* Location services
* Auto Layout/split view controllers
* Using [Sourcery](https://github.com/krzysztofzablocki/Sourcery)
* Unit and UI tests
* And more

# Usage

### One-Time Setup
1. Install the following tools if your system doesn't have them already:
    * [CocoaPods](https://guides.cocoapods.org/using/getting-started.html)
    * [Mint](https://github.com/yonaskolb/Mint)
    * [Bundler](https://bundler.io/)
1. Clone the PlacesFinder repo onto your system.
1. Run `$ bundle install` to install the dependencies listed in the Gemfile.
1. Run `$ bundle exec pod install` to install CocoaPods dependencies.

### Running PlacesFinder
1. In order to display results from the Yelp Fusion API in PlacesFinder, you'll need to provide it with an API key from Yelp. You can [obtain a limited daily-use token](https://www.yelp.com/developers/documentation/v3/authentication) for free.
1. In the Terminal, run the following:
   ```
   $ cd root/of/PlacesFinder/repo
   $ echo "PLACE_LOOKUP_KEY=value_of_your_API_key" >> fastlane/.env
   $ bundle exec fastlane generate_placesfinder
   ```
   
   The `generate_placesfinder` lane auto-generates all of the Sourcery, CoordiNode, config, and other files for the app. After running it, you'll see your key inserted into AppConfig.plist (be careful not to commit it to Git).
1. Open `PlacesFinder.xcworkspace` in Xcode 13.3 or later.
1. Build and run PlacesFinder; searching will correctly display results. (The app will also run without a valid API key, but searching won't work.)

   > NOTE: an app intended for App Store deployment (which PlacesFinder is not!) should NEVER bundle or be sent a globally-used private key. Instead, the app's own backend should manage private keys for external services such as Yelp, and provide authenticated client apps with limited-use tokens (such as OAuth tokens).

### Deep Linking

PlacesFinder supports the following custom URL schemes for deep linking:
* `placesFinder://com.justinpeckner.PlacesFinder/search?keywords=your_search_string_here`: opens/transitions PlacesFinder to the Search tab and automatically searches for the query value specified. Be sure to [percent encode](https://en.wikipedia.org/wiki/Percent-encoding) the query value, such as replacing space characters with `%20`. Examples:
   * `placesFinder://com.justinpeckner.PlacesFinder/search?keywords=Thai`
   * `placesFinder://com.justinpeckner.PlacesFinder/search?keywords=Greek%20food`
* `placesFinder://com.justinpeckner.PlacesFinder/settings`: opens/transitions PlacesFinder to the Settings tab
* `placesFinder://com.justinpeckner.PlacesFinder/settingsChild`: opens/transitions PlacesFinder to the Settings child presentation view

To use a deep link scheme:
1. Install PlacesFinder-Release scheme app on an iOS simulator or device. (Note: to use PlacesFinder-Debug scheme instead, replace the link's `placesFinder://` prefix with `placesFinder-dev://`).
1. Optional: the above URL schemes work even if PlacesFinder isn't currently launched, so kill the running instance of PlacesFinder if you'd like to try this out.
1. Enter one of the URLs in Safari, and tap Go.
1. Tap Open in Safari's confirmation dialog.
1. PlacesFinder will open to the content specified by the link.

   > NOTE: a business or organization with a website should use [universal links](https://developer.apple.com/ios/universal-links/) rather than a [custom URL scheme](https://developer.apple.com/documentation/uikit/inter-process_communication/allowing_apps_and_websites_to_link_to_your_content/defining_a_custom_url_scheme_for_your_app). However, this in no way lessens the usefulness of PlacesFinder's deep link handling, as there is no significant difference between how it would handle a universal link versus a custom URL scheme link.

### Running CI Tests
PlacesFinder includes a full suite of CI tests, which can be run via `bundle exec fastlane ci_tests`.
These include UI tests which run against a local HTTP server, at `http://localhost`, using [swifter](https://github.com/httpswift/swifter).

   * By default, the server runs on port 8080, but you can change the port in your fastlane/.env file as follows:
      ```
      $ cd root/of/PlacesFinder/repo
      $ echo "TEST_PLACE_LOOKUP_PORT=desired_port_number_here" >> fastlane/.env
      ```
   * If you have macOS Firewall enabled, each time you run the tests you'll see an annoying pop-up asking if you want to allow an incoming connection. To prevent this, simply run the script at PlacesFinderUITests/add_firewall_exceptions.sh, and provide your password when prompted. (Note that you'll need to re-run it each time you restart your computer.) Credit to [Tom Soderling](https://tomsoderling.github.io/Disable-iOS-simulator-connections-popup/) for sharing this script!
      
     The `ci_tests` lane takes care of everything else, including setting an `NSAppTransportSecurity` exception for `localhost` in Info.plist.

# Built With

### APIs

* [Yelp Fusion API](https://www.yelp.com/developers/documentation/v3/get_started) - local content and user reviews API

### Other libraries by [jpeckner](https://github.com/jpeckner)
* [CoordiNode](https://github.com/jpeckner/CoordiNode) - predictably and safely manage the flow of coordinators in an app
* [Shared](https://github.com/jpeckner/Shared) - Swift code for networking, location services, UI, and more
* [SwiftDux](https://github.com/jpeckner/SwiftDux) - a straightforward, thread-safe implementation of Redux in Swift

### Third-party libraries
* [Kingfisher](https://github.com/onevcat/Kingfisher) - download and cache images from the web
* [Nimble](https://github.com/Quick/Nimble) - Swift matcher framework
* [Quick](https://github.com/Quick/Quick) - Swift BDD testing framework
* [Reachability.swift](https://github.com/ashleymills/Reachability.swift) - determine status of the device's internet connection
* [SkeletonView](https://github.com/Juanpe/SkeletonView) - easily display progress-indicating "skeleton" views
* [SnapKit](https://github.com/SnapKit/SnapKit) - a Swift Autolayout DSL
* [swifter](https://github.com/httpswift/swifter) - a lightweight HTTP server engine written in Swift (used only for UI tests)

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
