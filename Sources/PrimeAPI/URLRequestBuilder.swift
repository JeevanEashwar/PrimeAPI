//
//  URLRequestBuilder.swift
//  
//
//  Created by Jeevan on 04/09/23.
//

import Foundation
import Combine

public class URLRequestBuilder {
    private var baseURL: URL
    private var path: String = ""
    private var method: HTTPMethod = .GET
    private var headers: [String: String] = [:]
    private var queryParameters: [String: String]? = [:]
    private var body: Data?
    
    public init(baseURL: URL) {
        self.baseURL = baseURL
    }
    
    /// Set the path for the URL request.
    ///
    /// - Parameter path: The path component of the URL.
    /// - Returns: The `URLRequestBuilder` instance for method chaining.
    func setPath(_ path: String) -> URLRequestBuilder {
        self.path = path
        return self
    }
    
    /// Set the HTTP method for the URL request.
    ///
    /// - Parameter method: The HTTP method (e.g., GET, POST).
    /// - Returns: The `URLRequestBuilder` instance for method chaining.
    func setMethod(_ method: HTTPMethod) -> URLRequestBuilder {
        self.method = method
        return self
    }
    
    /// Set the headers for the URL request.
    ///
    /// - Parameter headers: A dictionary of headers to be added to the request.
    /// - Returns: The `URLRequestBuilder` instance for method chaining.
    func setHeaders(_ headers: [String: String]) -> URLRequestBuilder {
        self.headers = headers
        self.headers["Content-Type"] = "application/json"
        self.headers["Accept"] = "application/json"
        return self
    }
    
    /// Add a header to the URL request.
    ///
    /// - Parameters:
    ///   - key: The header key.
    ///   - value: The header value.
    /// - Returns: The `URLRequestBuilder` instance for method chaining.
    func addHeader(key: String, value: String) -> URLRequestBuilder {
        headers[key] = value
        return self
    }
    
    /// Set the query parameters for the URL request.
    ///
    /// - Parameter queryParameters: A dictionary of query parameters.
    /// - Returns: The `URLRequestBuilder` instance for method chaining.
    func setQueryParameters(_ queryParameters: [String: String]?) -> URLRequestBuilder {
        self.queryParameters = queryParameters
        return self
    }
    
    /// Add a query parameter to the URL request.
    ///
    /// - Parameters:
    ///   - key: The query parameter key.
    ///   - value: The query parameter value.
    /// - Returns: The `URLRequestBuilder` instance for method chaining.
    func addQueryParameter(key: String, value: String) -> URLRequestBuilder {
        queryParameters?[key] = value
        return self
    }
    
    /// Set the request body for the URL request using raw `Data`.
    ///
    /// - Parameter body: The request body as `Data`.
    /// - Returns: The `URLRequestBuilder` instance for method chaining.
    func setBody(_ body: Data?) -> URLRequestBuilder {
        self.body = body
        return self
    }
    
    /// Set the request body for the URL request using a dictionary that can be serialized to JSON.
    ///
    /// - Parameter body: A dictionary to be serialized as JSON for the request body.
    /// - Returns: The `URLRequestBuilder` instance for method chaining.
    func setBody(_ body: [String: Any?]?) -> URLRequestBuilder {
        if let body = body {
            let serializedData = try? JSONSerialization.data(withJSONObject: body, options: [])
            self.body = serializedData
        }
        return self
    }
    
    /// Build the URLRequest based on the configured settings.
    ///
    /// - Returns: The constructed `URLRequest` object.
    func build() -> URLRequest {
        // Construct the URL
        var urlComponents = URLComponents(url: self.baseURL, resolvingAgainstBaseURL: false)
        urlComponents?.path = self.path
        urlComponents?.queryItems = self.queryParameters?.map { URLQueryItem(name: $0, value: $1) }
        
        guard let url = urlComponents?.url else {
            fatalError("Invalid URL")
        }
        
        // Construct the URLRequest
        var request = URLRequest(url: url)
        request.httpMethod = self.method.rawValue
        request.allHTTPHeaderFields = self.headers
        request.httpBody = self.body
        
        return request
    }


}

