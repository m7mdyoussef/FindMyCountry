//
//  TextStyle.swift
//  FindMyCountry
//
//  Created by Mohamed Youssef Al-Azizy on 27/06/2025.
//

import SwiftUI

protocol TextStyle: ViewModifier {
    var fontSize: CGFloat { get }
    var color: Color { get }
    var weight: Font.Weight { get }
}


extension TextStyle {
    func body(content: Content) -> some View {
        content
            .font(.system(size: fontSize, weight: weight))
            .foregroundColor(color)
    }
}

extension Text {
    func textStyle<T: TextStyle>(_ style: T) -> some View {
        modifier(style)
    }
}

struct RegularTextStyle: TextStyle {
    var fontSize: CGFloat
    var color: Color = AppResources.Colors.main
    var weight: Font.Weight = .regular
}

struct MeduimTextStyle: TextStyle {
    var fontSize: CGFloat
    var color: Color = AppResources.Colors.main
    var weight: Font.Weight = .medium
}

struct BoldTextStyle: TextStyle {
    var fontSize: CGFloat
    var color: Color = AppResources.Colors.main
    var weight: Font.Weight = .bold
}

