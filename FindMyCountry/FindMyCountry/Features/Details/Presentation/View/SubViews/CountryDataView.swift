//
//  CountryDataView.swift
//  FindMyCountry
//
//  Created by Mohamed Youssef Al-Azizy on 27/06/2025.
//

import SwiftUI
struct CountryDataView: View {
    let country: Country
    
    var body: some View {
        VStack {
            
            CountryRowInfoView(title: AppConstants.localizedText.country) {
                HeaderTitleView(title: country.name?.common ?? "", titleColor: AppResources.Colors.medium_Gray)
            }
            
            CountryRowInfoView(title: AppConstants.localizedText.capital) {
                HeaderTitleView(title: country.capital?.first ?? "", titleColor: AppResources.Colors.medium_Gray)
            }
            
            CountryRowInfoView(title: AppConstants.localizedText.languages) {
                HeaderTitleView(title: country.languages?.values.first ?? "-", titleColor: AppResources.Colors.medium_Gray)
            }
            
            CountryRowInfoView(title: AppConstants.localizedText.currency) {
                HStack {
                    Text(country.currencies?.values.first?.name ?? "-")
                        .textStyle(MeduimTextStyle(fontSize: 16, color: AppResources.Colors.medium_Gray))
                    
                    Text(country.currencies?.values.first?.symbol ?? "-")
                        .textStyle(BoldTextStyle(fontSize: 18, color: AppResources.Colors.medium_Gray))
                    Spacer()
                }
            }
            
        }
        .padding()
        .backgroundStyle(cornerRadius: 12)
    }
}
