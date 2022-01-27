//
//  Weather.swift
//  MTS
//
//  Created by Yaroslav Fomenko on 27.01.2022.
//

import Foundation

struct Coordinate{
    let lon: Double
    let lat: Double
}

struct WeatherDescription {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct Main{
    let temp: Double
    let feelsLike: Double
    let tempMin: Double
    let tempMax: Double
    let pressure: Int
    let humidity: Int
}
