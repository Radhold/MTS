//
//  WeatherOneCall.swift
//  MTS
//
//  Created by Yaroslav Fomenko on 29.01.2022.
//

import Foundation

struct DailyWeather: Codable {
    let dt: Int
    let temp: Temp
    let weather: [WeatherDescription]
    let pop: Double
    
}

struct Temp: Codable {
    let day: Double
    let min: Double
    let max: Double
}

struct HourlyWeather: Codable {
    let dt: Int
    let temp: Double
    let weather: [WeatherDescription]
    let pop: Double
}

struct CurrentWeatherOneCall: Codable {
    let dt: Int
    let temp: Double
    let pressure: Int
    let humidity: Int
    let windSpeed: Double?
    let windDeg: Int?
    let weather: WeatherDescription
}

struct OneCall: Codable {
    let lat: Double
    let lon: Double
    let timezoneOffset: Int
    let current: CurrentWeatherOneCall?
    let hourly: HourlyWeather?
    let daily: DailyWeather?
}


