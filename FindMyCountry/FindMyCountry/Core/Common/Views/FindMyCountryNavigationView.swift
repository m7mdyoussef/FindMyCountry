//
//  FindMyCountryNavigationView.swift
//  FindMyCountry
//
//  Created by Mohamed Youssef Al-Azizy on 27/06/2025.
//

import SwiftUI

struct FindMyCountryNavigationView: View {
    @Binding var didtapBack: Bool
    var body: some View {
        HStack {
            AppResources.Assets.backIcon
                .frame(width: 50 , height: 50)
                .onTapGesture {
                    didtapBack = true
                }
                        
            Text(AppConstants.localizedText.countryDetails)
                .textStyle(BoldTextStyle(fontSize: 20, color:.eyeTiger))
            
            Spacer()
            
        }
        .frame(maxWidth: .infinity, maxHeight: 60)
    }
}
