//
//  HomeViewModelTests.swift
//  FindMyCountryTests
//
//  Created by Mohamed Youssef Al-Azizy on 27/06/2025.
//

import XCTest
import Combine
@testable import FindMyCountry

class HomeViewModelTests: XCTestCase {
    
    var viewModel: HomeViewModel!
    var mockUseCase: MockCountriesUseCase!
    var mockCache: MockSelectedCountriesCache!
    var mockLocationManager: MockLocationManager!
    var cancellables: Set<AnyCancellable>!
    
    let testCountries: [Country] = [
        Country(
            flags: Flags(png: "us.png", svg: "us.svg", alt: "US Flag"),
            name: CountryName(common: "United States", official: "USA", nativeName: ["eng": NativeName(official: "USA", common: "United States")]),
            cca2: "US",
            currencies: ["USD": Currency(name: "US Dollar", symbol: "$")],
            capital: ["Washington, D.C."],
            region: .americas,
            subregion: "North America",
            languages: ["eng": "English"],
            population: 331_000_000,
            timezones: ["UTC-12:00", "UTC-11:00"]
        ),
        Country(
            flags: Flags(png: "eg.png", svg: "eg.svg", alt: "Egypt Flag"),
            name: CountryName(common: "Egypt", official: "Arab Republic of Egypt", nativeName: ["ara": NativeName(official: "جمهورية مصر العربية", common: "مصر")]),
            cca2: "EG",
            currencies: ["EGP": Currency(name: "Egyptian Pound", symbol: "£")],
            capital: ["Cairo"],
            region: .africa,
            subregion: "Northern Africa",
            languages: ["ara": "Arabic"],
            population: 102_000_000,
            timezones: ["UTC+02:00"]
        ),
        Country(
            flags: Flags(png: "fr.png", svg: "fr.svg", alt: "France Flag"),
            name: CountryName(common: "France", official: "French Republic", nativeName: ["fra": NativeName(official: "République française", common: "France")]),
            cca2: "FR",
            currencies: ["EUR": Currency(name: "Euro", symbol: "€")],
            capital: ["Paris"],
            region: .europe,
            subregion: "Western Europe",
            languages: ["fra": "French"],
            population: 67_000_000,
            timezones: ["UTC-10:00", "UTC+12:00"]
        )
    ]
    
    override func setUp() {
        super.setUp()
        mockUseCase = MockCountriesUseCase()
        mockCache = MockSelectedCountriesCache()
        mockLocationManager = MockLocationManager()
        cancellables = Set<AnyCancellable>()
        
        viewModel = HomeViewModel(
            countriesUseCase: mockUseCase,
            selectedCountriesCache: mockCache,
            locationManager: mockLocationManager
        )
    }
    
    override func tearDown() {
        viewModel = nil
        mockUseCase = nil
        mockCache = nil
        mockLocationManager = nil
        cancellables = nil
        super.tearDown()
    }
    
    // MARK: - Initial State Tests
    func test_initialState() {
        XCTAssertTrue(viewModel.allCountries.isEmpty)
        XCTAssertTrue(viewModel.selectedCountriesList.isEmpty)
        XCTAssertFalse(viewModel.exceedMaxSelectedCountries)
        XCTAssertNil(viewModel.isSuccess)
        XCTAssertNil(viewModel.showError)
        XCTAssertTrue(viewModel.errorMessage.isEmpty)
    }
    
