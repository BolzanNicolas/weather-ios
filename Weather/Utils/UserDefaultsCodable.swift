//
//  UserDefaultsCodable.swift
//  Weather
//
//  Created by Nicolas Bolzan on 09/06/2024.
//

import Foundation

fileprivate let appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleName")!

protocol UserDefaultsCodable {}

extension UserDefaultsCodable where Self: Codable {
        
    static var userDefaultsKey: String {
        "\(appName)_CURRENT_\(String(describing: self))".uppercased()
    }
    
    static var current: Self? {
        get {
            guard
                let userJSON = UserDefaults.standard.object(forKey: userDefaultsKey),
                let userData = try? JSONSerialization.data(withJSONObject: userJSON, options: [])
            else { return nil }
            
            return try? JSONDecoder().decode(Self.self, from: userData)
        }
        set {
            guard
                let data = try? JSONEncoder().encode(newValue),
                let objectJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            else {
                UserDefaults.standard.set(nil, forKey: userDefaultsKey)
                return
            }
            
            UserDefaults.standard.set(objectJSON, forKey: userDefaultsKey)
        }
    }
}

struct ArrayCodable<T: Codable>: Codable, UserDefaultsCodable {
    var elements: [T] = []
}
