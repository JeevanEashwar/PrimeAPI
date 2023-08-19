//
//  PrimeAPI+Helpers.swift
//
//
//  Created by Jeevan on 31/07/23.
//

import Foundation

extension PrimeAPI {
    /// Adds query parameters to a given URL.
    ///
    /// - Parameters:
    ///   - url: The URL to which the query parameters will be added.
    ///   - parameters: A dictionary containing the query parameters to be added.
    /// - Returns: The modified URL with the added query parameters, or nil if the URL components cannot be constructed.
    public func addQueryParameters(
        to url: URL,
        using parameters: [String: Any]
    ) -> URL? {
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
        let queryItems = parameters.map { URLQueryItem(name: $0.key, value: String(describing: $0.value)) }
        urlComponents?.queryItems = queryItems
        guard let finalURL = urlComponents?.url else {
            return nil
        }
        return finalURL
    }
    
    /// Adds basic headers to a URLRequest.
    ///
    /// - Parameters:
    ///   - request: The inout URLRequest to which the headers will be added.
    ///   - httpMethod: The HTTP method to be set for the request.
    ///   - body: A dictionary representing the request body, if applicable.
    public func addBasicHeaders(
        to request: inout URLRequest,
        httpMethod: String,
        body: [String: Any]?
    ) {
        request.httpMethod = httpMethod
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        if let authorizationHeader = authorizationToken {
            request.addValue("Bearer \(authorizationHeader)", forHTTPHeaderField: "Authorization")
        }
        if let body = body {
            request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        }
    }
    
    /// Configures the authorization header for future network requests.
    ///
    /// - Parameter token: The authorization token value to be set. Do not include Bearer.
    /// - Note: This method sets the authorization header for the PrimeAPI instance,
    ///         and the configured header will be used in all subsequent network calls
    ///         made using this instance.
    ///
    /// - Important: Be cautious when including sensitive authorization information
    ///              in the header value, and ensure that the header value is properly
    ///              formatted according to the authentication requirements.
    ///
    public func configureAuthorization(with token: String) {
        self.authorizationToken = token
    }
    
    public func logsRequestAndResponseToConsole(enable: Bool) {
        self.enableLogging = enable
    }
    
    /// Print request details in the console
    func logRequestDetails(
        url: URL,
        headers: [String: String]?,
        httpMethod: String,
        requestBody: [String: Any]?
    ) {
        print("################# NETWORK CALL REQUEST ####################")
        print("Request URL: \(url)")
        
        if let headers = headers {
            print("Headers:")
            for (key, value) in headers {
                print("   \(key): \(value)")
            }
        }
        
        if let requestBody = requestBody {
            print("Request Body:")
            print(requestBody)
        }
    }
    
    /// Print response details in the console
    func logResponseDetails(
        response: HTTPURLResponse,
        responseBody: Data
    ) {
        print("################# NETWORK CALL RESPONSE ####################")
        print("Response Code: \(response.statusCode)")
        if let responseString = String(data: responseBody, encoding: .utf8) {
            print("Response Body:")
            print(responseString)
        } else {
            print("Response Body could not be converted to String.")
        }
        print("################# END ####################")
    }
}
