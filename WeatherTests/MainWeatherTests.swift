//
//  MainWeatherTests.swift
//  WeatherTests
//
//  Created by Nicolas Bolzan on 07/06/2024.
//

import XCTest
import CoreLocation
@testable import Weather

final class MainWeatherTests: XCTestCase {

    func testAllowAddLocationWithZeroLocationsSaved() {
        let sut = MainWeatherViewModel(service: NetworkingManager(), localCoordinates: [])
        XCTAssertTrue(sut.canAddLocation)
    }
    
    func testDenyAddLocationWithSixLocationsSaved() {
        let coordinates: [CLLocationCoordinate2D] = [
            .init(latitude: 1, longitude: 1),
            .init(latitude: 2, longitude: 2),
            .init(latitude: 3, longitude: 3),
            .init(latitude: 4, longitude: 4),
            .init(latitude: 5, longitude: 5),
            .init(latitude: 6, longitude: 6)
        ]
        let sut = MainWeatherViewModel(service: NetworkingManager(), localCoordinates: coordinates)
        XCTAssertFalse(sut.canAddLocation)
    }
    
    func testGetWeatherFailureWithInvalidCoordinates() throws {
        let sut = MainWeatherViewModel(service: NetworkingManager(), localCoordinates: [])
        let expectation = expectation(description: "successfully failed")
        
        sut.getCurrentWeather(for: .init(latitude: -305.9, longitude: 1)) { result in
            switch result {
            case .success:
                XCTFail()
            case .failure:
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 1)
    }
    
    func testGetWeatherSuccessWithValidCoordinates() throws {
        let sut = MainWeatherViewModel(service: NetworkingManager(), localCoordinates: [])
        let expectation = expectation(description: "success")
        var forecast: Forecast?
        
        sut.getCurrentWeather(for: .init(latitude: 0, longitude: 0)) { result in
            switch result {
            case .success(let value):
                forecast = value
                expectation.fulfill()
                
            case .failure:
                XCTFail()
            }
        }
        
        waitForExpectations(timeout: 3)
        
        XCTAssertNotNil(forecast)
    }
}
