import Combine
import XCTest
@testable import SubVTData

final class ReportServiceTests: XCTestCase {
    private var cancellables: Set<AnyCancellable>!
    private let service = ReportService()
    private let validatorAccountIdHex = "0xa00505eb2a4607f27837f57232f0c456602e39540582685b4f58cde293f1a116"
    
    override func setUp() {
        super.setUp()
        cancellables = []
    }
    
    func test01GetSingleEraReport() {
        let expectation = self.expectation(description: "Single era report request.")
        var error: APIError? = nil
        var reports = [EraReport]()
        service.getEraReport(startEraIndex: 3200)
            .sink { (dataResponse) in
                if dataResponse.error != nil {
                    error = dataResponse.error
                } else {
                    reports.append(contentsOf: dataResponse.value!)
                }
                expectation.fulfill()
            }
            .store(in: &cancellables)
        waitForExpectations(timeout: 5)
        XCTAssertNil(error)
        XCTAssertEqual(1, reports.count)
    }
    
    func test02GetMultipleEraReport() {
        let expectation = self.expectation(description: "Single era report request.")
        var error: APIError? = nil
        var reports = [EraReport]()
        service.getEraReport(startEraIndex: 3201, endEraIndex: 3210)
            .sink { (dataResponse) in
                if dataResponse.error != nil {
                    error = dataResponse.error
                } else {
                    reports.append(contentsOf: dataResponse.value!)
                }
                expectation.fulfill()
            }
            .store(in: &cancellables)
        waitForExpectations(timeout: 5)
        
        XCTAssertNil(error)
        XCTAssertEqual(10, reports.count)
    }
    
    func test03GetSingleEraValidatorReport() {
        let expectation = self.expectation(description: "Single era validator report request.")
        var error: APIError? = nil
        var reports = [EraValidatorReport]()
        service.getEraValidatorReport(
            validatorAccountId: AccountId(hex: validatorAccountIdHex),
            startEraIndex: 3200
        )
            .sink { (dataResponse) in
                if dataResponse.error != nil {
                    error = dataResponse.error
                } else {
                    reports.append(contentsOf: dataResponse.value!)
                }
                expectation.fulfill()
            }
            .store(in: &cancellables)
        waitForExpectations(timeout: 5)
        
        XCTAssertNil(error)
        XCTAssertEqual(1, reports.count)
    }
    
    func test04GetMultipleEraValidatorReport() {
        let expectation = self.expectation(description: "Single era validator report request.")
        var error: APIError? = nil
        var reports = [EraValidatorReport]()
        service.getEraValidatorReport(
            validatorAccountId: AccountId(hex: validatorAccountIdHex),
            startEraIndex: 3275,
            endEraIndex: 3279
        )
            .sink { (dataResponse) in
                if dataResponse.error != nil {
                    error = dataResponse.error
                } else {
                    reports.append(contentsOf: dataResponse.value!)
                }
                expectation.fulfill()
            }
            .store(in: &cancellables)
        waitForExpectations(timeout: 5)
        
        XCTAssertNil(error)
        XCTAssertEqual(5, reports.count)
    }
    
    static var allTests = [
        ("test01GetSingleEraReport", test01GetSingleEraReport),
        ("test02GetMultipleEraReport", test02GetMultipleEraReport),
        ("test03GetSingleEraValidatorReport", test03GetSingleEraValidatorReport),
        ("test04GetMultipleEraValidatorReport", test04GetMultipleEraValidatorReport),
    ]
}
