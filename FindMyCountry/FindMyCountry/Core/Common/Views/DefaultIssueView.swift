//
//  DefaultIssueView.swift
//  FindMyCountry
//
//  Created by Mohamed Youssef Al-Azizy on 27/06/2025.
//

import SwiftUI

struct DefaultIssueView: View {
    
    var body: some View {
        VStack {
            Spacer()
            
            HStack {
                AppResources.Assets.noConnection
                    .padding(.horizontal)
            }
            .frame(width: 300 , height: 300)
            .backgroundStyle(
                cornerRadius: 20,
                borderColor: AppResources.Colors.light_Red,
                borderWidth: 1,
                backgroundColor: .offWhite
            )
            
            Text(AppConstants.localizedText.checkConnection)
                .textStyle(MeduimTextStyle(fontSize: 16, color: AppResources.Colors.light_Red))
                .multilineTextAlignment(.center)
                .padding(.top, 20)
            
            Spacer()
        }
        .padding(.horizontal, 30)
    }
}
