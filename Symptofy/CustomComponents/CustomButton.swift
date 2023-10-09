//
//  CustomButton.swift
//  Symptofy
//
//  Created by Aarav Khatri on 7/7/23.
//

import SwiftUI

extension View {
    func customButton() -> ModifiedContent<Self, ButtonModifier> {
        modifier(ButtonModifier())
    }
}

struct ButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.headline)
            .foregroundColor(.buttonTextColor)
            .padding()
            .frame(maxWidth: .infinity)
            .background(RoundedRectangle(cornerRadius: 12, style: .circular).fill(Color.buttonBackgroundColor))
    }
}
