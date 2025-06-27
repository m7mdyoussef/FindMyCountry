//
//  Constants.swift
//  FindMyCountry
//
//  Created by Mohamed Youssef Al-Azizy on 27/06/2025.
//

import Foundation

struct AppConstants {
    
    struct AppError {
        static let badResponse = "Bad Response: The request could not be completed due to network error or no response."
        static let badRequest = "Bad Request: The server cannot process the request due to a client error."
        static let unauthorized = "Unauthorized: Authentication is required and has failed or has not been provided."
        static let forbidden = "Forbidden: You do not have the necessary permissions for the resource."
        static let notFound = "Not Found: The requested resource could not be found."
        static let methodNotAllowed = "Method Not Allowed: The request method is not supported for the requested resource."
        static let conflict = "Conflict: The request could not be processed because of conflict in the request."
        static let internalServerError = "Internal Server Error: The server encountered an unexpected condition that prevented it from fulfilling the request."
        static let serviceUnavailable = "Service Unavailable: The server is currently unable to handle the request due to a temporary overloading or maintenance of the server."
        static let requestTimeout = "Request time out"
        static let invalidURL = "Invalid URL"
        static let noConnection = "No Internet Connection, plaese try again"
        static let SomeThingWentWrong = "Something went wrong"
    }
    
    struct localizedText {
        
        static let egypt = "Egypt"
        static let FindMyCountry = "Find My Country"
        static let countryDetails = "Country Details"
        static let done = "Done"
        static let emptyListHint = "Oops, No Data Found You Can Add Up to 5 Countries."
        static let onlyFiveCountriesAllowed = "You Can't Add more than 5 Countries."
        
        static let search = "Search"
        static let searchCountries = "Search Countries"
        static let defaultCountry = "Default country :"
        static let otherCountry = "other countries :"
        static let addCountryButtonTitle = "Add Country"
        static let currency = "Currency: "
        static let country = "Country: "
        static let capital = "Capital: "
        static let languages = "Languages: "
        static let alertDeleteConfirmation = "Confirmation!"
        static let alertDeleteDescription = "Are you sure that you want to delete this country?"
        static let cancel = "Cancel"
        static let delete = "Delete"
        static let error = "Error"
        static let retry = "Retry"
        static let OK = "OK"
        static let selectedCountriesCacheKey = "SelectedCountriesCacheKey"
        static let refreshing = "Refreshing..."
        static let checkConnection = "Something went wrong, You nedd to check your Internet Connection and try again"

    }
}
