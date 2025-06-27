//
//  RemoteCountriesUseCaseTests.swift
//  FindMyCountryTests
//
//  Created by Mohamed Youssef Al-Azizy on 27/06/2025.
//

import XCTest
import Combine
@testable import FindMyCountry

class RemoteCountriesUseCaseTests: XCTestCase {
    
    var cancellables = Set<AnyCancellable>()
    var mockRepository: MockCountriesRepository!
    var useCase: RemoteCountriesUseCaseImpl!
    
    // MARK: - Test Data
    private let usaCountry = Country(
        flags: Flags(png: "us.png", svg: "us.svg", alt: "US Flag"),
        name: CountryName(common: "United States", official: "USA", nativeName: ["eng": NativeName(official: "USA", common: "United States")]),
        cca2: "US",
        currencies: ["USD": Currency(name: "Dollar", symbol: "$")],
        capital: ["Washington D.C."],
        region: .americas,
        subregion: "North America",
        languages: ["eng": "English"],
        population: 331000000,
        timezones: ["UTC-12:00"]
    )
    
    private let ukCountry = Country(
        flags: Flags(png: "uk.png", svg: "uk.svg", alt: "UK Flag"),
        name: CountryName(common: "United Kingdom", official: "UK", nativeName: ["eng": NativeName(official: "UK", common: "United Kingdom")]),
        cca2: "GB",
        currencies: ["GBP": Currency(name: "Pound", symbol: "£")],
        capital: ["London"],
        region: .europe,
        subregion: "Northern Europe",
        languages: ["eng": "English"],
        population: 67000000,
        timezones: ["UTC+00:00"]
    )
    
    // MARK: - Setup
    
    override func setUp() {
        super.setUp()
        mockRepository = MockCountriesRepository()
        useCase = RemoteCountriesUseCaseImpl(repo: mockRepository)
    }
    
    override func tearDown() {
        cancellables.removeAll()
        mockRepository = nil
        useCase = nil
        super.tearDown()
    }
    
    // MARK: - Success Tests
    func test_executeFetchCountries_returnsCountries() {
        // Given
        let expectedCountries = [usaCountry, ukCountry]
        mockRepository.countriesToReturn = Just(expectedCountries)
            .setFailureType(to: APIClientError.self)
            .eraseToAnyPublisher()
        
        let expectation = expectation(description: "Should return countries")
        
        // When
        useCase.executeFetchCountries()
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTFail("Expected success, joe_error : \(error)")
                }
            }, receiveValue: { countries in
                // Then
                XCTAssertEqual(countries.count, 2)
                XCTAssertEqual(countries[0].name?.common, "United States")
                XCTAssertEqual(countries[1].capital?.first, "London")
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    // MARK: - Failure Tests
    func test_executeFetchCountries_whenRepositoryFails_returnsError() {
        // Given
        let expectedError = APIClientError.apiError(.noInternet)
        mockRepository.countriesToReturn = Fail(error: expectedError)
            .eraseToAnyPublisher()
        
        let expectation = expectation(description: "Should return error")
        
        // When
        useCase.executeFetchCountries()
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    // Then
                    switch (error, expectedError) {
                        case (.apiError(let receivedError), .apiError(let expectedError)):
                            XCTAssertEqual(receivedError, expectedError)
                        default:
                            XCTFail("Error types don't match")
                    }
                    expectation.fulfill()
                }
            }, receiveValue: { _ in
                XCTFail("Expected failure")
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_executeFetchCountries_whenRepositoryReturnsEmptyArray_returnsEmptyArray() {
        // Given
        mockRepository.countriesToReturn = Just([])
            .setFailureType(to: APIClientError.self)
            .eraseToAnyPublisher()
        
        let expectation = expectation(description: "Should return empty array")
        
        // When
        useCase.executeFetchCountries()
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTFail("Expected success, joe_error: \(error)")
                }
            }, receiveValue: { countries in
                // Then
                XCTAssertTrue(countries.isEmpty)
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    // MARK: - Edge Cases
    func test_executeFetchCountries_whenRepositoryReturnsDecodingError_propagatesError() {
        // Given
        let expectedError = APIClientError.decoding(NSError(domain: "test", code: -1, userInfo: nil))
        mockRepository.countriesToReturn = Fail(error: expectedError)
            .eraseToAnyPublisher()
        
        let expectation = expectation(description: "Should propagate decoding error")
        
        // When
        useCase.executeFetchCountries()
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    // Then
                    if case .decoding = error {
                        expectation.fulfill()
                    } else {
                        XCTFail("Expected decoding error")
                    }
                }
            }, receiveValue: { _ in
                XCTFail("Expected failure")
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_executeFetchCountries_whenRepositoryReturnsCustomError_propagatesError() {
        // Given
        let expectedError = APIClientError.custom(message: "Joe error")
        mockRepository.countriesToReturn = Fail(error: expectedError)
            .eraseToAnyPublisher()
        
        let expectation = expectation(description: "Should propagate custom error")
        
        // When
        useCase.executeFetchCountries()
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    // Then
                    if case .custom(let message) = error {
                        XCTAssertEqual(message, "Joe error")
                        expectation.fulfill()
                    } else {
                        XCTFail("Expected custom error")
                    }
                }
            }, receiveValue: { _ in
                XCTFail("Expected failure")
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
}

