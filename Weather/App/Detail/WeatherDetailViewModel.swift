//
//  WeatherDetailViewModel.swift
//  Weather
//
//  Created by Nicolas Bolzan on 09/06/2024.
//

import Foundation

final class WeatherDetailViewModel {
    
    private let service: WeatherService
    private let coordinates: Coordinates
    
    weak var delegate: WeatherDetailDelegate?
    
    var name: String
    var weatherDetail: [[Forecast]] = []
    
    init(service: WeatherService, name: String, coordinates: Coordinates) {
        self.service = service
        self.name = name
        self.coordinates = coordinates
    }
    
    func getWeatherDetail() async throws -> Bool {
        guard let latitude = coordinates.latitude,
                let longitude = coordinates.longitude
        else { return false }
        
        do {
            let extendedWeather = try await service.getExtendedWeather(
                latitude: latitude,
                longitude: longitude
            )
            
            weatherDetail = Array(Dictionary(grouping: extendedWeather.list ?? []) {
                return $0.date?.toString(format: .fullDay)
            }.values)
            .sorted {
                ($0.first?.date ?? Date()) < ($1.first?.date ?? Date())
            }
            
            delegate?.didLoadDetail()
            return true
        } catch(let error) {
            delegate?.showError(error)
            throw error
        }
    }
}

protocol WeatherDetailDelegate: AnyObject {
    func showError(_ error: Error)
    func didLoadDetail()
}

