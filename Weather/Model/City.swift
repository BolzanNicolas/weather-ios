//
//  City.swift
//  Weather
//
//  Created by Nicolas Bolzan on 09/06/2024.
//

import Foundation

struct City: Codable {
    let id: Int?
    let name: String?
    let coordinates: Coordinates?
    let sunrise: Date?
    let sunset: Date?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(Int.self, forKey: .id)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.coordinates = try container.decodeIfPresent(Coordinates.self, forKey: .coordinates)
        let sunriseDt = try container.decodeIfPresent(Double.self, forKey: .sunrise)
        self.sunrise = sunriseDt == nil ? nil : Date(timeIntervalSince1970: sunriseDt!)
        let sunsetDt = try container.decodeIfPresent(Double.self, forKey: .sunset)
        self.sunset = sunsetDt == nil ? nil : Date(timeIntervalSince1970: sunsetDt!)
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case coordinates = "coord"
        case sunrise
        case sunset
    }
}
