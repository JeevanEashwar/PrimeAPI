import XCTest
import Combine
@testable import PrimeAPI

struct Fact: Decodable {
    var fact: String
    var length: Int
}

var subjectUnderTest = PrimeAPI.shared

var assertingFlag: Bool = false
let assertingCallback = { (finished: Bool) in
    assertingFlag = finished
}
var successMockSession = MockPrimeAPISession_Success(completionHandler: assertingCallback)
var failureMockSession1 = MockPrimeAPISession_Failure(errorCode: .badURL, completionHandler: assertingCallback)

final class PrimeAPITests: XCTestCase {
    
    override class func setUp() {
        assertingFlag = false
    }
    
    override class func tearDown() {
        assertingFlag = false
    }
    
    func test_configureAuthorization() {
        let token = "<dummy-token>"
        subjectUnderTest.configureAuthorization(with: token)
        XCTAssertEqual(subjectUnderTest.authorizationToken, token)
    }
    
    func test_getCall_failure() {
        subjectUnderTest.setURLSession(session: failureMockSession1)
        let sampleURL = URL(string: "https://sampleurl.com")!
        _ = subjectUnderTest.get(from: sampleURL, parameters: [:], mapResponseTo: Fact.self)
        XCTAssertTrue(assertingFlag)
    }
    
    func test_getCall() {
        subjectUnderTest.setURLSession(session: successMockSession)
        subjectUnderTest.logsRequestAndResponseToConsole(enable: true)
        XCTAssertTrue(subjectUnderTest.enableLogging)
        let sampleURL = URL(string: "https://sampleurl.com")!
        _ = subjectUnderTest.get(from: sampleURL, parameters: [:], mapResponseTo: Fact.self)
        XCTAssertTrue(assertingFlag)
    }
    
    func test_postCall() {
        subjectUnderTest.setURLSession(session: successMockSession)
        let sampleURL = URL(string: "https://sampleurl.com")!
        _ = subjectUnderTest.post(to: sampleURL, parameters: [:], body: [:], mapResponseTo: Fact.self)
        XCTAssertTrue(assertingFlag)
    }

    func test_putCall() {
        subjectUnderTest.setURLSession(session: successMockSession)
        let sampleURL = URL(string: "https://sampleurl.com")!
        _ = subjectUnderTest.put(to: sampleURL, parameters: [:], body: [:], mapResponseTo: Fact.self)
        XCTAssertTrue(assertingFlag)
    }

    func test_patchCall() {
        subjectUnderTest.setURLSession(session: successMockSession)
        let sampleURL = URL(string: "https://sampleurl.com")!
        _ = subjectUnderTest.patch(to: sampleURL, parameters: [:], body: [:], mapResponseTo: Fact.self)
        XCTAssertTrue(assertingFlag)
    }

    func test_deleteCall() {
        subjectUnderTest.setURLSession(session: successMockSession)
        let sampleURL = URL(string: "https://sampleurl.com")!
        _ = subjectUnderTest.delete(to: sampleURL, mapResponseTo: Fact.self)
        XCTAssertTrue(assertingFlag)
    }

}
