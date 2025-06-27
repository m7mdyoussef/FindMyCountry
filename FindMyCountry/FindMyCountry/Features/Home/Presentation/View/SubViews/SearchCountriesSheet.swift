//
//  SearchCountriesSheet.swift
//  FindMyCountry
//
//  Created by Mohamed Youssef Al-Azizy on 27/06/2025.
//

import SwiftUI
struct SearchCountriesSheet: View {
    @ObservedObject var viewModel: HomeViewModel
    @State private var searchQuery = ""
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            HStack{
                Spacer()
                Button(AppConstants.localizedText.cancel) {
                    searchQuery = ""
                    dismiss()
                }.padding(10)
            }
            
            SearchTextFieldView(text: $searchQuery)
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.searchList) { item in
                        HStack {
                            CountryFlagView(url: item.flags?.png ?? "")
                                .frame(width: 40, height: 40)
                            Text(item.name?.common ?? "")
                            Spacer()
                        }
                        .padding(.vertical, 8)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            viewModel.selectedCountry = item
                            dismiss()
                            viewModel.searchQuery = ""
                            viewModel.shouldNavigateToCountryDetail = true
                        }
                    }
                }
            }
        }
        .hideKeyboardOnTap()
        .padding()
        .onChange(of: searchQuery){  _, newValue in
            viewModel.searchQuery = newValue
        }
    }
}
