//
//  CurrentWeatherData.swift
//  23Weather
//
//  Created by Roman Oliinyk on 31.05.2020.
//  Copyright © 2020 Roman Oliinyk. All rights reserved.
//

import Foundation

struct CurrentWeatherData: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Codable {
    let temp: Double
    let feels_like: Double
}

struct Weather: Codable {
    let id: Int
    let main: String
}
