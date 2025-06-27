//
//  MockSelectedCountriesCache.swift
//  FindMyCountryTests
//
//  Created by Mohamed Youssef Al-Azizy on 27/06/2025.
//

import XCTest
import Combine
@testable import FindMyCountry

class MockSelectedCountriesCache: SelectedCountriesCachingManager {
    private var mockStorage = [String: Data]()
    
    override func save(_ countries: [Country]) {
        let encoder = JSONEncoder()
        mockStorage["storageKey"] = try? encoder.encode(countries)
    }
    
    override func load() -> [Country] {
        guard let data = mockStorage["storageKey"] else { return [] }
        let decoder = JSONDecoder()
        return (try? decoder.decode([Country].self, from: data)) ?? []
    }
    
    override func clear() {
        mockStorage.removeValue(forKey: "storageKey")
    }
}
