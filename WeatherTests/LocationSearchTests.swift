//
//  LocationSearchTests.swift
//  WeatherTests
//
//  Created by Nicolas Bolzan on 03/07/2024.
//

import XCTest
@testable import Weather

final class LocationSearchTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testInvalidCharacterThrowsError() {
        let sut = LocationSearchViewModel()
        
        sut.search(keyword: "$") { result in
            switch result {
            case .failure(let error):
                XCTAssertNotNil(error)
            default: break
            }
        }
    }
    
    func testValidCharacterSuccess() {
        let sut = LocationSearchViewModel()
        
        sut.search(keyword: "tandil") { result in
            switch result {
            case .failure:
                XCTFail()
            default: break
            }
        }
    }
    
    func testValidCharacterSuccess2() {
        let sut = LocationSearchViewModel()
        let expectation = expectation(description: "success")
        
        
        sut.search(keyword: "tandil") { result in
            switch result {
            case .success:
                expectation.fulfill()
            case .failure:
                XCTFail()
            }
        }
        
        waitForExpectations(timeout: 1) { error in
            if let _ = error {
                XCTFail()
            }
        }
    }
}
