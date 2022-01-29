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

struct WeatherDescription: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct Main: Codable{
    let temp: Double
    let feelsLike: Double
    let tempMin: Double
    let tempMax: Double
    let pressure: Int
    let humidity: Int
}

struct Wind: Codable{
    let speed: Double?
    let deg: Int?
    let gust: Double?
}

struct Sys: Codable{
    let id: Int
    let country: String
    let sunrise: Int
    let sunset: Int
}

struct CurrentWeather: Codable {
    let coord: Coordinate
    let weather: [WeatherDescription]
    let main: Main
    let wind: Wind
    let sys: Sys
    let dt: Int
    let timezone: Int
    let id: Int
    let name: String
    let cod: Int
}
