//
//  URLRequestBuilder.swift
//  FindMyCountry
//
//  Created by Mohamed Youssef Al-Azizy on 27/06/2025.
//

import Foundation

protocol URLRequestBuilderProtocol {
    func buildRequest(from endpoint: APIEndpoint) throws -> URLRequest
}

final class URLRequestBuilder: URLRequestBuilderProtocol {
    
    func buildRequest(from endpoint: APIEndpoint) throws -> URLRequest {
        var url = endpoint.baseURL.appendingPathComponent(endpoint.path)
        
        if case let .urlQuery(params) = endpoint.apiType {
            url = addQueryParams(params ?? [:], to: url)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        endpoint.headers?.forEach { request.setValue($0.value, forHTTPHeaderField: $0.key) }
        
        if case let .jsonBody(body) = endpoint.apiType {
            request.httpBody = try? JSONSerialization.data(withJSONObject: body ?? [:])
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        return request
    }
    
    private func addQueryParams(_ params: [String: Any], to url: URL) -> URL {
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        components.queryItems = params.map {
            URLQueryItem(name: $0.key, value: "\($0.value)")
        }
        return components.url ?? url
    }
}
