//
//  ExtendedForecast.swift
//  Weather
//
//  Created by Nicolas Bolzan on 09/06/2024.
//

import Foundation

struct ExtendedForecast: Codable {
    let list: [Forecast]?
    let city: City?
}
