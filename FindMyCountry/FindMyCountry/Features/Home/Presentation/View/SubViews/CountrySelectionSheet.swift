//
//  CountrySelectionSheet.swift
//  FindMyCountry
//
//  Created by Mohamed Youssef Al-Azizy on 27/06/2025.
//

import SwiftUI

struct CountrySelectionSheet: View {
    @ObservedObject var viewModel:HomeViewModel
    @State private var searchQuery = ""
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack{
            HStack{
                Spacer()
                Button(AppConstants.localizedText.done) {
                    viewModel.confirmSelectedCountries()
                    searchQuery = ""
                    dismiss()
                }.padding(20)
            }
            
            SearchTextFieldView(text: $searchQuery)
                .padding(.horizontal)
            
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.searchList) { item in
                        HStack {
                            CountryFlagView(url: item.flags?.png)
                                .frame(width: 40, height: 40)
                            Text(item.name?.common ?? "")
                            Spacer()
                            viewModel.selectedCountriesList.contains(item) ? AppResources.Assets.checkIcon : AppResources.Assets.unCheckIcon
                        }
                        .padding(.vertical, 8)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            viewModel.countrySelection(item)
                        }
                    }
                }
                .padding(.horizontal)
            }
            
        }
        .hideKeyboardOnTap()
        .onChange(of: searchQuery){  _, newValue in
            viewModel.searchQuery = newValue
        }
        .toast(isPresented: $viewModel.exceedMaxSelectedCountries, message: AppConstants.localizedText.onlyFiveCountriesAllowed)
    }
}
