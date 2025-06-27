//
//  MockLocationManager.swift
//  FindMyCountryTests
//
//  Created by Mohamed Youssef Al-Azizy on 27/06/2025.
//

import XCTest
import Combine
@testable import FindMyCountry

class MockLocationManager: LocationManager {
    var mockUserCountry: String = ""
    override var userCountry: String {
        get { mockUserCountry }
        set { mockUserCountry = newValue }
    }
}
