//
//  MockURLSession.swift
//  
//
//  Created by Jeevan on 05/09/23.
//

import Foundation
import Combine
@testable import PrimeAPI

// Define your custom publisher that emits a single value.
class MockDataTaskPublisher: Publisher {
    typealias Output = URLSession.DataTaskPublisher.Output
    typealias Failure = URLSession.DataTaskPublisher.Failure
    
    private let output: Output?
    private let failure: Failure?
    
    init(output: Output? = nil, failure: Failure? = nil) {
        self.output = output
        self.failure = failure
    }
    
    func receive<S>(subscriber: S) where S : Subscriber, Failure == S.Failure, Output == S.Input {
        let subscription = MockDataTaskSubscription(subscriber: subscriber, output: output)
        subscriber.receive(subscription: subscription)
    }
}

// Define your custom subscription.
class MockDataTaskSubscription<S>: Subscription where S: Subscriber, S.Input == URLSession.DataTaskPublisher.Output, S.Failure == URLSession.DataTaskPublisher.Failure {
    private var subscriber: S?
    private let output: URLSession.DataTaskPublisher.Output?
    private let failure: URLSession.DataTaskPublisher.Failure?
    
    init(subscriber: S, output: URLSession.DataTaskPublisher.Output? = nil, failure: URLSession.DataTaskPublisher.Failure? = nil) {
        self.subscriber = subscriber
        self.output = output
        self.failure = failure
    }
    
    func request(_ demand: Subscribers.Demand) {
        // Emit the predefined output to the subscriber.
        if let output = output {
            _ = subscriber?.receive(output)
            subscriber?.receive(completion: .finished)
        } else if let failure = failure {
            _ = subscriber?.receive(completion: .failure(URLError(URLError.Code(rawValue: failure.errorCode))))
        }
        
    }
    
    func cancel() {
        subscriber = nil
    }
}

class MockPrimeAPISession_Success: PrimeAPISession {
    init(completionHandler: @escaping (_ finished: Bool) -> Void) {
        self.completionHandler = completionHandler
    }
    var completionHandler: (_ finished: Bool) -> Void
    func getSessionPublisher(request: URLRequest) -> AnyPublisher<URLSession.DataTaskPublisher.Output, URLSession.DataTaskPublisher.Failure> {
        // Define your stubbed JSON response data here.
        completionHandler(true)
        let stubbedCatFactData = """
            {
              "fact": "In Holland’s embassy in Moscow, Russia, the staff noticed that the two Siamese cats kept meowing and clawing at the walls of the building. Their owners finally investigated, thinking they would find mice. Instead, they discovered microphones hidden by Russian spies. The cats heard the microphones when they turned on.",
              "length": 318
            }
            """.data(using: .utf8)!
        
        // Create a custom MockDataTaskPublisher with the predefined output.
        let output = URLSession.DataTaskPublisher.Output(data: stubbedCatFactData, response: HTTPURLResponse())
        let mockPublisher = MockDataTaskPublisher(output: output)
        
        // Return the custom publisher.
        return AnyPublisher(mockPublisher)
    }
}

class MockPrimeAPISession_Failure: PrimeAPISession {
    var errorCode: URLError.Code
    init(errorCode: URLError.Code, completionHandler: @escaping (_ finished: Bool) -> Void) {
        self.completionHandler = completionHandler
        self.errorCode = errorCode
    }
    var completionHandler: (_ finished: Bool) -> Void
    func getSessionPublisher(request: URLRequest) -> AnyPublisher<URLSession.DataTaskPublisher.Output, URLSession.DataTaskPublisher.Failure> {
        // Define your stubbed JSON response data here.
        completionHandler(true)
        
        // Create a custom MockDataTaskPublisher with the predefined output.
        let failure = URLSession.DataTaskPublisher.Failure(self.errorCode)
        let mockPublisher = MockDataTaskPublisher(failure: failure)
        
        // Return the custom publisher.
        return AnyPublisher(mockPublisher)
    }
}
