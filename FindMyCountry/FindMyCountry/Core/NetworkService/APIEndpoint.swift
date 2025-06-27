//
//  APIEndpoint.swift
//  FindMyCountry
//
//  Created by Mohamed Youssef Al-Azizy on 27/06/2025.
//

import Foundation

public typealias DictionryAny = [String: Any]

public protocol APIEndpoint {
    var baseURL: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var apiType: APIType? { get }
}

extension APIEndpoint {
    var baseURL: URL {
        return URL(string: URLs.baseURL.rawValue)!
    }
    
    var headers: [String: String]? {
        return nil
    }
}

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

public enum APIType {
    case jsonBody(_ JSON: DictionryAny? = nil)
    case urlQuery(_ Dictionry: DictionryAny? = nil)
}

public enum APIError: Int, Error {
    case badResponse = 0
    case badRequest = 400
    case unauthorized = 401
    case forbidden = 403
    case notFound = 404
    case methodNotAllowed = 405
    case conflict = 409
    case internalServerError = 500
    case serviceUnavailable = 503
    case requestTimeout = 508
    case invalidURL = 1212121
    case noInternet = -1009
    
    var errorDescription: String {
        switch self {
            case .badResponse: return AppConstants.AppError.badResponse
            case .badRequest: return AppConstants.AppError.badRequest
            case .unauthorized: return AppConstants.AppError.unauthorized
            case .forbidden: return AppConstants.AppError.forbidden
            case .notFound: return AppConstants.AppError.notFound
            case .methodNotAllowed: return AppConstants.AppError.methodNotAllowed
            case .conflict: return AppConstants.AppError.conflict
            case .internalServerError: return AppConstants.AppError.internalServerError
            case .serviceUnavailable: return AppConstants.AppError.serviceUnavailable
            case .requestTimeout: return AppConstants.AppError.requestTimeout
            case .invalidURL: return AppConstants.AppError.invalidURL
            case .noInternet: return AppConstants.AppError.noConnection
        }
    }
}

struct ServerErrorResponse: Codable {
    let message: String?
    let errors: [ServerError]?
}

struct ServerError: Codable {
    let message: String
}

public enum APIClientError: LocalizedError, Equatable {
    case apiError(APIError)
    case custom(message: String)
    case decoding(Error)
    case unknown(Error)
    
    public var errorDescription: String {
        switch self {
            case .apiError(let apiError):
                return apiError.errorDescription
            case .custom(let message):
                return message
            case .decoding(let error), .unknown(let error):
                return error.localizedDescription
        }
    }
    
    public static func == (lhs: APIClientError, rhs: APIClientError) -> Bool {
        switch (lhs, rhs) {
            case (.apiError(let lhsError), .apiError(let rhsError)):
                return lhsError == rhsError
            case (.custom(let lhsMsg), .custom(let rhsMsg)):
                return lhsMsg == rhsMsg
            case (.decoding(let lhsError), .decoding(let rhsError)):
                return lhsError.localizedDescription == rhsError.localizedDescription
            case (.unknown(let lhsError), .unknown(let rhsError)):
                return lhsError.localizedDescription == rhsError.localizedDescription
            default:
                return false
        }
    }
}
