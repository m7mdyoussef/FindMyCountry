//
//  URLSessionProtocol.swift
//  FindMyCountry
//
//  Created by Mohamed Youssef Al-Azizy on 27/06/2025.
//

import Foundation
import Combine

protocol URLSessionProtocol {
    func dataTaskPublisher(for request: URLRequest) -> AnyPublisher<(data: Data, response: URLResponse), URLError>
}

struct URLSessionWrapper: URLSessionProtocol {
    let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func dataTaskPublisher(for request: URLRequest) -> AnyPublisher<(data: Data, response: URLResponse), URLError> {
        return session.dataTaskPublisher(for: request)
            .map { ($0.data, $0.response) }
            .eraseToAnyPublisher()
    }
}
