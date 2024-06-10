//
//  NetworkingManager.swift
//  Weather
//
//  Created by Nicolas Bolzan on 08/06/2024.
//

import Foundation

enum NetworkError: Error {
    case invalidStatusCode
    case invalidData
    case invalidResponse
}

final class NetworkingManager: WeatherService {
    private let BASE_URL = "https://api.openweathermap.org/data/2.5/"
    private let API_KEY = "8f659ee04465630ae305664ed1d240c0"
        
    func getExtendedWeather(latitude: Double, longitude: Double) async throws -> ExtendedForecast {
        let urlRequest: URLRequest
        var components = URLComponents(string: BASE_URL + "forecast")!
        
        components.queryItems = [
            "lat" : latitude,
            "lon" : longitude,
            "units" : "metric",
            "appid" : API_KEY
        ].compactMap { (key, value) in
            URLQueryItem(name: key, value: "\(value)")
        }
        
        urlRequest = URLRequest(url: components.url!, timeoutInterval: 60)
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard let response = response as? HTTPURLResponse, 200 ... 299  ~= response.statusCode else {
            throw NetworkError.invalidStatusCode
        }
        
        do {
            return try JSONDecoder().decode(ExtendedForecast.self, from: data)
        } catch {
            throw NetworkError.invalidResponse
        }
    }
    
    func getCurrentWeather(latitude: Double, longitude: Double, completion: @escaping (Result<Forecast, Error>) -> ()) {
        let urlRequest: URLRequest
        var components = URLComponents(string: BASE_URL + "weather")!
        
        components.queryItems = [
            "lat" : latitude,
            "lon" : longitude,
            "units" : "metric",
            "appid" : API_KEY
        ].compactMap { (key, value) in
            URLQueryItem(name: key, value: "\(value)")
        }
        
        urlRequest = URLRequest(url: components.url!, timeoutInterval: 60)
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard let data else {
                completion(.failure(NetworkError.invalidData))
                return
            }
            guard let response = response as? HTTPURLResponse, 200 ... 299  ~= response.statusCode else {
                completion(.failure(NetworkError.invalidStatusCode))
                return
            }
            
            do {
                let response = try JSONDecoder().decode(Forecast.self, from: data)
                completion(.success(response))
            } catch {
                completion(.failure(NetworkError.invalidResponse))
            }
        }.resume()
    }
}
