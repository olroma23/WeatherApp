//
//  NetworkWeatherManager.swift
//  23Weather
//
//  Created by Roman Oliinyk on 30.05.2020.
//  Copyright © 2020 Roman Oliinyk. All rights reserved.
//

import Foundation
import CoreLocation

class NetworkWeatherManager {
    
    enum RequestType {
        case cityName(city: String)
        case coordinates(latitude: CLLocationDegrees, longitude: CLLocationDegrees)
    }
    
    var onCompletion: ((CurrentWeather) -> ())?
    
    func fetchCurrentWeather(forRequestType requestType: RequestType) {
        var urlString = ""
        
        switch requestType {
        case .cityName(let city):
            urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&apikey=\(api)&units=metric"
        case .coordinates(let latitude, let longitude):
            urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&apikey=\(api)&units=metric"
        }
        executeURL(with: urlString)
    }
    
//    func fetchCurrentWeater(for city: String) {
//        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&apikey=\(api)&units=metric"
//        executeURL(with: urlString)
//    }
//
//    func fetchCurrentWeaterByCoordinates(for latitude: CLLocationDegrees, and forLongitude: CLLocationDegrees) {
//        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(forLongitude)&apikey=\(api)&units=metric"
//        executeURL(with: urlString)
//    }
    
    private func executeURL(with urlString: String) {
        guard let url = URL(string: urlString) else { return }
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            guard let currentWeather = self.parseJSON(with: data) else { return }
            self.onCompletion?(currentWeather)
        }
        task.resume()
    }
    
    func parseJSON(with data: Data) -> CurrentWeather? {
        let decoder = JSONDecoder()
        
        do {
            let currentWeatherData = try decoder.decode(CurrentWeatherData.self, from: data)
            guard let currentWeather = CurrentWeather(currentWeatherData: currentWeatherData) else { return nil }
            return currentWeather
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return nil
        
    }
}
