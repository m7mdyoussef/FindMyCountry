//
//  SelectedCountriesRowView.swift
//  FindMyCountry
//
//  Created by Mohamed Youssef Al-Azizy on 27/06/2025.
//

import SwiftUI

struct SelectedCountriesRowView: View {
    let country: Country
    let onDelete: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            CountryFlagView(url: country.flags?.png ?? "")
                .frame(width: 40, height: 40)
            Text(country.name?.common ?? "")
                .textStyle(MeduimTextStyle(fontSize: 16, color: .mediumGrayG))
            
            Spacer()
            
            Button(action: onDelete) {
                AppResources.Assets.deleteIcon
                    .resizable()
                    .scaledToFit()
            }
            .frame(width: 20, height: 30)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: 60)
        .backgroundStyle(
            cornerRadius: 12,
            borderColor: AppResources.Colors.medium_Gray,
            borderWidth: 1
        )
    }
}
