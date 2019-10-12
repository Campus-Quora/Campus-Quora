//
//  SettingsSection.swift
//  SettingsTemplate
//
//  Created by Stephen Dowless on 2/10/19.
//  Copyright © 2019 Stephan Dowless. All rights reserved.
//

enum SettingCellType{
    case button
    case toggle
    case selector
    case color
}

struct SettingCellDetails{
    var cellType: SettingCellType
    var eventHandler: (() -> Void)?
}

protocol SectionType: CustomStringConvertible {
    var cellDetails: SettingCellDetails { get }
}

enum SettingsSection: Int, CaseIterable, CustomStringConvertible {
    case Theme
    
    var description: String {
        switch self {
            case .Theme: return "Themes and Colors"
        }
    }
}

enum ThemeOptions: Int, CaseIterable, SectionType {
    case theme
    case accentColor
    
    var cellDetails: SettingCellDetails {
        switch self {
            case .theme: return .init(cellType: .selector, eventHandler: SettingsHandler.handleTheme)
            case .accentColor: return .init(cellType: .color, eventHandler: SettingsHandler.handleAccentColor)
        }
    }
    
    var description: String {
        switch self {
            case .theme: return "Select App Theme"
            case .accentColor: return "Select Accent Color"
        }
    }
}
