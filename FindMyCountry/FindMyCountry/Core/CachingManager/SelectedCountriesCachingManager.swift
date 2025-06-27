//
//  SelectedCountriesCachingManager.swift
//  FindMyCountry
//
//  Created by Mohamed Youssef Al-Azizy on 27/06/2025.
//

import Foundation
import Combine


class SelectedCountriesCachingManager {
    
    private let userDefaults: UserDefaults
    private let storageKey: String
    
    init(userDefaults: UserDefaults = .standard, key: String = AppConstants.localizedText.selectedCountriesCacheKey) {
        self.userDefaults = userDefaults
        self.storageKey = key
    }
    
    func save(_ countries: [Country]) {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(countries) {
            userDefaults.set(data, forKey: storageKey)
        }
    }
    
    func load() -> [Country] {
        guard let data = userDefaults.data(forKey: storageKey) else { return [] }
        let decoder = JSONDecoder()
        return (try? decoder.decode([Country].self, from: data)) ?? []
    }
    
    func clear() {
        userDefaults.removeObject(forKey: storageKey)
    }
}
