//
//  DefaultCountryView.swift
//  FindMyCountry
//
//  Created by Mohamed Youssef Al-Azizy on 27/06/2025.
//

import SwiftUI

struct DefaultCountryView: View {
    @ObservedObject var viewModel: HomeViewModel
    
    var body: some View {
        VStack {
            HeaderTitleView(title: AppConstants.localizedText.defaultCountry)
            
            HStack(spacing: 12) {
                CountryFlagView(url: viewModel.getCurrentUserCountry()?.flags?.png ?? "")
                    .frame(width: 40, height: 40)
                VStack(alignment: .leading, spacing: 8) {
                    Text(viewModel.getCurrentUserCountry()?.name?.common ?? "")
                        .textStyle(RegularTextStyle(fontSize: 14))
                    Text(viewModel.getCurrentUserCountry()?.capital?.first ?? "")
                        .textStyle(RegularTextStyle(fontSize: 14))
                }
                Spacer()
                VStack(alignment: .center, spacing: 8) {
                    Text(viewModel.getCurrentUserCountry()?.currencies?.values.first?.name ?? "")
                        .textStyle(RegularTextStyle(fontSize: 14, color: AppResources.Colors.dark_Gray))
                    Text(viewModel.getCurrentUserCountry()?.currencies?.values.first?.symbol ?? "")
                        .textStyle(BoldTextStyle(fontSize: 16, color: AppResources.Colors.dark_Gray))
                }
            }
            .padding()
            .frame(height: 80)
            .backgroundStyle(
                cornerRadius: 12,
                borderColor: AppResources.Colors.medium_Gray,
                borderWidth: 1
            )
        }
        .onTapGesture {
            viewModel.selectedCountry = viewModel.getCurrentUserCountry()
            viewModel.shouldNavigateToCountryDetail = true
        }
    }
}
