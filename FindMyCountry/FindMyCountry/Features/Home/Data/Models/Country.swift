//
//  Country.swift
//  FindMyCountry
//
//  Created by Mohamed Youssef Al-Azizy on 27/06/2025.
//

import Foundation

// MARK: - Country
struct Country: Codable, Hashable, Identifiable {
    let flags: Flags?
    let name: CountryName?
    let cca2: String?
    let currencies: [String: Currency]?
    let capital: [String]?
    let region: Region?
    let subregion: String?
    let languages: [String: String]?
    let population: Int?
    let timezones: [String]?
    
    var id: String {
        cca2 ?? UUID().uuidString
    }
}

// MARK: - Currency
struct Currency: Codable, Hashable {
    let name, symbol: String
}

// MARK: - Flags
struct Flags: Codable, Hashable {
    let png: String?
    let svg: String?
    let alt: String?
}

// MARK: - CountryName
struct CountryName: Codable, Hashable {
    let common, official: String?
    let nativeName: [String: NativeName]?
}

// MARK: - NativeName
struct NativeName: Codable, Hashable {
    let official, common: String?
}

enum Region: String, Codable {
    case africa = "Africa"
    case americas = "Americas"
    case antarctic = "Antarctic"
    case asia = "Asia"
    case europe = "Europe"
    case oceania = "Oceania"
}

