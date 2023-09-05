//
//  PrimeAPI+Helpers.swift
//
//
//  Created by Jeevan on 31/07/23.
//

import Foundation
import Combine

extension PrimeAPI {
    
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
    
    /// Enable or disable logging of network requests and responses to the console.
    public func logsRequestAndResponseToConsole(enable: Bool) {
        self.enableLogging = enable
    }
    
    /// Set a custom URLSession for network requests.
    /// By default it is `URLSession.shared`. Set this to a mockURLSession object to avoid actual API callsfor unit testing,
    public func setURLSession(session: PrimeAPISession) {
        self.urlSession = session
    }
    
    /// takes a reference of Data task publisher and logs the request and response
    public func getDataTaskPublisher(request: URLRequest) -> AnyPublisher<Data, Error> {
        return self.urlSession.getSessionPublisher(request: request)
            .tryMap { (data, response) -> Data in
                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    throw NetworkError.responseError
                }
                if (self.enableLogging) {
                    self.logRequestDetails(url: request.url, headers: request.allHTTPHeaderFields, httpMethod: request.httpMethod, requestBody: self.dataToDictionary(data: request.httpBody))
                    self.logResponseDetails(response: httpResponse, responseBody: data)
                }
                return data
            }
            .eraseToAnyPublisher()
    }
    
    /// Print request details in the console
    func logRequestDetails(
        url: URL?,
        headers: [String: String]?,
        httpMethod: String?,
        requestBody: [String: Any]?
    ) {
        print("################# NETWORK CALL REQUEST ####################")
        print("Request URL: \(String(describing: url))")
        print("HTTP method: \(String(describing: httpMethod))")
        
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
    
    /// Converts a Data object containing JSON data into a dictionary of [String: Any].
    ///
    /// - Parameters:
    ///   - data: The Data object to be deserialized into a dictionary.
    /// - Returns: A dictionary of [String: Any] if deserialization succeeds; otherwise, nil.
    func dataToDictionary(data: Data?) -> [String: Any]? {
        do {
            // Check if the input data is not nil and attempt JSON deserialization.
            if let data = data, let dictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                // If deserialization succeeds, return the resulting dictionary.
                return dictionary
            }
        } catch {
            // If an error occurs during deserialization, catch and handle the error.
            print("Error deserializing data to dictionary: \(error)")
        }
        
        // Return nil if deserialization fails or if input data is nil.
        return nil
    }
    
}
