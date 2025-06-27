//
//  RemoteCountriesRepositoryImpl.swift
//  FindMyCountry
//
//  Created by Mohamed Youssef Al-Azizy on 27/06/2025.
//

import Foundation
import Combine

final class RemoteCountriesRepositoryImpl: RemoteCountriesRepositoryContract {
    
    private let apiClient: APIClient
    
    init(apiClient: APIClient = NetworkService()) {
        self.apiClient = apiClient
    }
    
    func fetchCountries() -> AnyPublisher<[Country], APIClientError> {
        apiClient.performRequest(CountriesEndpoint.getAll)
    }
}
