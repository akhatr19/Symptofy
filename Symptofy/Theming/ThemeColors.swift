//
//  ThemeColors.swift
//  Symptofy
//
//  Created by Aarav Khatri on 7/25/23.
//

import SwiftUI
import UIKit

struct ConstantThemeColors {
    
    struct ScreenColors {
        static let screenOneBackgroundColor = "screenOneBackgroundColor"
        static let screenTwoBackgroundColor = "screenTwoBackgroundColor"
    }
    
    struct ButtonColors {
        static let buttonOneBackgroundColor = "buttonOneBackgroundColor"
        static let buttonTextColor = "buttonTextColor"
    }
    
    struct TextColors {
        static let normalTextColor = "normalTextColor"
        static let informationTextColor = "informationTextColor"
    }
}

extension Color {
    static let oneBackgroundColor = Color(ConstantThemeColors.ScreenColors.screenOneBackgroundColor)
    static let twoBackgroundColor = Color(ConstantThemeColors.ScreenColors.screenTwoBackgroundColor)

    static let normalTextColor = Color(ConstantThemeColors.TextColors.normalTextColor)
    static let informationTextColor = Color(ConstantThemeColors.TextColors.informationTextColor)

    static let buttonBackgroundColor = Color(ConstantThemeColors.ButtonColors.buttonOneBackgroundColor)
    static let buttonTextColor = Color(ConstantThemeColors.ButtonColors.buttonTextColor)
}

extension UIColor {
    static func appColor(_ name: String) -> UIColor? {
         return UIColor(named: name)
    }
    
    static let oneBackgroundColor = UIColor.appColor(ConstantThemeColors.ScreenColors.screenOneBackgroundColor)
    static let twoBackgroundColor = UIColor.appColor(ConstantThemeColors.ScreenColors.screenTwoBackgroundColor)
    
    static let normalTextColor = UIColor.appColor(ConstantThemeColors.TextColors.normalTextColor)
    static let informationTextColor = UIColor.appColor(ConstantThemeColors.TextColors.informationTextColor)

    static let buttonBackgroundColor = UIColor.appColor(ConstantThemeColors.ButtonColors.buttonOneBackgroundColor)
}
