//
//  SettingsSectionProps+Stub.swift
//  PlacesFinderTests
//
//  Copyright (c) 2020 Justin Peckner
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

import Foundation

extension SettingsSectionProps {

    static func stubValue(id: SettingsSectionProps.SectionID,
                          headerType: SettingsSectionProps.HeaderType = .plain(.stubValue()),
                          cells: [SettingsCellProps] = []) -> SettingsSectionProps {
        return SettingsSectionProps(id: id,
                                    headerType: headerType,
                                    cells: cells)
    }

}

extension SettingsPlainHeaderProps {

    static func stubValue(
        title: String = "stubTitle",
        colorings: SettingsHeaderViewColorings = AppColorings.defaultColorings.settings.headerColorings
    ) -> SettingsPlainHeaderProps {
        return SettingsPlainHeaderProps(title: title,
                                        colorings: colorings)
    }

}

extension SettingsUnitsHeaderProps {

    static func stubValue(
        title: String = "stubUnitsHeaderTitle",
        systemOptions: [SettingsUnitsHeaderProps.SystemOption] = [],
        colorings: SettingsHeaderViewColorings = AppColorings.defaultColorings.settings.headerColorings
    ) -> SettingsUnitsHeaderProps {
        return SettingsUnitsHeaderProps(title: title,
                                        systemOptions: systemOptions,
                                        colorings: colorings)
    }

}
