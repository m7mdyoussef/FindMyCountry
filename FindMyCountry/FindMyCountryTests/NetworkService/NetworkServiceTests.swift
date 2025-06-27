//
//  NetworkServiceTests.swift
//  FindMyCountryTests
//
//  Created by Mohamed Youssef Al-Azizy on 27/06/2025.
//

import XCTest
import Combine
@testable import FindMyCountry

class NetworkServiceTests: XCTestCase {
    var cancellables = Set<AnyCancellable>()
    
    func testSuccessfulRequest() {
        // setup
        let mockSession = MockURLSession()
        let mockLogger = MockLogger()
        let mockBuilder = MockRequestBuilder()
        let mockValidator = MockValidator()
        
        let service = NetworkService(
            session: mockSession,
            requestBuilder: mockBuilder,
            validator: mockValidator,
            logger: mockLogger
        )
        
        let testModel = TestModel(value: 3)
        let testData = try! JSONEncoder().encode(testModel)
        
        mockSession.mockResponse = (
            data: testData,
            response: HTTPURLResponse(
                url: URL(string: "https://findMyCountry.com")!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!
        )
        
        mockValidator.dataToReturn = testData
        
        let expectation = XCTestExpectation(description: "Successful request")
        
        // when
        service.performRequest(TestEndpoint(path: "all", method: .get))
            .sink(receiveCompletion: { completion in
                if case .failure = completion {
                    XCTFail("Request should succeed")
                }
            }, receiveValue: { (result: TestModel) in
                XCTAssertEqual(result, testModel)
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        // Assertion
        wait(for: [expectation], timeout: 1)
        XCTAssertNotNil(mockLogger.loggedRequest)
        XCTAssertEqual(mockLogger.loggedResponse?.statusCode, 200)
    }
    
    func testNetworkError() {
        // given
        let mockSession = MockURLSession()
        mockSession.mockError = URLError(.notConnectedToInternet)
        
        let service = NetworkService(session: mockSession)
        let expectation = XCTestExpectation(description: "Network error")
        
        // when
        service.performRequest(TestEndpoint(path: "all", method: .get))
            .sink(receiveCompletion: { completion in
                switch completion {
                    case .failure(let error):
                        switch error {
                            case .apiError(let apiError):
                                XCTAssertEqual(apiError, .noInternet)
                                expectation.fulfill()
                            default:
                                XCTFail("Expected .apiError(.noInternet), Joe_error: \(error)")
                        }
                    case .finished:
                        XCTFail("Expected failure, got success")
                }
            }, receiveValue: { (_: TestModel) in
                XCTFail("Request should fail")
            })
            .store(in: &cancellables)
        
        // then
        wait(for: [expectation], timeout: 1)
    }
    
    func testRequestBuilderError() {
        // given
        let mockBuilder = MockRequestBuilder()
        mockBuilder.errorToThrow = APIError.invalidURL
        
        let service = NetworkService(requestBuilder: mockBuilder)
        let expectation = XCTestExpectation(description: "Request builder error")
        
        // when
        service.performRequest(TestEndpoint(path: "all", method: .get))
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    if case .apiError(let apiError) = error {
                        XCTAssertEqual(apiError, .invalidURL)
                        expectation.fulfill()
                    }
                }
            }, receiveValue: { (_: TestModel) in
                XCTFail("Request should fail")
            })
            .store(in: &cancellables)
        
        // then
        wait(for: [expectation], timeout: 1)
    }
    
