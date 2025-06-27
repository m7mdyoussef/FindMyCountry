//
//  RemoteCountriesRepositoryContract.swift
//  FindMyCountry
//
//  Created by Mohamed Youssef Al-Azizy on 27/06/2025.
//

import Combine

protocol RemoteCountriesRepositoryContract {
    func fetchCountries() -> AnyPublisher<[Country], APIClientError>
}
