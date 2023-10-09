//
//  CustomText.swift
//  Symptofy
//
//  Created by Aarav Khatri on 7/7/23.
//

import SwiftUI

extension View {
    func customText(_ isTitle: Bool = false, isInformation: Bool = false) -> ModifiedContent<Self, TextModifier> {
        modifier(TextModifier(isTitle: isTitle, isInformation: isInformation))
    }
}

struct TextModifier: ViewModifier {
    var isTitle: Bool
    var isInformation: Bool

    func body(content: Content) -> some View {
        content
            .font(isTitle ? .title3 : .callout)
            .foregroundColor(isInformation ? .informationTextColor : .normalTextColor)
            .bold(isTitle)
    }
