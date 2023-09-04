import Foundation
import Combine

extension PrimeAPI {
    /// Performs an HTTP GET request to the specified URL.
    ///
    /// - Parameters:
    ///   - url: The URL to which the GET request will be made.
    ///   - parameters: A dictionary containing query parameters to be appended to the URL, if needed.
    ///   - model: The type to which the response will be decoded.
    /// - Returns: A `Future` that emits the decoded response value of type `T` or an error of type `Error`.
    public func get<T: Decodable>(from url: URL, parameters: [String: String]?, mapResponseTo model: T.Type) -> Future<T, Error> {
        return makeNetworkCall(url: url, parameters: parameters, body: nil, httpMethod: HTTPMethod.GET, mapResponseTo: model)
    }
    
    /// Performs an HTTP POST request to the specified URL.
    ///
    /// - Parameters:
    ///   - url: The URL to which the POST request will be made.
    ///   - parameters: A dictionary containing query parameters to be included in the request URL.
    ///   - body: A dictionary representing the request body.
    ///   - model: The type to which the response will be decoded.
    /// - Returns: A `Future` that emits the decoded response value of type `T` or an error of type `Error`.
    public func post<T: Decodable>(to url: URL, parameters: [String: String], body: [String: Any], mapResponseTo model: T.Type) -> Future<T, Error> {
        return makeNetworkCall(url: url, parameters: parameters, body: body, httpMethod: HTTPMethod.POST, mapResponseTo: model)
    }
    
    /// Performs an HTTP PUT request to the specified URL.
    ///
    /// - Parameters:
    ///   - url: The URL to which the PUT request will be made.
    ///   - parameters: A dictionary containing query parameters to be included in the request URL.
    ///   - body: A dictionary representing the request body.
    ///   - model: The type to which the response will be decoded.
    /// - Returns: A `Future` that emits the decoded response value of type `T` or an error of type `Error`.
    public func put<T: Decodable>(to url: URL, parameters: [String: String], body: [String: Any], mapResponseTo model: T.Type) -> Future<T, Error> {
        return makeNetworkCall(url: url, parameters: parameters, body: body, httpMethod: HTTPMethod.PUT, mapResponseTo: model)
    }
    
    /// Performs an HTTP PATCH request to the specified URL.
    ///
    /// - Parameters:
    ///   - url: The URL to which the PATCH request will be made.
    ///   - parameters: A dictionary containing query parameters to be included in the request URL.
    ///   - body: A dictionary representing the request body.
    ///   - model: The type to which the response will be decoded.
    /// - Returns: A `Future` that emits the decoded response value of type `T` or an error of type `Error`.
    public func patch<T: Decodable>(to url: URL, parameters: [String: String], body: [String: Any], mapResponseTo model: T.Type) -> Future<T, Error> {
        return makeNetworkCall(url: url, parameters: parameters, body: body, httpMethod: HTTPMethod.PATCH, mapResponseTo: model)
    }
    
    /// Performs an HTTP DELETE request to the specified URL.
    ///
    /// - Parameters:
    ///   - url: The URL to which the DELETE request will be made.
    ///   - model: The type to which the response will be decoded.
    /// - Returns: A `Future` that emits the decoded response value of type `T` or an error of type `Error`.
    public func delete<T: Decodable>(to url: URL, mapResponseTo model: T.Type) -> Future<T, Error> {
        return makeNetworkCall(url: url, parameters: nil, body: nil, httpMethod: HTTPMethod.DELETE, mapResponseTo: model)
    }
}
