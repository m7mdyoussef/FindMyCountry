//
//  CustomDialog.swift
//  FindMyCountry
//
//  Created by Mohamed Youssef Al-Azizy on 27/06/2025.
//

import SwiftUI

struct CustomDialog: View {
    let icon: Image
    let title: String
    let message: String
    let primaryButtonTitle: String
    let primaryAction: () -> Void
    let secondaryButtonTitle: String?
    let secondaryAction: (() -> Void)?
    
    var body: some View {
        VStack(spacing: 20) {
            icon
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
            
            Text(title)
                .font(.title2)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
            
            Text(message)
                .font(.body)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
            
            HStack(spacing: 16) {
                if let secondary = secondaryButtonTitle {
                    Button(secondary) {
                        secondaryAction?()
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(AppResources.Colors.medium_Gray.opacity(0.15))
                    .cornerRadius(10)
                }
                
                Button(primaryButtonTitle) {
                    primaryAction()
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(AppResources.Colors.eyeTiger)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
        }
        .padding()
        .frame(maxWidth: 320)
        .background(AppResources.Colors.white)
        .cornerRadius(16)
        .shadow(radius: 10)
    }
}
