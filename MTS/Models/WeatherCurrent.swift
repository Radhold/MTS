//
//  Weather.swift
//  MTS
//
//  Created by Yaroslav Fomenko on 27.01.2022.
//

import Foundation

struct Coordinate: Hashable, Codable{
    let lon: Double
    let lat: Double
}

struct WeatherDescription: Codable, Hashable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct Main: Codable, Hashable{
    let temp: Double
    let feelsLike: Double
    let tempMin: Double
    let tempMax: Double
    let pressure: Int
    let humidity: Int
}

struct Wind: Codable, Hashable{
    let speed: Double?
    let deg: Int?
    let gust: Double?
}

struct Sys: Codable, Hashable{
    let id: Int?
    let country: String
    let sunrise: Int
    let sunset: Int
    let timezone: Int?
}

struct CurrentWeather: Codable, Hashable {
    let coord: Coordinate
    let weather: [WeatherDescription]
    let main: Main
    let wind: Wind
    let sys: Sys
    let dt: Int
    let timezone: Int?
    let id: Int
    let name: String
    let cod: Int?
}

struct groupCurrent: Codable {
    let cnt: Int
    let list: [CurrentWeather]
}