    // MARK: - Country Fetching Tests
    func test_getAllCountries_success() {
        // Given
        mockUseCase.result = .success(testCountries)
        let expectation = XCTestExpectation(description: "Countries loaded")
        
        // When
        viewModel.$allCountries
            .dropFirst()
            .sink { countries in
                // Then
                XCTAssertEqual(countries.count, 3)
                XCTAssertEqual(countries[0].name?.common, "United States")
                XCTAssertEqual(self.viewModel.isSuccess, true)
                XCTAssertNil(self.viewModel.showError)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.getAllCountries()
        
        wait(for: [expectation], timeout: 1)
    }
    
    func test_getAllCountries_failure() {
        // Given
        mockUseCase.result = .failure(.apiError(.noInternet))
        let expectation = XCTestExpectation(description: "Error shown")
        
        // When
        viewModel.$showError
            .dropFirst()
            .sink { showError in
                // Then
                XCTAssertEqual(showError, true)
                XCTAssertEqual(self.viewModel.errorMessage, "No Internet Connection, plaese try again")
                XCTAssertNil(self.viewModel.isSuccess)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.getAllCountries()
        
        wait(for: [expectation], timeout: 1)
    }
    
    // MARK: - Search Functionality Tests
    func test_searchList_emptyQuery() {
        // Given
        viewModel.allCountries = testCountries
        viewModel.searchQuery = ""
        
        // Then
        XCTAssertEqual(viewModel.searchList.count, 3)
    }
    
    func test_searchList_withQuery() {
        // Given
        viewModel.allCountries = testCountries
        viewModel.searchQuery = "united"
        
        // Then
        XCTAssertEqual(viewModel.searchList.count, 1)
        XCTAssertEqual(viewModel.searchList.first?.name?.common, "United States")
    }
    
    func test_searchList_caseInsensitive() {
        // Given
        viewModel.allCountries = testCountries
        viewModel.searchQuery = "eGyPt"
        
        // Then
        XCTAssertEqual(viewModel.searchList.count, 1)
        XCTAssertEqual(viewModel.searchList.first?.name?.common, "Egypt")
    }
    
    // MARK: - Location Tests
    func test_getCurrentUserCountry_notFound_defaultsToEgypt() {
        // Given
        viewModel.allCountries = testCountries
        mockLocationManager.mockUserCountry = "Unknown Country"
        
        // When
        let country = viewModel.getCurrentUserCountry()
        
        // Then
        XCTAssertEqual(country?.name?.common, "Egypt")
    }
    
    // MARK: - Country Selection Tests
    func test_countrySelection_addsCountry() {
        // Given
        let country = testCountries[0]
        
        // When
        viewModel.countrySelection(country)
        
        // Then
        XCTAssertEqual(viewModel.selectedCountriesList.count, 1)
        XCTAssertEqual(viewModel.selectedCountriesList.first?.name?.common, "United States")
        XCTAssertFalse(viewModel.exceedMaxSelectedCountries)
    }
    
    func test_countrySelection_removesCountry() {
        // Given
        viewModel.selectedCountriesList = [testCountries[0]]
        
        // When
        viewModel.countrySelection(testCountries[0])
        
        // Then
        XCTAssertTrue(viewModel.selectedCountriesList.isEmpty)
    }
    
    func test_countrySelection_maxLimitReached() {
        // Given
        let maxCountries = Array(repeating: testCountries[0], count: viewModel.maxSelectedCountries)
        viewModel.selectedCountriesList = maxCountries
        let newCountry = testCountries[1]
        
        // When
        viewModel.countrySelection(newCountry)
        
        // Then
        XCTAssertEqual(viewModel.selectedCountriesList.count, viewModel.maxSelectedCountries)
        XCTAssertTrue(viewModel.exceedMaxSelectedCountries)
    }
    
    // MARK: - Cache Operations Tests
    func test_countrySelection_persistsOnConfirm() {
        // Given
        let country = testCountries[0]
        viewModel.countrySelection(country)
        
        // When
        viewModel.confirmSelectedCountries()
        
        // Then
        let loaded = mockCache.load()
        XCTAssertEqual(loaded.count, 1)
        XCTAssertEqual(loaded.first?.name?.common, "United States")
    }
    
    func test_deleteCountry_updatesCache() {
        // Given
        viewModel.selectedCountriesList = testCountries
        viewModel.confirmSelectedCountries()
        
        // When
        viewModel.deleteCountry(testCountries[0])
        
        // Then
        let loaded = mockCache.load()
        XCTAssertEqual(loaded.count, 2)
        XCTAssertEqual(loaded.first?.name?.common, "Egypt")
    }
    
    func test_deleteCountry_removesFromListAndCache() {
        // Given
        viewModel.selectedCountriesList = [testCountries[0], testCountries[1]]
        viewModel.confirmSelectedCountries() // First save to cache
        
        // Verify initial cache state
        var cachedCountries = mockCache.load()
        XCTAssertEqual(cachedCountries.count, 2)
        
        // When
        viewModel.deleteCountry(testCountries[0])
        
        // Then
        // Verify in-memory list
        XCTAssertEqual(viewModel.selectedCountriesList.count, 1)
        XCTAssertEqual(viewModel.selectedCountriesList.first?.name?.common, "Egypt")
        
        // Verify cache was updated
        cachedCountries = mockCache.load()
        XCTAssertEqual(cachedCountries.count, 1)
        XCTAssertEqual(cachedCountries.first?.name?.common, "Egypt")
    }
}

