//
//  RemoteCountriesUseCaseImpl.swift
//  FindMyCountry
//
//  Created by Mohamed Youssef Al-Azizy on 27/06/2025.
//

import Foundation
import Combine

final class RemoteCountriesUseCaseImpl: RemoteCountriesUseCaseContract {
    
    private let repo: RemoteCountriesRepositoryContract
    
    init(repo: RemoteCountriesRepositoryContract = RemoteCountriesRepositoryImpl()) {
        self.repo = repo
    }
    
    func executeFetchCountries() -> AnyPublisher<[Country], APIClientError> {
        repo.fetchCountries()
    }
}
