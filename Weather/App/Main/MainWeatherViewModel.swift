//
//  MainWeatherViewModel.swift
//  Weather
//
//  Created by Nicolas Bolzan on 08/06/2024.
//

import Foundation
import CoreLocation

final class MainWeatherViewModel: NSObject {
    
    let service: WeatherService
    
    /// Al tener los delegates de tipo weak no va a hacer falta sacar la referencia en deinit
    weak var delegate: MainWeatherDelegate?
    
    var forecasts: [Forecast] = []
    private var locations: [CLLocationCoordinate2D]
    
    var currentLocation: CLLocationCoordinate2D?
    
    var canAddLocation: Bool
    
    init(service: WeatherService, localCoordinates: [CLLocationCoordinate2D]) {
        self.locations = localCoordinates
        self.canAddLocation = localCoordinates.count < 6
        self.service = service
        super.init()
        
        for location in locations {
            getCurrentWeather(for: location)
        }
    }
    
    func removeLocation(at index: Int) {
        guard let coordinates = forecasts[index].coordinates else { return }
        
        var localCoordinates = ArrayCodable<Forecast>.current?.elements ?? []
        localCoordinates.removeAll(where: { $0.coordinates == coordinates })
        ArrayCodable<Forecast>.current = .init(elements: localCoordinates)
        
        forecasts.remove(at: index)
        canAddLocation = forecasts.count < 6
        delegate?.didLoadForecast()
    }
    
    func getCurrentWeather(for location: CLLocationCoordinate2D,
                           completion: ((Result<Forecast, Error>) -> ())? = nil) {
        service.getCurrentWeather(
            latitude: location.latitude,
            longitude: location.longitude) { [weak self] result in
                completion?(result)
                
                switch result {
                case .failure(let error):
                    self?.delegate?.showError(error)
                    
                case .success(let forecast):
                    var forecasts = self?.forecasts ?? []
                    forecasts.append(forecast)
                    let setForecasts = Array(Set(forecasts))
                    self?.forecasts = setForecasts
                    self?.canAddLocation = forecasts.count < 6
                    self?.delegate?.didLoadForecast()
                    ArrayCodable<Forecast>.current = .init(elements: setForecasts)
                }
        }
    }
}

protocol MainWeatherDelegate: AnyObject {
    func showError(_ error: Error)
    func didLoadForecast()
}
