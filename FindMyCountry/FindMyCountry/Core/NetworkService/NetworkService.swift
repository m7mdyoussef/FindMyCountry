//
//  NetworkService.swift
//  FindMyCountry
//
//  Created by Mohamed Youssef Al-Azizy on 27/06/2025.
//

import Foundation
import Combine

final class NetworkService: APIClient {
    
    private let session: URLSessionProtocol
    private let requestBuilder: URLRequestBuilderProtocol
    private let decoder: JSONDecoder
    private let validator: ResponseValidatorProtocol
    private let logger: LoggerProtocol
    
    init(
        session: URLSessionProtocol = URLSessionWrapper(),
        requestBuilder: URLRequestBuilderProtocol = URLRequestBuilder(),
        decoder: JSONDecoder = JSONDecoder(),
        validator: ResponseValidatorProtocol = ResponseValidator(),
        logger: LoggerProtocol = Logger.shared
    ) {
        self.session = session
        self.requestBuilder = requestBuilder
        self.decoder = decoder
        self.validator = validator
        self.logger = logger
    }
    
    func performRequest<T: Decodable>(_ endpoint: APIEndpoint) -> AnyPublisher<T, APIClientError> {
        do {
            var request = try requestBuilder.buildRequest(from: endpoint)
            request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
            logger.log(request: request)
            
            return session.dataTaskPublisher(for: request)
                .tryMap { [weak self] data, response in
                    self?.logger.log(response: response as! HTTPURLResponse, data: data)
                    return try self?.validator.validate(response: response, data: data, for: T.self) ?? data
                }
                .decode(type: T.self, decoder: decoder)
                .mapError { error in
                    if let urlError = error as? URLError {
                        switch urlError.code {
                            case .notConnectedToInternet:
                                return .apiError(.noInternet)
                            case .timedOut:
                                return .apiError(.requestTimeout)
                            default:
                                return .unknown(urlError)
                        }
                    } else if let decodingError = error as? DecodingError {
                        return .decoding(decodingError)
                    } else if let clientError = error as? APIClientError {
                        return clientError
                    } else {
                        return .unknown(error)
                    }
                }
                .receive(on: DispatchQueue.main)
                .eraseToAnyPublisher()
        } catch let error as APIError {
            return Fail(error: .apiError(error)).eraseToAnyPublisher()
        } catch {
            return Fail(error: .unknown(error)).eraseToAnyPublisher()
        }
    }
}
