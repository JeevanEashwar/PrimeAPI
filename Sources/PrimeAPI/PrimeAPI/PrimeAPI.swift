import Combine
import Foundation

public class PrimeAPI {
    /// Set this to true if you want to see the request and response objects in the console
    var enableLogging: Bool = false
    
    /// Set the token using `configureAuthorization` method if your API requests need authorization header
    var authorizationToken: String?
    
    /// By default it is `URLSession.shared`. Set this to a mockURLSession object to avoid actual API callsfor unit testing,
    var urlSession: URLSession
    
    private init() {
        urlSession = URLSession.shared
    }
    
    public static let shared = PrimeAPI()
    
    public var cancellables = Set<AnyCancellable>()
}
