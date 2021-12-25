//
//  AppColorings+Defaults.swift
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

extension AppColorings {

    static let defaultColorings = AppColorings(
        standard: AppStandardColorings(
            viewColoring: ViewColoring(backgroundColor: .systemBackground(alternative: #colorLiteral(red: 0.9725490196, green: 0.9725490196, blue: 0.9725490196, alpha: 1))),
            titleTextColoring: TextColoring(textColor: .label(alternative: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))),
            bodyTextColoring: TextColoring(textColor: .label(alternative: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)))
        ),
        launch: LaunchViewColorings(
            viewColoring: ViewColoring(backgroundColor: .systemBackground(alternative: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))),
            spinnerColor: FillColoring(color: #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1))
        ),
        navBar: NavBarColorings(
            viewColoring: ViewColoring(backgroundColor: .systemGray5(alternative: #colorLiteral(red: 0.9725490196, green: 0.9725490196, blue: 0.9725490196, alpha: 1))),
            iconTintColoring: FillColoring(color: .label(alternative: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))),
            backArrowTint: FillColoring(color: .label(alternative: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))),
            titleTextColoring: TextColoring(textColor: .label(alternative: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)))
        ),
        searchCTA: SearchCTAViewColorings(
            viewColoring: ViewColoring(backgroundColor: .systemBackground(alternative: #colorLiteral(red: 0.9725490196, green: 0.9725490196, blue: 0.9725490196, alpha: 1))),
            titleTextColoring: TextColoring(textColor: .label(alternative: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))),
            bodyTextColoring: TextColoring(textColor: .label(alternative: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))),
            ctaTextColoring: TextColoring(textColor: #colorLiteral(red: 0, green: 0.568627451, blue: 1, alpha: 1))
        ),
        searchDetails: SearchDetailsViewColorings(
            viewColoring: ViewColoring(backgroundColor: .systemBackground(alternative: #colorLiteral(red: 0.9725490196, green: 0.9725490196, blue: 0.9725490196, alpha: 1))),
            bodyTextColoring: TextColoring(textColor: .label(alternative: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))),
            phoneIconTint: FillColoring(color: .label(alternative: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))),
            disclosureArrowTint: FillColoring(color: #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1))
        ),
        searchInput: SearchInputViewColorings(
            viewColoring: ViewColoring(backgroundColor: .systemGray),
            iconTintColoring: FillColoring(color: .systemGray),
            textFieldViewColoring: ViewColoring(backgroundColor: .systemBackground(alternative: #colorLiteral(red: 0.9725490196, green: 0.9725490196, blue: 0.9725490196, alpha: 1))),
            placeholderColoring: TextColoring(textColor: .placeholderText(alternative: #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1))),
            inputTextColoring: TextColoring(textColor: .label(alternative: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))),
            cancelButtonTextColoring: TextColoring(textColor: .label(alternative: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)))
        ),
        searchProgress: SearchProgressViewColorings(
            viewColoring: ViewColoring(backgroundColor: .systemBackground(alternative: #colorLiteral(red: 0.9725490196, green: 0.9725490196, blue: 0.9725490196, alpha: 1))),
            gradientFill: FillColoring(color: #colorLiteral(red: 0.9254901961, green: 0.9411764706, blue: 0.9450980392, alpha: 1))
        ),
        searchResults: SearchResultsViewColorings(
            viewColoring: ViewColoring(backgroundColor: .systemBackground(alternative: #colorLiteral(red: 0.9725490196, green: 0.9725490196, blue: 0.9725490196, alpha: 1))),
            bodyTextColoring: TextColoring(textColor: .label(alternative: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))),
            disclosureArrowTint: FillColoring(color: #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)),
            refreshControlTint: FillColoring(color: #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1))
        ),
        settings: SettingsViewColorings(
            viewColoring: ViewColoring(backgroundColor: .systemBackground(alternative: #colorLiteral(red: 0.9725490196, green: 0.9725490196, blue: 0.9725490196, alpha: 1))),
            activeButtonTextColoring: TextColoring(textColor: #colorLiteral(red: 0, green: 0.568627451, blue: 1, alpha: 1)),
            cellTextColoring: TextColoring(textColor: .label(alternative: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))),
            cellCheckmarkTint: FillColoring(color: .label(alternative: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))),
            headerTextColoring: TextColoring(textColor: .label(alternative: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)))
        ),
        tabBar: TabBarColorings(
            viewColoring: ViewColoring(backgroundColor: .systemGray5(alternative: #colorLiteral(red: 0.9725490196, green: 0.9725490196, blue: 0.9725490196, alpha: 1))),
            selectedItemTint: FillColoring(color: .label(alternative: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))),
            unselectedItemTint: FillColoring(color: .systemGray)
        )
    )

}
