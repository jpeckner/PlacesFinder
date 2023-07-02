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
        aboutApp: AboutAppViewColorings(
            viewColoring: ViewColoring(backgroundColor: .systemBackground),
            titleTextColoring: TextColoring(textColor: .label),
            bodyTextColoring: TextColoring(textColor: .label),
            ctaTextColoring: TextColoring(textColor: #colorLiteral(red: 0, green: 0.568627451, blue: 1, alpha: 1))
        ),
        standard: AppStandardColorings(
            viewColoring: ViewColoring(backgroundColor: .systemBackground),
            titleTextColoring: TextColoring(textColor: .label),
            bodyTextColoring: TextColoring(textColor: .label)
        ),
        launch: LaunchViewColorings(
            viewColoring: ViewColoring(backgroundColor: .systemBackground),
            spinnerColor: FillColoring(color: .systemGray)
        ),
        navBar: NavBarColorings(
            viewColoring: ViewColoring(backgroundColor: .systemBackground),
            iconTintColoring: FillColoring(color: .label),
            backArrowTint: FillColoring(color: .label),
            titleTextColoring: TextColoring(textColor: .label)
        ),
        searchCTA: SearchCTAViewColorings(
            viewColoring: ViewColoring(backgroundColor: .systemBackground),
            titleTextColoring: TextColoring(textColor: .label),
            bodyTextColoring: TextColoring(textColor: .label),
            ctaTextColoring: TextColoring(textColor: #colorLiteral(red: 0, green: 0.568627451, blue: 1, alpha: 1))
        ),
        searchDetails: SearchDetailsViewColorings(
            viewColoring: ViewColoring(backgroundColor: .systemBackground),
            bodyTextColoring: TextColoring(textColor: .label),
            phoneIconTint: FillColoring(color: .label),
            disclosureArrowTint: FillColoring(color: #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1))
        ),
        searchInput: SearchInputViewColorings(
            viewColoring: ViewColoring(backgroundColor: .systemGray),
            iconTintColoring: FillColoring(color: .systemGray),
            textFieldViewColoring: ViewColoring(backgroundColor: .systemBackground),
            placeholderColoring: TextColoring(textColor: .placeholderText),
            inputTextColoring: TextColoring(textColor: .label),
            cancelButtonTextColoring: TextColoring(textColor: .label)
        ),
        searchProgress: SearchProgressViewColorings(
            viewColoring: ViewColoring(backgroundColor: .systemBackground),
            gradientFill: FillColoring(color: .systemGray6),
            gradientBackground: FillColoring(color: .systemGray4)
        ),
        searchResults: SearchResultsViewColorings(
            viewColoring: ViewColoring(backgroundColor: .systemBackground),
            bodyTextColoring: TextColoring(textColor: .label),
            disclosureArrowTint: FillColoring(color: #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)),
            refreshControlTint: FillColoring(color: #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1))
        ),
        settings: SettingsViewColorings(
            viewColoring: ViewColoring(backgroundColor: .systemGroupedBackground),
            cellColorings: SettingsCellColorings(
                viewColoring: ViewColoring(backgroundColor: .secondarySystemGroupedBackground),
                textColoring: TextColoring(textColor: .label),
                checkmarkTint: FillColoring(color: .label)
            ),
            headerColorings: SettingsHeaderViewColorings(
                textColoring: TextColoring(textColor: .label),
                activeButtonTextColoring: TextColoring(textColor: #colorLiteral(red: 0, green: 0.568627451, blue: 1, alpha: 1))
            )
        ),
        tabBar: TabBarColorings(
            viewColoring: ViewColoring(backgroundColor: .systemGray5),
            selectedItemTint: FillColoring(color: .label),
            unselectedItemTint: FillColoring(color: .systemGray)
        )
    )

}
