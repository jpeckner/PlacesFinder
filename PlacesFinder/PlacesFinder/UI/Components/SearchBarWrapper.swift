//
//  SearchBarWrapper.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2020 Justin Peckner. All rights reserved.
//

import Shared
import UIKit

// MARK: SearchBarEditAction

enum SearchBarEditAction {
    case beganEditing
    case clearedInput
    case endedEditing
}

// MARK: SearchBarWrapper

protocol SearchBarWrapperDelegate: AnyObject {
    func searchBarWrapper(_ searchBarWrapper: SearchBarWrapper, didPerformAction action: SearchBarEditAction)

    func searchBarWrapper(_ searchBarWrapper: SearchBarWrapper, didClickSearch text: NonEmptyString)
}

class SearchBarWrapper: NSObject {
    weak var delegate: SearchBarWrapperDelegate?

    var isFirstResponder: Bool = false {
        didSet {
            if isFirstResponder {
                if !searchBar.isFirstResponder {
                    searchBar.becomeFirstResponder()
                }
            } else {
                if searchBar.isFirstResponder {
                    searchBar.resignFirstResponder()
                }
            }
        }
    }

    var view: UIView {
        return searchBar
    }

    private let searchBar: UISearchBar
    private var didTapDeleteKey = false

    override init() {
        self.searchBar = UISearchBar()
        searchBar.returnKeyType = .go
        searchBar.enablesReturnKeyAutomatically = true

        super.init()

        searchBar.delegate = self
    }
}

extension SearchBarWrapper {

    func configureText(_ text: String?) {
        searchBar.text = text
    }

    func configurePlaceholder(_ placeholder: String?) {
        searchBar.placeholder = placeholder
    }

}

extension SearchBarWrapper: UISearchBarDelegate {

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        delegate?.searchBarWrapper(self, didPerformAction: .beganEditing)
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        delegate?.searchBarWrapper(self, didPerformAction: .endedEditing)
    }

    // Hacky way to detect that the circled-X button was tapped; unfortunately Apple doesn't provide a real API for it.
    // Source: https://stackoverflow.com/a/52620389/1342984
    func searchBar(_ searchBar: UISearchBar,
                   shouldChangeTextIn range: NSRange,
                   replacementText text: String) -> Bool {
        didTapDeleteKey = text.isEmpty
        return true
    }

    func searchBar(_ searchBar: UISearchBar,
                   textDidChange searchText: String) {
        if !didTapDeleteKey && searchText.isEmpty {
            delegate?.searchBarWrapper(self, didPerformAction: .clearedInput)
        }

        didTapDeleteKey = false
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text,
            let nonEmptyText = try? NonEmptyString(text)
        else {
            AssertionHandler.performAssertionFailure { "UISearchBar should be configured to not return empty text" }
            return
        }

        delegate?.searchBarWrapper(self, didClickSearch: nonEmptyText)
    }

}
