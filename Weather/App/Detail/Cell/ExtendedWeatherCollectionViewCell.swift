//
//  ExtendedWeatherCollectionViewCell.swift
//  Weather
//
//  Created by Nicolas Bolzan on 09/06/2024.
//

import UIKit

final class ExtendedWeatherCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var weatherImageView: UIImageView!
    @IBOutlet private weak var weatherDescriptionLabel: UILabel!
    @IBOutlet private weak var temperatureLabel: UILabel!
    
    static var size: CGSize {
        CGSize(width: 75, height: 105)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        timeLabel.text = nil
        weatherImageView.image = nil
        weatherDescriptionLabel.text = nil
        temperatureLabel.text = nil
    }
    
    func setup(with forecast: Forecast) {
        timeLabel.text = forecast.date?.toString(format: .time)
        weatherImageView.image = UIImage(named: forecast.weather?.first?.icon ?? "")
        weatherDescriptionLabel.text = forecast.weather?.first?.main
        temperatureLabel.text = "\(Int(forecast.main?.temperature ?? 0))°"
    }
}
