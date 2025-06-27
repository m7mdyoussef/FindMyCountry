//
//  View+Extension.swift
//  FindMyCountry
//
//  Created by Mohamed Youssef Al-Azizy on 27/06/2025.
//

import SwiftUI

extension View {
    //MARK: - BackgroundStyle
    func backgroundStyle(
        cornerRadius: CGFloat = 8,
        borderColor: Color = .gray,
        borderWidth: CGFloat = 1,
        backgroundColor: Color = AppResources.Colors.white
    ) -> some View {
        self.modifier(
            BackgroundViewModifier(
                cornerRadius: cornerRadius,
                borderColor: borderColor,
                borderWidth: borderWidth,
                backgroundColor: backgroundColor
            )
        )
    }
}

//MARK: - OneTimeCalling
extension View {
    func oneTimeCalling(_ action: @escaping () -> Void) -> some View {
        self.modifier(OneTimeCallingModifier(action: action))
    }
}

//MARK: - OneTimeCalling
struct OneTimeCallingModifier: ViewModifier {
    @State private var hasBeenCalled = false
    let action: () -> Void
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                if !hasBeenCalled {
                    hasBeenCalled = true
                    action()
                }
            }
    }
}

//MARK: - Keyboard
extension View {
    func hideKeyboardOnTap() -> some View {
        self.modifier(HideKeyboardModifier())
    }
}

//MARK: - toast
extension View {
    func toast(isPresented: Binding<Bool>, message: String, duration: TimeInterval = 2.0) -> some View {
        self.modifier(ToastModifier(isPresented: isPresented, message: message, duration: duration))
    }
}
