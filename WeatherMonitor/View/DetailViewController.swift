//
//  DetailViewController.swift
//  WeatherMonitor
//
//  Created by Olga Tegza on 02.05.2023.
//

import UIKit
import SwiftSVG

class DetailViewController: UIViewController {
    
    @IBOutlet var nameCityLabel: UILabel!
    @IBOutlet var viewCity: UIView!
    @IBOutlet var conditionLabel: UILabel!
    @IBOutlet var tempCityLabel: UILabel!
    

    @IBOutlet var pressureLabel: UILabel!
    @IBOutlet var windSpeedLabel: UILabel!
    @IBOutlet var maxTempLabel: UILabel!
    @IBOutlet var minTempLabel: UILabel!
    
    var weatherModel: Weather?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshLabels()
    }

    func refreshLabels() {
        nameCityLabel.text = weatherModel?.name
         
        let url = URL(string: "https://yastatic.net/weather/i/icons/funky/dark/\(weatherModel!.conditionCode).svg")
        let weatherImage = UIView(SVGURL: url!) {(image) in
            image.resizeToFit(self.viewCity.bounds)
        }
        
        self.viewCity.addSubview(weatherImage)
        
        conditionLabel.text = weatherModel?.conditionString
        tempCityLabel.text = weatherModel?.temperatureString
        pressureLabel.text = "\(weatherModel?.pressureMm ?? 0)"
        windSpeedLabel.text = "\(weatherModel?.windSpeed ?? 0)"
        minTempLabel.text = "\(weatherModel?.tempMin ?? 0)"
        maxTempLabel.text = "\(weatherModel?.tempMax ?? 0)"
    }
}