    func testValidationError() {
        // given
        let mockSession = MockURLSession()
        let mockValidator = MockValidator()
        
        let testData = Data("{\"value\": \"test\"}".utf8)
        mockSession.mockResponse = (
            data: testData,
            response: HTTPURLResponse(
                url: URL(string: "https://findMyCountry.com")!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!
        )
        
        mockValidator.errorToThrow = APIClientError.apiError(.badRequest)
        
        let service = NetworkService(session: mockSession, validator: mockValidator)
        let expectation = XCTestExpectation(description: "Validation error")
        
        // when
        service.performRequest(TestEndpoint(path: "all", method: .get))
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    if case .apiError(let apiError) = error {
                        XCTAssertEqual(apiError, .badRequest)
                        expectation.fulfill()
                    }
                }
            }, receiveValue: { (_: TestModel) in
                XCTFail("Request should fail")
            })
            .store(in: &cancellables)
        
        // then
        wait(for: [expectation], timeout: 1)
    }
    
    func testDecodingError() {
        // given
        let mockSession = MockURLSession()
        let mockValidator = MockValidator()
        
        // Valid JSON but wrong type for decoding (TestModel expects Int but i provide String
        let testData = Data("{\"value\": \"string\"}".utf8)
        mockSession.mockResponse = (
            data: testData,
            response: HTTPURLResponse(
                url: URL(string: "https://findMyCountry.com")!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!
        )
        
        mockValidator.dataToReturn = testData
        
        let service = NetworkService(session: mockSession, validator: mockValidator)
        let expectation = XCTestExpectation(description: "Decoding error")
        
        // when
        let cancellable = service.performRequest(TestEndpoint(path: "all", method: .get))
            .sink(receiveCompletion: { completion in
                switch completion {
                    case .failure(let error):
                        switch error {
                            case .decoding:
                                expectation.fulfill()
                            default:
                                XCTFail("Expected decoding error, joe_error \(error)")
                        }
                    case .finished:
                        XCTFail("Request should fail with decoding error")
                }
            }, receiveValue: { (_: TestModel) in
                XCTFail("Request should fail")
            })
        
        cancellable.store(in: &cancellables)
        
        // then
        wait(for: [expectation], timeout: 1)
    }
    
    func testServerErrorWithCustomMessage() {
        // given
        let mockSession = MockURLSession()
        let mockValidator = MockValidator()
        
        let errorResponse = ServerErrorResponse(
            message: "Invalid parameters",
            errors: [ServerError(message: "Field X is required")]
        )
        let errorData = try! JSONEncoder().encode(errorResponse)
        
        mockSession.mockResponse = (
            data: errorData,
            response: HTTPURLResponse(
                url: URL(string: "https://findMyCountry.com")!,
                statusCode: 400,
                httpVersion: nil,
                headerFields: nil
            )!
        )
        
        mockValidator.errorToThrow = APIClientError.custom(message: "Invalid parameters")
        
        let service = NetworkService(session: mockSession, validator: mockValidator)
        let expectation = XCTestExpectation(description: "Server error with custom message")
        
        // when
        service.performRequest(TestEndpoint(path: "all", method: .get))
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    if case .custom(let message) = error {
                        XCTAssertEqual(message, "Invalid parameters")
                        expectation.fulfill()
                    }
                }
            }, receiveValue: { (_: TestModel) in
                XCTFail("Request should fail")
            })
            .store(in: &cancellables)
        
        // then
        wait(for: [expectation], timeout: 1)
    }
    
    func testRequestLogging() {
        // given
        let mockSession = MockURLSession()
        let mockLogger = MockLogger()
        
        let testData = Data("{\"value\": \"test\"}".utf8)
        mockSession.mockResponse = (
            data: testData,
            response: HTTPURLResponse(
                url: URL(string: "https://findMyCountry.com")!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!
        )
        
        let service = NetworkService(session: mockSession, logger: mockLogger)
        let expectation = XCTestExpectation(description: "Request logging")
        
        // when
        service.performRequest(TestEndpoint(path: "all", method: .get))
            .sink(receiveCompletion: { _ in
                expectation.fulfill()
            }, receiveValue: { (_: TestModel) in })
            .store(in: &cancellables)
        
        // then
        wait(for: [expectation], timeout: 1)
        XCTAssertNotNil(mockLogger.loggedRequest)
        XCTAssertEqual(mockLogger.loggedRequest?.httpMethod, "GET")
        XCTAssertNotNil(mockLogger.loggedResponse)
        XCTAssertEqual(mockLogger.loggedResponse?.statusCode, 200)
    }
    
    override func tearDown() {
        cancellables.removeAll()
        super.tearDown()
    }
}
