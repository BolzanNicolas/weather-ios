//
//  WeatherService.swift
//  Weather
//
//  Created by Nicolas Bolzan on 08/06/2024.
//

import Foundation

// Aca se implemento una con async y otra con closure y asi ver las 2 opciones para este ejercicio
protocol WeatherService {
    func getExtendedWeather(
        latitude: Double,
        longitude: Double
    ) async throws -> ExtendedForecast
    
    func getCurrentWeather(
        latitude: Double,
        longitude: Double,
        completion: @escaping (Result<Forecast, Error>) -> ()
    )
}
