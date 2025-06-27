//
//  ToastModifier.swift
//  FindMyCountry
//
//  Created by Mohamed Youssef Al-Azizy on 27/06/2025.
//

import SwiftUI

struct ToastModifier: ViewModifier {
    @Binding var isPresented: Bool
    let message: String
    let duration: TimeInterval
    
    @State private var showToast = false
    
    func body(content: Content) -> some View {
        ZStack {
            content
            
            if showToast {
                VStack {
                    Spacer()
                    Text(message)
                        .padding()
                        .background(Color.black.opacity(0.8))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .padding(.bottom, 40)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }
                .animation(.easeInOut, value: showToast)
            }
        }
        .onChange(of: isPresented) { _,newValue in
            if newValue {
                showToast = true
                DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                    withAnimation {
                        showToast = false
                    }
                    isPresented = false
                }
            }
        }
    }
}

