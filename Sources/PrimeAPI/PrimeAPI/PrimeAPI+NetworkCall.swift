//
//  PrimeAPI+NetworkCall.swift
//  
//
//  Created by Jeevan on 31/07/23.
//

import Foundation
import Combine

public protocol PrimeAPISession {
    func getSessionPublisher(request: URLRequest) -> AnyPublisher<URLSession.DataTaskPublisher.Output, URLSession.DataTaskPublisher.Failure>
}

extension URLSession: PrimeAPISession {
    public func getSessionPublisher(request: URLRequest) -> AnyPublisher<URLSession.DataTaskPublisher.Output, URLSession.DataTaskPublisher.Failure> {
        return URLSession.shared.dataTaskPublisher(for: request).eraseToAnyPublisher()
    }
}

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
        parameters: [String: String]?,
        body: [String: Any]?,
        httpMethod: HTTPMethod,
        mapResponseTo model: T.Type
    ) -> Future<T, Error> {
        let requestBuilder = URLRequestBuilder(baseURL: url)
            .setMethod(httpMethod)
            .setQueryParameters(parameters)
            .setBody(body)
            .setAcceptHeader()
            .setContentTypeHeader()
        
        return Future<T, Error> { [weak self] promise in
            guard let self = self else {
                promise(.failure(NetworkError.unknown))
                return
            }
            let request = requestBuilder.build()
            self.getDataTaskPublisher(request: request)
                .decode(type: T.self, decoder: JSONDecoder())
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
