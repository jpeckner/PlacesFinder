//
//  AppColorings+Defaults.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Shared

extension AppColorings {

    // Needed immediately upon app launch, so it can't be downloaded with the rest of the colorings
    static let launchViewColorings = LaunchViewColorings(viewColoring: ViewColoring(backgroundColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)),
                                                         spinnerColor: #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1))

    // swiftlint:disable number_separator
    static let defaultColorings = AppColorings(
        standard: AppStandardColorings(
            viewColoring: ViewColoring(backgroundColor: #colorLiteral(red: 0.9725490196, green: 0.9725490196, blue: 0.9725490196, alpha: 1)),
            titleTextColoring: TextColoring(textColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)),
            bodyTextColoring: TextColoring(textColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
        ),
        navBar: NavBarColorings(
            viewColoring: ViewColoring(backgroundColor: #colorLiteral(red: 0.9294117647, green: 0.9294117647, blue: 0.9294117647, alpha: 1)),
            backArrowTint: FillColoring(color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)),
            titleTextColoring: TextColoring(textColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
        ),
        searchCTA: SearchCTAViewColorings(
            viewColoring: ViewColoring(backgroundColor: #colorLiteral(red: 0.9725490196, green: 0.9725490196, blue: 0.9725490196, alpha: 1)),
            titleTextColoring: TextColoring(textColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)),
            bodyTextColoring: TextColoring(textColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)),
            ctaTextColoring: TextColoring(textColor: #colorLiteral(red: 0, green: 0.568627451, blue: 1, alpha: 1))
        ),
        searchDetails: SearchDetailsViewColorings(
            viewColoring: ViewColoring(backgroundColor: #colorLiteral(red: 0.9725490196, green: 0.9725490196, blue: 0.9725490196, alpha: 1)),
            bodyTextColoring: TextColoring(textColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)),
            disclosureArrowTint: FillColoring(color: #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1))
        ),
        searchInput: SearchInputViewColorings(
            viewColoring: ViewColoring(backgroundColor: #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)),
            textFieldViewColoring: ViewColoring(backgroundColor: #colorLiteral(red: 0.9725490196, green: 0.9725490196, blue: 0.9725490196, alpha: 1)),
            inputTextColoring: TextColoring(textColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)),
            cancelButtonTextColoring: TextColoring(textColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
        ),
        searchProgress: SearchProgressViewColorings(
            viewColoring: ViewColoring(backgroundColor: #colorLiteral(red: 0.9725490196, green: 0.9725490196, blue: 0.9725490196, alpha: 1)),
            gradientFill: FillColoring(color: #colorLiteral(red: 0.9254901961, green: 0.9411764706, blue: 0.9450980392, alpha: 1))
        ),
        searchResults: SearchResultsViewColorings(
            viewColoring: ViewColoring(backgroundColor: #colorLiteral(red: 0.9725490196, green: 0.9725490196, blue: 0.9725490196, alpha: 1)),
            bodyTextColoring: TextColoring(textColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)),
            disclosureArrowTint: FillColoring(color: #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)),
            refreshControlTint: FillColoring(color: #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1))
        ),
        settings: SettingsViewColorings(
            viewColoring: ViewColoring(backgroundColor: #colorLiteral(red: 0.9725490196, green: 0.9725490196, blue: 0.9725490196, alpha: 1)),
            activeButtonTextColoring: TextColoring(textColor: #colorLiteral(red: 0, green: 0.568627451, blue: 1, alpha: 1)),
            cellBackgroundColoring: ViewColoring(backgroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)),
            cellTextColoring: TextColoring(textColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)),
            cellCheckmarkTint: FillColoring(color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)),
            headerTextColoring: TextColoring(textColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
        ),
        tabBar: TabBarColorings(
            viewColoring: ViewColoring(backgroundColor: #colorLiteral(red: 0.9294117647, green: 0.9294117647, blue: 0.9294117647, alpha: 1)),
            itemTint: FillColoring(color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
        )
    )
    // swiftlint:enable number_separator

}
