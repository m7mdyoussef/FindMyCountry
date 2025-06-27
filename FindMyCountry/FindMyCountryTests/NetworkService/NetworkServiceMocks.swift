//
//  NetworkServiceMocks.swift
//  FindMyCountryTests
//
//  Created by Mohamed Youssef Al-Azizy on 27/06/2025.
//

import XCTest
import Combine
@testable import FindMyCountry

// MARK: - Mocks
class MockURLSession: URLSessionProtocol {
    var mockResponse: (data: Data, response: URLResponse)?
    var mockError: URLError?
    
    func dataTaskPublisher(for request: URLRequest) -> AnyPublisher<(data: Data, response: URLResponse), URLError> {
        if let error = mockError {
            return Fail(error: error).eraseToAnyPublisher()
        }
        
        guard let response = mockResponse else {
            return Fail(error: URLError(.badServerResponse)).eraseToAnyPublisher()
        }
        
        return Just(response)
            .setFailureType(to: URLError.self)
            .eraseToAnyPublisher()
    }
}

class MockLogger: LoggerProtocol {
    var loggedRequest: URLRequest?
    var loggedResponse: HTTPURLResponse?
    var loggedData: Data?
    
    func log(request: URLRequest) {
        loggedRequest = request
    }
    
    func log(response: HTTPURLResponse, data: Data) {
        loggedResponse = response
        loggedData = data
    }
}

class MockRequestBuilder: URLRequestBuilderProtocol {
    var requestToReturn: URLRequest?
    var errorToThrow: Error?
    
    func buildRequest(from endpoint: APIEndpoint) throws -> URLRequest {
        if let error = errorToThrow {
            throw error
        }
        return requestToReturn ?? URLRequest(url: URL(string: "https://findMyCountry.com")!)
    }
}

class MockValidator: ResponseValidatorProtocol {
    var dataToReturn: Data?
    var errorToThrow: Error?
    
    func validate<T>(response: URLResponse?, data: Data?, for type: T.Type) throws -> Data where T : Decodable {
        if let error = errorToThrow {
            throw error
        }
        return dataToReturn ?? data!
    }
}

struct TestModel: Codable, Equatable {
    let value: Int
}

struct TestEndpoint: APIEndpoint {
    var path: String
    var method: HTTPMethod
    var apiType: APIType?
}
