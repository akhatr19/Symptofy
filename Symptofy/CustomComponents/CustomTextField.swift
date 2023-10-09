//
//  CustomTextField.swift
//  Symptofy
//
//  Created by Aarav Khatri on 7/29/23.
//

import SwiftUI

extension View {
    func customTextField(_ keyboardType: UIKeyboardType) -> ModifiedContent<Self, TextFieldModifier> {
        modifier(TextFieldModifier(keyboardType: keyboardType))
    }
}

struct TextFieldModifier: ViewModifier {
    var keyboardType: UIKeyboardType
    
    func body(content: Content) -> some View {
        content
            .keyboardType(keyboardType)
            .autocorrectionDisabled(true)
    }
}
