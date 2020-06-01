//
//  CurrentWeather.swift
//  23Weather
//
//  Created by Roman Oliinyk on 31.05.2020.
//  Copyright © 2020 Roman Oliinyk. All rights reserved.
//

import Foundation

struct CurrentWeather {
    let name: String
    
    let temperature: Double
    var temperatureString: String {
        return String(format: "%0.f", temperature)
    }
    
    let feelsLike: Double
    var feelsLikeString: String {
        return String(format: "%0.f", feelsLike)
    }
    let description: String
    let id: Int
    var systemNameString: String {
        switch id {
        case 200...232:
            return "cloud.bolt.rain"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "smoke"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud"
        default:
            return "nosign"
        }
    }
    
    init?(currentWeatherData: CurrentWeatherData) {
        name = currentWeatherData.name
        temperature = currentWeatherData.main.temp
        feelsLike = currentWeatherData.main.feels_like
        id = currentWeatherData.weather.first!.id
        description = currentWeatherData.weather.first!.main
    }
    
}
