//
//  SelectedCountriesListView.swift
//  FindMyCountry
//
//  Created by Mohamed Youssef Al-Azizy on 27/06/2025.
//

import SwiftUI

struct SelectedCountriesListView: View {
    @ObservedObject var viewModel: HomeViewModel
    @EnvironmentObject var popupPresent: PopupPresent
    @Binding var showCountryDetail: Bool
    
    var body: some View {
        VStack {
            HeaderTitleView(title: AppConstants.localizedText.otherCountry)
            ScrollView{
                VStack(spacing: 12) {
                    if viewModel.selectedCountriesList.isEmpty {
                        Spacer()
                        AppResources.Assets.emptyList
                        Text(AppConstants.localizedText.onlyFiveCountriesAllowed)
                            .textStyle(MeduimTextStyle(fontSize: 16, color: .darkGrayG))
                            .multilineTextAlignment(.center)
                        Spacer()
                        
                    } else {
                        ForEach(viewModel.selectedCountriesList, id: \.self) { item in
                            SelectedCountriesRowView(
                                country: item,
                                onDelete: {
                                    presentConfirmationPopup(item: item)
                                }
                            )
                            .onTapGesture {
                                viewModel.selectedCountry = item
                                showCountryDetail = true
                            }
                        }
                        
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: 380)
            .padding()
            .backgroundStyle(
                cornerRadius: 12,
                borderColor: AppResources.Colors.medium_Gray,
                borderWidth: 1
            )
        }
        
    }
}


extension SelectedCountriesListView{
    private func presentConfirmationPopup(item: Country) {
        self.popupPresent.popupView.content = {
            AnyView(
                CustomDialog(
                    icon: AppResources.Assets.deleteIcon,
                    title: AppConstants.localizedText.alertDeleteConfirmation,
                    message: AppConstants.localizedText.alertDeleteDescription,
                    primaryButtonTitle: AppConstants.localizedText.delete,
                    primaryAction: {
                        viewModel.deleteCountry(item)
                        popupPresent.isPopupPresented = false
                    },
                    secondaryButtonTitle: AppConstants.localizedText.cancel,
                    secondaryAction: {
                        popupPresent.isPopupPresented = false
                    }
                )
            )
        }
        popupPresent.isPopupPresented = true
    }
}
