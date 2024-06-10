//
//  Date+Extension.swift
//  Weather
//
//  Created by Nicolas Bolzan on 09/06/2024.
//

import Foundation

extension Date {
    enum DateFormat: String {
        case fullDay = "MMMM d, yyyy"
        case time = "hh:mm a"
    }
    
    func toString(format: DateFormat) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.rawValue
        return dateFormatter.string(from: self)
    }
}
