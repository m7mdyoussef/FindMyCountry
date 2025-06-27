//
//  MockCountriesUseCase.swift
//  FindMyCountryTests
//
//  Created by Mohamed Youssef Al-Azizy on 27/06/2025.
//

import XCTest
import Combine
@testable import FindMyCountry

class MockCountriesUseCase: RemoteCountriesUseCaseContract {
    var result: Result<[Country], APIClientError> = .success([])
    private(set) var fetchCalled = false
    
    func executeFetchCountries() -> AnyPublisher<[Country], APIClientError> {
        fetchCalled = true
        return result.publisher.eraseToAnyPublisher()
    }
}
