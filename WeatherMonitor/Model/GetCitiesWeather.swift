//
//  GetCitiesWeather.swift
//  WeatherMonitor
//
//  Created by Olga Tegza on 27.04.2023.
//

import Foundation
import CoreLocation

let networkWeatherManager = NetworkWeatherManager()

func getCityweather(citiesArray: [String], completionHandler: @escaping(Int, Weather) -> Void) {
    for (index, item) in citiesArray.enumerated() {
        getCoordinateFrom(city: item) { coordinate, error in
            guard let coordinate = coordinate, error == nil else { return }
            
            networkWeatherManager.fetchWeather(latitude: coordinate.latitude, longitude: coordinate.longitude) { (weather) in
                completionHandler(index, weather)
            }
        }
    }
}

func getCoordinateFrom(city: String, completion: @escaping(_ coordinate: CLLocationCoordinate2D?, _ error: Error?) -> ()) {
    CLGeocoder().geocodeAddressString(city) { (placemark, error) in completion(placemark?.first?.location?.coordinate, error)
    }
}
