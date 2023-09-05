//
//  URLRequestBuilderTests.swift
//  
//
//  Created by Jeevan on 05/09/23.
//

import XCTest
import Foundation

@testable import PrimeAPI

class URLRequestBuilderTests: XCTestCase {
    // Mock URL for testing
    let baseURL = URL(string: "https://example.com")!
    
    func testBuildGETRequest() {
        let request = URLRequestBuilder(baseURL: baseURL)
            .setPath("/api/resource")
            .setMethod(.GET)
            .setAcceptHeader()
            .build()
        
        XCTAssertEqual(request.httpMethod, "GET")
        XCTAssertEqual(request.allHTTPHeaderFields?["Accept"], "application/json")
        XCTAssertNil(request.httpBody)
    }
    
    func testSetHeaders() {
        let customHeaders = ["CustomHeader1": "Value1", "CustomHeader2": "Value2"]
        let request = URLRequestBuilder(baseURL: baseURL)
            .setHeaders(customHeaders)
            .build()
        
        XCTAssertEqual(request.allHTTPHeaderFields?["CustomHeader1"], "Value1")
        XCTAssertEqual(request.allHTTPHeaderFields?["CustomHeader2"], "Value2")
    }
    
    func testAddQueryParameters() {
        let request = URLRequestBuilder(baseURL: baseURL)
            .addQueryParameter(key: "param1", value: "value1")
            .addQueryParameter(key: "param2", value: "value2")
            .build()
        
        let queryItems = URLComponents(url: request.url!, resolvingAgainstBaseURL: false)?.queryItems
        XCTAssertNotNil(queryItems)
        
        XCTAssertEqual(queryItems?.count, 2)
    }
    
    func testSetQueryParameters() {
        let queryParameters: [String: String] = ["param1": "value1", "param2": "value2"]
        let request = URLRequestBuilder(baseURL: baseURL)
            .setQueryParameters(queryParameters)
            .build()
        
        let queryItems = URLComponents(url: request.url!, resolvingAgainstBaseURL: false)?.queryItems
        XCTAssertNotNil(queryItems)
        
        XCTAssertEqual(queryItems?.count, 2)
    }
    
    func testSetRequestBodyFromDictionary() {
        let requestBody = ["key1": "value1", "key2": "value2"]
        let request = URLRequestBuilder(baseURL: baseURL)
            .setBody(requestBody)
            .build()
        
        XCTAssertNotNil(request.httpBody)
    }
    
    func testSetRequestBodyFromData() {
        let requestBodyData = "Test Data".data(using: .utf8)
        let request = URLRequestBuilder(baseURL: baseURL)
            .setBody(requestBodyData)
            .build()
        
        XCTAssertEqual(request.httpBody, requestBodyData)
    }
    
    func testAddHeader() {
        let customHeaderKey = "CustomHeader"
        let customHeaderValue = "CustomValue"
        
        let request = URLRequestBuilder(baseURL: baseURL)
            .addHeader(key: customHeaderKey, value: customHeaderValue)
            .build()
        
        XCTAssertEqual(request.allHTTPHeaderFields?[customHeaderKey], customHeaderValue)
    }
    
    func testSetContentTypeHeader() {
        let request = URLRequestBuilder(baseURL: baseURL)
            .setContentTypeHeader()
            .build()
        
        XCTAssertEqual(request.allHTTPHeaderFields?[Constants.ContentTypeHeader], Constants.ApplicationJSONValue)
    }
}

