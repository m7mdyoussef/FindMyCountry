//
//  HomeScreen.swift
//  FindMyCountry
//
//  Created by Mohamed Youssef Al-Azizy on 27/06/2025.
//

import SwiftUI

struct HomeScreen: View {
    
    @StateObject var viewModel: HomeViewModel = HomeViewModel()
    @EnvironmentObject var loading: Loading
    @EnvironmentObject var popupPresent: PopupPresent
    @EnvironmentObject var router:Router<AppDestinationUIPilot>
    
    @State var openSearch: Bool = false
    @State var showCountryDetail: Bool = false
    @State var showCachedCountryDetail: Bool = false
    @State var openCountryPicker: Bool = false
    
    var body: some View {
        PullToRefreshContainer {
            ZStack {
                Color(AppResources.Colors.offWhite)
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    SearchView(openSearch: $openSearch).padding(.top, 40)
                    DefaultCountryView(viewModel: viewModel, showCountryDetail: $showCountryDetail)
                    SelectedCountriesListView(viewModel: viewModel, showCountryDetail: $showCachedCountryDetail)
                    AddCountryButton(openCountryPicker: $openCountryPicker)
                }
                .padding(20)
                
            }
        } onRefresh: {
            loading.isLoading = true
            viewModel.getAllCountries()
        }
        .oneTimeCalling{
            self.loading.isLoading = true
            self.viewModel.getAllCountries()
            self.viewModel.loadCachedCountries()
        }
        .onChange(of: showCountryDetail) { _, newValue in
            guard newValue else {return}
            if let selectedCountry = viewModel.selectedCountry {
                showCountryDetail = false
                router.push(.details(country: selectedCountry) )
            }
        }
        .onChange(of: showCachedCountryDetail) { _, newValue in
            guard newValue else {return}
            if let selectedCountry = viewModel.selectedCountry {
                showCachedCountryDetail = false
                router.push(.details(country: selectedCountry) )
            }
        }
        .onReceive(viewModel.$isSuccess) { value in
            guard value ?? false else { return }
            loading.isLoading = false
        }
        .onReceive(viewModel.$showError) { showError in
            guard showError ?? false else {return}
            
            loading.isLoading = false
            presentErrorPopup()
        }
        .sheet(isPresented: $openCountryPicker) {
            if !viewModel.allCountries.isEmpty{
                CountrySelectionSheet(viewModel: viewModel)
            }else{
                DefaultIssueView()
            }
        }
        .sheet(isPresented: $openSearch) {
            if !viewModel.allCountries.isEmpty{
                SearchCountriesSheet(viewModel: viewModel, showCountryDetail: $showCountryDetail)
            }else{
                DefaultIssueView()
            }
        }
        
    }
}

extension HomeScreen{
    
    private func refreshContent() {
        Task {
            loading.isLoading = true
            await MainActor.run {
                viewModel.getAllCountries()
                viewModel.loadCachedCountries()
            }
        }
    }
    
    private func presentErrorPopup() {
        popupPresent.popupView.content = {
            AnyView(
                CustomDialog(
                    icon: AppResources.Assets.errorIcon,
                    title: AppConstants.localizedText.error,
                    message: viewModel.errorMessage,
                    primaryButtonTitle: AppConstants.localizedText.retry,
                    primaryAction: {
                        viewModel.getAllCountries()
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




