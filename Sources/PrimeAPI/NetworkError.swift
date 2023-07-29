//
//  NetworkError.swift
//  
//
//  Created by Jeevan on 29/07/23.
//

import Foundation

public enum NetworkError: Error {
    case invalidURL
    case responseError
    case unknown
}

extension NetworkError {
    public var errorDescription: String {
        switch self {
        case .invalidURL:
            return "Invalid URL input given to the request"
        case .responseError:
            return "Invalid response received, unexpected status code"
        default:
            return self.localizedDescription
        }
    }
}
