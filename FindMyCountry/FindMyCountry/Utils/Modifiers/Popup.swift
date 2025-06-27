//
//  Popup.swift
//  FindMyCountry
//
//  Created by Mohamed Youssef Al-Azizy on 27/06/2025.
//

import SwiftUI

struct Popup<T: View>: ViewModifier {
    
    let popup: T
    let isPresented: Bool
    let alignment: Alignment
    let direction: Direction
    
    // 1.
    init(isPresented: Bool, alignment: Alignment, direction: Direction, @ViewBuilder content: () -> T) {
        self.isPresented = isPresented
        self.alignment = alignment
        self.direction = direction
        popup = content()
    }
    
    // 2.
    func body(content: Content) -> some View {
        content
            .disabled(isPresented)
            .overlay(popupContent())
    }
    
    // 3.
    @ViewBuilder private func popupContent() -> some View {
        GeometryReader { geometry in
            if isPresented {
                popup
                    .animation(.spring())
                    .transition(.offset(x: 0, y: direction.offset(popupFrame: geometry.frame(in: .global)))) // (*)
                    .frame(width: geometry.size.width, height: geometry.size.height, alignment: alignment)
            }
        }
    }
}

extension Popup {
    enum Direction {
        case top, bottom
        func offset(popupFrame: CGRect) -> CGFloat {
            switch self {
                case .top:
                    let aboveScreenEdge = -popupFrame.maxY
                    return aboveScreenEdge
                case .bottom:
                    let belowScreenEdge = UIScreen.main.bounds.height - popupFrame.minY
                    return belowScreenEdge
            }
        }
    }
}

extension View {
    
    func popup<T: View>(
        isPresented: Bool,
        alignment: Alignment = .center,
        direction: Popup<T>.Direction = .bottom,
        @ViewBuilder content: () -> T
    ) -> some View {
        return modifier(Popup(isPresented: isPresented, alignment: alignment, direction: direction, content: content))
    }
}
