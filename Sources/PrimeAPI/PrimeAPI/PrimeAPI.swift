import Combine
import Foundation

public class PrimeAPI {
    var authorizationToken: String?
    
    private init() {}
    public static let shared = PrimeAPI()
    
    public var cancellables = Set<AnyCancellable>()
}
