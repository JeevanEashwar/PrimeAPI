import Combine
import Foundation

public class PrimeAPI {
    /// Set this to true if you want to see the request and response objects in the console
    var enableLogging: Bool = false
    
    var authorizationToken: String?
    
    private init() {}
    public static let shared = PrimeAPI()
    
    public var cancellables = Set<AnyCancellable>()
}
