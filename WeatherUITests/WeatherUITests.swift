//
//  WeatherUITests.swift
//  WeatherUITests
//
//  Created by Nicolas Bolzan on 11/07/2024.
//

import XCTest

final class WeatherUITests: XCTestCase {

    let app = XCUIApplication()
    
    override func setUp() {
        app.launch()
    }
    
    func testTableInitialRows() {
        let table = app.tables.matching(identifier: "mainTable")
        XCTAssertEqual(table.cells.count, 0)
    }
}
