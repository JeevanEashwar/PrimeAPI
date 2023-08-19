//
//  PrimeAPI+NetworkCall.swift
//  
//
//  Created by Jeevan on 31/07/23.
//

import Foundation
import Combine

extension PrimeAPI {
    /// Makes a network call with the specified configuration.
    ///
    /// - Parameters:
    ///   - url: The URL to which the network call will be made.
    ///   - parameters: A dictionary containing query parameters to be appended to the URL, if needed.
    ///   - body: A dictionary representing the request body, if applicable.
    ///   - httpMethod: The HTTP method to be used for the network call (e.g., "GET", "POST").
    ///   - model: The type to which the network response will be decoded.
    /// - Returns: A `Future` that emits the decoded response value of type `T` or an error of type `Error`.
    public func makeNetworkCall<T: Decodable>(
        url: URL,
        parameters: [String: Any]?,
        body: [String: Any]?,
        httpMethod: String,
        mapResponseTo model: T.Type
    ) -> Future<T, Error> {
        var finalUrl = url
        if let parameters = parameters {
            guard let queryAddedURL = addQueryParameters(to: url, using: parameters) else {
                return Future { promise in
                    promise(.failure(NetworkError.invalidURL))
                }
            }
            finalUrl = queryAddedURL
        }
        
        var request =  URLRequest(url: finalUrl)
        addBasicHeaders(to: &request, httpMethod: httpMethod, body: body)
        
        return Future<T, Error> { [weak self] promise in
            guard let self = self else {
                promise(.failure(NetworkError.unknown))
                return
            }
            URLSession.shared.dataTaskPublisher(for: request)
                .tryMap { (data, response) -> Data in
                    guard let httpResponse = response as? HTTPURLResponse,
                          (200...299).contains(httpResponse.statusCode) else {
                        throw NetworkError.responseError
                    }
                    self.logRequestDetails(url: url, headers: request.allHTTPHeaderFields, httpMethod: httpMethod, requestBody: body)
                    self.logResponseDetails(response: httpResponse, responseBody: data)
                    return data
                }
                .tryMap { data in
                    do {
                        let decodedObject = try JSONDecoder().decode(T.self, from: data)
                        return decodedObject
                    } catch {
                        print("Decoding Error: \(error)")
                        throw error
                    }
                }
                .receive(on: RunLoop.main)
                .sink(receiveCompletion: {(completion) in
                    if case let .failure(error) = completion {
                        switch error {
                        case let decodingError as DecodingError:
                            promise(.failure(decodingError))
                        case let apiError as NetworkError:
                            promise(.failure(apiError))
                        default:
                            promise(.failure(NetworkError.unknown))
                        }
                    }
                }, receiveValue: { value in
                    promise(.success(value))
                })
                .store(in: &self.cancellables)
        }
    }
}
