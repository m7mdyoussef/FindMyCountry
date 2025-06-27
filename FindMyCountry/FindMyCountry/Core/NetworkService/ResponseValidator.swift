//
//  ResponseValidator.swift
//  FindMyCountry
//
//  Created by Mohamed Youssef Al-Azizy on 27/06/2025.
//

import Foundation
protocol ResponseValidatorProtocol {
    func validate<T: Decodable>(response: URLResponse?, data: Data?, for type: T.Type) throws -> Data
}

struct ResponseValidator: ResponseValidatorProtocol {
    func validate<T: Decodable>(response: URLResponse?, data: Data?, for type: T.Type) throws -> Data {
        guard let httpResponse = response as? HTTPURLResponse, let nonOptionalData = data as Data? else {
            throw APIClientError.apiError(.badResponse)
        }
        
        switch httpResponse.statusCode {
            case 200...299:
                
                return nonOptionalData
            default:
                if let serverError = try? JSONDecoder().decode(ServerErrorResponse.self, from: nonOptionalData),
                   let message = serverError.message ?? serverError.errors?.first?.message {
                    throw APIClientError.custom(message: message)
                } else if let knownError = APIError(rawValue: httpResponse.statusCode) {
                    throw APIClientError.apiError(knownError)
                } else {
                    throw APIClientError.custom(message: "Unexpected error. Code: \(httpResponse.statusCode)")
                }
        }
    }
}
