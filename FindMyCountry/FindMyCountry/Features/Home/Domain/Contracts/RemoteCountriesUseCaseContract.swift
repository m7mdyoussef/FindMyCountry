//
//  RemoteCountriesUseCaseContract.swift
//  FindMyCountry
//
//  Created by Mohamed Youssef Al-Azizy on 27/06/2025.
//

import Combine

protocol RemoteCountriesUseCaseContract {
    func executeFetchCountries() -> AnyPublisher<[Country], APIClientError>
}
