//
//  SearchResultTableViewCell.swift
//  Weather
//
//  Created by Nicolas Bolzan on 09/06/2024.
//

import UIKit
import CoreLocation

final class SearchResultTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var resultLabel: UILabel!
    
    static let HEIGHT: CGFloat = 44
    
    func setup(with placemark: CLPlacemark) {
        let address = [placemark.name, placemark.administrativeArea, placemark.country]
            .compactMap { $0 }
            .joined(separator: ", ")
        resultLabel.text = address
    }
}
