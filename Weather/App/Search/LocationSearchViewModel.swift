//
//  LocationSearchViewModel.swift
//  Weather
//
//  Created by Nicolas Bolzan on 09/06/2024.
//

import Foundation
import CoreLocation

final class LocationSearchViewModel {
    
    var placemarks: [CLPlacemark] = []
    
    func search(keyword : String,
                completion: @escaping(Result<Void, Error>) -> ()) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(keyword) { [weak self] (placemarks, error) in
            if let error {
                completion(.failure(error))
                return
            }
            self?.placemarks = placemarks ?? []
            completion(.success(()))
        }
    }
}
