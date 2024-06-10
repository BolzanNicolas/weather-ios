//
//  Forecast.swift
//  Weather
//
//  Created by Nicolas Bolzan on 07/06/2024.
//

import Foundation

struct Forecast: Codable, Hashable {
    
    let coordinates: Coordinates?
    let weather: [Weather]?
    let date: Date?
    let name: String?
    let main: WeatherInfo?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.coordinates = try container.decodeIfPresent(Coordinates.self, forKey: .coordinates)
        self.weather = try container.decodeIfPresent([Weather].self, forKey: .weather)
        let dt = try container.decodeIfPresent(Double.self, forKey: .date)
        self.date = dt == nil ? nil : Date(timeIntervalSince1970: dt!)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.main = try container.decodeIfPresent(WeatherInfo.self, forKey: .main)
    }
    
    enum CodingKeys: String, CodingKey {
        case coordinates = "coord"
        case weather
        case date = "dt"
        case name
        case main
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(coordinates)
        hasher.combine(name)
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.coordinates == rhs.coordinates && lhs.name == rhs.name
    }
}
