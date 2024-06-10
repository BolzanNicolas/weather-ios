//
//  MainWeatherTableViewCell.swift
//  Weather
//
//  Created by Nicolas Bolzan on 08/06/2024.
//

import UIKit

final class MainWeatherTableViewCell: UITableViewCell {

    @IBOutlet private weak var mainDescriptionLabel: UILabel!
    @IBOutlet private weak var maxMinLabel: UILabel!
    @IBOutlet private weak var cityLabel: UILabel!
    @IBOutlet private weak var humidityLabel: UILabel!
    @IBOutlet private weak var feelsLikeLabel: UILabel!
    @IBOutlet private weak var temperatureLabel: UILabel!
    @IBOutlet private weak var iconImageView: UIImageView!
    
    func setup(with forecast: Forecast) {
        cityLabel.text = forecast.name
        mainDescriptionLabel.text = forecast.weather?.first?.main
        
        let max = Int(forecast.main?.tempMax ?? 0)
        let min = Int(forecast.main?.tempMin ?? 0)
        maxMinLabel.text = "Max.: \(max) Min.: \(min)"
        
        humidityLabel.text = "\(forecast.main?.humidity ?? 0)%"
        feelsLikeLabel.text = "\(Int(forecast.main?.feelsLike ?? 0))°"
        temperatureLabel.text = "\(Int(forecast.main?.temperature ?? 0))°"
        iconImageView.image = UIImage(named: forecast.weather?.first?.icon ?? "")
    }
}
