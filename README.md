# PrimeAPI

**PrimeAPI** is a Swift package that simplifies making network calls and handling responses. It provides convenience methods to perform common HTTP methods such as GET, POST, PUT, PATCH, and DELETE, along with the ability to map responses to your custom models.

## Features

- Perform GET, POST, PUT, PATCH, and DELETE requests with ease.
- Map response data to your custom models using Swift's `Decodable` protocol.
- Option to set an authorization header for authenticated requests.
- Log request and response details for debugging.

## Installation

Add the **PrimeAPI** package to your Swift Package Manager project:

1. In Xcode, go to "File" > "Swift Packages" > "Add Package Dependency..."
2. Enter the package repository URL: `https://github.com/JeevanEashwar/PrimeAPI.git`
3. Follow the prompts to complete the installation.

## Usage

### Making GET Network Call

```swift
func makeGETNetworkCall() {
    guard let url = URL(string: "https://catfact.ninja/fact") else { return }
    PrimeAPI.shared.get(from: url, parameters: [:], mapResponseTo: Fact.self)
        .sink { completion in
            if case let .failure(error) = completion {
                print(error.localizedDescription)
            }
        } receiveValue: { fact in
            // Handle the fact object
        }
        .store(in: &cancellables)
}
```

### Making POST Network Call

```swift
func makePOSTNetworkCall() {
    guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else { return }
    let postBody: [String: Any] = [
        "title": "PrimeAPI",
        "body": "Hello world! -> PrimeAPI POST call testing",
        "userId": 1
    ]
    PrimeAPI.shared.post(to: url, parameters: [:], body: postBody, mapResponseTo: JSONPlaceholderPost.self)
        .sink { completion in
            if case let .failure(error) = completion {
                print(error.localizedDescription)
            }
        } receiveValue: { postObject in
            // Handle the postObject
        }
        .store(in: &cancellables)
}
```

### Adding Authorization Header (Optional)

```swift
// Configure the authorization header
PrimeAPI.shared.configureAuthorizationHeader(header: "your-access-token")
```

### Logging Request and Response Details

```swift
// Enable request and response logging
PrimeAPI.shared.logsRequestAndResponseToConsole(enable: true)

// Disable request and response logging
PrimeAPI.shared.logsRequestAndResponseToConsole(enable: false)
```

## Note

**Minimum iOS version required to use this Swift package is 13.0.0.**
