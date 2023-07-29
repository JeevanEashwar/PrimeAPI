import Combine
import Foundation

public class PrimeAPI {
    private init() {}
    public static let shared = PrimeAPI()
    
    private var cancellables = Set<AnyCancellable>()
    
    public func get<T: Decodable>(from url: URL, parameters: [String: Any], mapResponseTo model: T.Type) -> Future<T, Error> {
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
        let queryItems = parameters.map { URLQueryItem(name: $0.key, value: String(describing: $0.value)) }
        urlComponents?.queryItems = queryItems
        
        guard let finalURL = urlComponents?.url else {
            return Future { promise in
                promise(.failure(NetworkError.invalidURL))
            }
        }
        return Future<T, Error> { [weak self] promise in
            guard let self = self else {
                promise(.failure(NetworkError.unknown))
                return
            }
            print(finalURL)
            URLSession.shared.dataTaskPublisher(for: finalURL)
                .tryMap { (data, response) -> Data in
                    guard let httpResponse = response as? HTTPURLResponse,
                          (200...299).contains(httpResponse.statusCode) else {
                        throw NetworkError.responseError
                    }
                    return data
                }
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
