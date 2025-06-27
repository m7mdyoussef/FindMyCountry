//
//  MockAPIClient.swift
//  FindMyCountryTests
//
//  Created by Mohamed Youssef Al-Azizy on 27/06/2025.
//

import XCTest
import Combine
@testable import FindMyCountry

class MockAPIClient: APIClient {
    var countriesToReturn: Result<[Country], APIClientError> = .failure(.apiError(.badResponse))
    
    func performRequest<T>(_ endpoint: APIEndpoint) -> AnyPublisher<T, APIClientError> where T : Decodable {
        return countriesToReturn.publisher
            .tryMap { $0 as! T }
            .mapError { $0 as! APIClientError }
            .eraseToAnyPublisher()
    }
}
