//
//  AppColorings+Defaults.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

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
            viewColoring: ViewColoring(backgroundColor: .systemGray(alternative: #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1))),
            iconTintColoring: FillColoring(color: .systemGray(alternative: #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1))),
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
            cellColorings: SettingsCellColorings(
                textColoring: TextColoring(textColor: .label(alternative: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))),
                checkmarkTint: FillColoring(color: .label(alternative: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)))
            ),
            headerColorings: SettingsHeaderViewColorings(
                textColoring: TextColoring(textColor: .label(alternative: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))),
                activeButtonTextColoring: TextColoring(textColor: #colorLiteral(red: 0, green: 0.568627451, blue: 1, alpha: 1))
            )
        ),
        tabBar: TabBarColorings(
            viewColoring: ViewColoring(backgroundColor: .systemGray5(alternative: #colorLiteral(red: 0.9725490196, green: 0.9725490196, blue: 0.9725490196, alpha: 1))),
            selectedItemTint: FillColoring(color: .label(alternative: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))),
            unselectedItemTint: FillColoring(color: .systemGray(alternative: #colorLiteral(red: 0.5843137255, green: 0.5843137255, blue: 0.5843137255, alpha: 1)))
        )
    )

}
