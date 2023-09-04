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
    
    func setPath(_ path: String) -> URLRequestBuilder {
        self.path = path
        return self
    }
    
    func setMethod(_ method: HTTPMethod) -> URLRequestBuilder {
        self.method = method
        return self
    }
    
    func setHeaders(_ headers: [String: String]) -> URLRequestBuilder {
        self.headers = headers
        self.headers["Content-Type"] = "application/json"
        self.headers["Accept"] = "application/json"
        return self
    }
    
    func addHeader(key: String, value: String) -> URLRequestBuilder {
        headers[key] = value
        return self
    }
    
    func setQueryParameters(_ queryParameters: [String: String]?) -> URLRequestBuilder {
        self.queryParameters = queryParameters
        return self
    }
    
    func addQueryParameter(key: String, value: String) -> URLRequestBuilder {
        queryParameters?[key] = value
        return self
    }
    
    func setBody(_ body: Data?) -> URLRequestBuilder {
        self.body = body
        return self
    }
    
    func setBody(_ body: [String: Any?]?) -> URLRequestBuilder {
        if let body = body {
            let serializedData = try? JSONSerialization.data(withJSONObject: body, options: [])
            self.body = serializedData
        }
        return self
    }
    
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

