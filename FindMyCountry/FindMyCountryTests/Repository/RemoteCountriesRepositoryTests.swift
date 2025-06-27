//
//  RemoteCountriesRepositoryTests.swift
//  FindMyCountryTests
//
//  Created by Mohamed Youssef Al-Azizy on 27/06/2025.
//

import XCTest
import Combine
@testable import FindMyCountry

class RemoteCountriesRepositoryTests: XCTestCase {
    var cancellables = Set<AnyCancellable>()
    var mockAPIClient: MockAPIClient!
    var repository: RemoteCountriesRepositoryImpl!
    
    override func setUp() {
        super.setUp()
        mockAPIClient = MockAPIClient()
        repository = RemoteCountriesRepositoryImpl(apiClient: mockAPIClient)
    }
    
    override func tearDown() {
        cancellables.removeAll()
        super.tearDown()
    }
    
    func testFetchCountriesSuccess() {
        // given
        let expectedCountries = [
            Country(
                flags: Flags(png: "https://flagcdn.com/w320/us.png", svg: "https://flagcdn.com/us.svg", alt: "US Flag"),
                name: CountryName(
                    common: "United States",
                    official: "United States of America",
                    nativeName: ["eng": NativeName(official: "United States of America", common: "United States")]
                ),
                cca2: "US",
                currencies: ["USD": Currency(name: "United States dollar", symbol: "$")],
                capital: ["Washington, D.C."],
                region: .americas,
                subregion: "North America",
                languages: ["eng": "English"],
                population: 329484123,
                timezones: ["UTC-12:00", "UTC-11:00", "UTC-10:00", "UTC-09:00"]
            )
        ]
        
        mockAPIClient.countriesToReturn = .success(expectedCountries)
        let expectation = XCTestExpectation(description: "Fetch countries succeeds")
        
        // when
        repository.fetchCountries()
            .sink(receiveCompletion: { completion in
                if case .failure = completion {
                    XCTFail("Expected success")
                }
            }, receiveValue: { countries in
                // then
                XCTAssertEqual(countries.first?.capital?.first, "Washington, D.C.")
                XCTAssertEqual(countries.first?.name?.common, "United States")
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testNetworkError() {
        // given
        let mockSession = MockURLSession()
        mockSession.mockError = URLError(.notConnectedToInternet)
        
        let service = NetworkService(session: mockSession)
        let expectation = XCTestExpectation(description: "Network error")
        
        // when
        service.performRequest(TestEndpoint(path: "test", method: .get))
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    // Assert
                    if case .apiError(let apiError) = error {
                        XCTAssertEqual(apiError, .noInternet)
                    } else {
                        XCTFail("Expected .apiError(.noInternet), joe_error \(error)")
                    }
                    expectation.fulfill()
                }
            }, receiveValue: { (_: TestModel) in
                XCTFail("Request should fail")
            })
            .store(in: &cancellables)
        
        // then
        wait(for: [expectation], timeout: 1)
    }
}

