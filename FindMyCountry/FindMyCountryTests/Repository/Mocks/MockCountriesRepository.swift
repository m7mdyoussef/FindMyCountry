//
//  MockCountriesRepository.swift
//  FindMyCountryTests
//
//  Created by Mohamed Youssef Al-Azizy on 27/06/2025.
//

import XCTest
import Combine
@testable import FindMyCountry

class MockCountriesRepository: RemoteCountriesRepositoryContract {
    var countriesToReturn: AnyPublisher<[Country], APIClientError> =
    Fail(error: APIClientError.apiError(.badResponse)).eraseToAnyPublisher()
    
    func fetchCountries() -> AnyPublisher<[Country], APIClientError> {
        return countriesToReturn
    }
}
