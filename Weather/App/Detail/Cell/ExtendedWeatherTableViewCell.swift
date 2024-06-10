//
//  ExtendedWeatherTableViewCell.swift
//  Weather
//
//  Created by Nicolas Bolzan on 09/06/2024.
//

import UIKit

final class ExtendedWeatherTableViewCell: UITableViewCell {

    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var collectionView: UICollectionView!
    
    private var extendedWeather: [Forecast] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.register(cellType: ExtendedWeatherCollectionViewCell.self)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func setup(with weather: [Forecast]) {
        dateLabel.text = weather.first?.date?.toString(format: .fullDay)
        extendedWeather = weather
        collectionView.reloadData()
    }
}

extension ExtendedWeatherTableViewCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return extendedWeather.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(cellType: ExtendedWeatherCollectionViewCell.self, at: indexPath)
        let forecast = extendedWeather[indexPath.item]
        cell.setup(with: forecast)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return ExtendedWeatherCollectionViewCell.size
    }
}
