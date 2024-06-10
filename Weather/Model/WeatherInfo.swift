//
//  WeatherInfo.swift
//  Weather
//
//  Created by Nicolas Bolzan on 08/06/2024.
//

import Foundation

struct WeatherInfo: Codable {
    let temperature: Double?
    let feelsLike: Double?
    let tempMin: Double?
    let tempMax: Double?
    let humidity: Int?
    
    enum CodingKeys: String, CodingKey {
        case temperature = "temp"
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case humidity
    }
}
