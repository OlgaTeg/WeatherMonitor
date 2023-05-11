//
//  ListCell.swift
//  WeatherMonitor
//
//  Created by Olga Tegza on 02.05.2023.
//

import UIKit

class ListCell: UITableViewCell {

    @IBOutlet var nameCityLabel: UILabel!
    @IBOutlet var conditionCityLabel: UILabel!
    @IBOutlet var tempCityLabel: UILabel!
    
    func configure(weather: Weather) {
        nameCityLabel.text = weather.name
        conditionCityLabel.text = weather.conditionString
        tempCityLabel.text = weather.temperatureString
    }
    
}
