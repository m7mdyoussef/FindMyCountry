//
//  HomeViewModel.swift
//  FindMyCountry
//
//  Created by Mohamed Youssef Al-Azizy on 27/06/2025.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    
    private let countriesUseCase: RemoteCountriesUseCaseContract
    private let selectedCountriesCache: SelectedCountriesCachingManager
    @Published var locationManager: LocationManager
    
    @Published  var currentUserCountry: String = ""
    @Published var selectedCountry: Country?
    @Published var allCountries: [Country] = []
    @Published var selectedCountriesList: [Country] = []
    @Published var searchQuery = ""
    let maxSelectedCountries = 5
    @Published var exceedMaxSelectedCountries: Bool = false
    @Published var shouldNavigateToCountryDetail: Bool = false

    @Published var isSuccess: Bool?
    @Published var showError: Bool?
    var errorMessage: String = ""
    private var cancellables = Set<AnyCancellable>()
    
    init(countriesUseCase: RemoteCountriesUseCaseContract = RemoteCountriesUseCaseImpl(),
         selectedCountriesCache: SelectedCountriesCachingManager = SelectedCountriesCachingManager(),
         locationManager: LocationManager = LocationManager()) {
        self.countriesUseCase = countriesUseCase
        self.selectedCountriesCache = selectedCountriesCache
        self.locationManager = locationManager
        self.currentUserCountry = locationManager.userCountry
        bindLocationUpdates()
    }
    
    private func bindLocationUpdates() {
        locationManager.$userCountry
            .receive(on: DispatchQueue.main)
            .sink { [weak self] country in
                guard let self = self else { return }
                if !country.isEmpty {
                    self.currentUserCountry = country
                }
            }
            .store(in: &cancellables)
    }
    
    func requestUserLocation() {
        locationManager.requestLocation()
    }
    
    func getAllCountries(){
        countriesUseCase.executeFetchCountries()
            .sink { [weak self] completion in
                guard let self = self else { return }
                
                if case .failure(let error) = completion {
                    self.errorMessage = error.errorDescription
                    self.showError = true
                }
            } receiveValue: { [weak self] countries in
                self?.isSuccess = true
                self?.allCountries = countries
            }.store(in: &cancellables)
    }
    
    var searchList: [Country] {
        searchQuery.isEmpty ? allCountries : allCountries.filter {$0.name?.common?.localizedCaseInsensitiveContains(searchQuery) ?? false}
    }
    
    func getCurrentUserCountry() -> Country? {
        return allCountries.first(where: { $0.name?.common == currentUserCountry }) ??
        allCountries.first(where: { $0.name?.common == AppConstants.localizedText.egypt })
    }
    
    func countrySelection(_ country: Country) {
        if selectedCountriesList.contains(country) {
            selectedCountriesList.removeAll { $0 == country }
            exceedMaxSelectedCountries = false
        } else {
            if selectedCountriesList.count < maxSelectedCountries {
                selectedCountriesList.append(country)
                exceedMaxSelectedCountries = false
            }else{
                exceedMaxSelectedCountries = true
            }
        }
    }
    
    
    func confirmSelectedCountries() {
        selectedCountriesCache.save(selectedCountriesList)
    }
    
    func loadCachedCountries() {
        selectedCountriesList = selectedCountriesCache.load()
    }
    
    func deleteCountry(_ country: Country) {
        selectedCountriesList.removeAll { $0 == country }
        selectedCountriesCache.save(selectedCountriesList)
    }
}
