//
//  LaunchView.swift
//  PlacesFinder
//
//  Copyright (c) 2019 Justin Peckner
//  
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//  
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//  
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import Shared
import SwiftUI

struct LaunchView: View {

    private enum ProgressState {
        case loading
        case completing(continuation: CheckedContinuation<Void, Never>)
    }

    let colorings: LaunchViewColorings
    @ObservedObject private var state = ValueObservable(ProgressState.loading)

    var body: some View {
        GeometryReader { geometry in
            switch state.value {
            case .loading:
                LoadingLaunchView(
                    geometry: geometry,
                    colorings: colorings
                )

            case let .completing(continuation):
                CompletingLaunchView(
                    geometry: geometry,
                    continuation: continuation
                )
            }
        }
        .background(Color(colorings.viewColoring.backgroundColor))
    }

    func animateOut() async {
        await withCheckedContinuation { continuation in
            state.value = .completing(continuation: continuation)
        }
    }

}

// MARK: - Components

private struct LoadingLaunchView: View {

    let geometry: GeometryProxy
    let colorings: LaunchViewColorings

    var body: some View {
        Image(uiImage: Constants.appIcon)
            .resizable()
            .frame(
                width: geometry.appIconDimension,
                height: geometry.appIconDimension
            )
            .aspectRatio(1, contentMode: .fill)
            .position(geometry.appIconCenter)

        ProgressView()
            .position(geometry.progressViewPosition)
            .tint(Color(colorings.spinnerColor.color))
    }

}

private struct CompletingLaunchView: View {

    private enum AnimationConstants {
        static let firstAnimationDuration: TimeInterval = 0.3
        static let secondAnimationDuration: TimeInterval = 0.2
        static let totalAnimationDuration = firstAnimationDuration + secondAnimationDuration
    }

    private let geometry: GeometryProxy
    private let continuation: CheckedContinuation<Void, Never>
    @State private var completingImageWidth: CGFloat
    @State private var completingImageHeight: CGFloat
    @State private var completingImageAlpha: CGFloat

    init(geometry: GeometryProxy,
         continuation: CheckedContinuation<Void, Never>) {
        self.geometry = geometry
        self.continuation = continuation
        self._completingImageWidth = State(initialValue: geometry.appIconDimension)
        self._completingImageHeight = State(initialValue: geometry.appIconDimension)
        self._completingImageAlpha = State(initialValue: 1.0)
    }

    var body: some View {
        Image(uiImage: Constants.appIcon)
            .resizable()
            .frame(
                width: completingImageWidth,
                height: completingImageHeight
            )
            .position(geometry.appIconCenter)
            .opacity(completingImageAlpha)
            .onAppear {
                withAnimation(.linear(duration: AnimationConstants.firstAnimationDuration)) {
                    let scaledDimension = geometry.appIconDimension * 0.7
                    completingImageWidth = scaledDimension
                    completingImageHeight = scaledDimension
                }

                withAnimation(
                    .easeIn(duration: AnimationConstants.secondAnimationDuration)
                    .delay(AnimationConstants.firstAnimationDuration)
                ) {
                    let scaledDimension = geometry.appIconDimension * 10.0
                    completingImageWidth = scaledDimension
                    completingImageHeight = scaledDimension
                    completingImageAlpha = 0.0
                }

                DispatchQueue.main.asyncAfter(deadline: .now() + AnimationConstants.totalAnimationDuration) {
                    continuation.resume()
                }
            }
    }

}

private extension GeometryProxy {

    private enum LayoutConstants {
        static let percentTopToAppIconTop: CGFloat = 0.25
        static let percentAppIconBottomToProgressViewTop: CGFloat = 0.15
    }

    var appIconDimension: CGFloat {
        size.width * 0.3
    }

    var appIconCenter: CGPoint {
        CGPoint(
            x: size.width / 2,
            y: (
                size.height * LayoutConstants.percentTopToAppIconTop
                + appIconDimension / 2
            )
        )
    }

    var progressViewPosition: CGPoint {
        CGPoint(
            x: size.width / 2,
            y: (
                size.height * LayoutConstants.percentTopToAppIconTop
                + appIconDimension
                + size.height * LayoutConstants.percentAppIconBottomToProgressViewTop
            )
        )
    }

}

private enum Constants {
    static let appIcon = #imageLiteral(resourceName: "app_icon")
}
