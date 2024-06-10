//
//  WeatherDetailTests.swift
//  WeatherTests
//
//  Created by Nicolas Bolzan on 09/06/2024.
//

import XCTest
import CoreLocation
@testable import Weather

final class WeatherDetailTests: XCTestCase {

    func testGetDetailFailureWithInvalidCoordinates() async throws {
        let sut = WeatherDetailViewModel(
            service: NetworkingManager(),
            name: "Test",
            coordinates: .init(latitude: -305.9, longitude: 1)
        )
        
        do {
            _ = try await sut.getWeatherDetail()
        } catch(let error) {
            XCTAssertNotNil(error)
        }
    }
    
    func testGetDetailSuccessWithValidCoordinates() async throws {
        let sut = WeatherDetailViewModel(
            service: NetworkingManager(),
            name: "Test",
            coordinates: .init(latitude: 0, longitude: 0)
        )
        
        Task {
            let success = try await sut.getWeatherDetail()
            XCTAssertTrue(success)
        }
    }
    
}
