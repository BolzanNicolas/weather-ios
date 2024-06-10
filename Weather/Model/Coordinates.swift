//
//  Coordinates.swift
//  Weather
//
//  Created by Nicolas Bolzan on 08/06/2024.
//

import Foundation

struct Coordinates: Codable, Hashable {
    let latitude: Double?
    let longitude: Double?
    
    enum CodingKeys: String, CodingKey {
        case latitude = "lat"
        case longitude = "lon"
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(latitude)
        hasher.combine(longitude)
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}
