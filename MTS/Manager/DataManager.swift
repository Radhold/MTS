//
//  DataManager.swift
//  DetailsKinoLib
//
//  Created by Георгий Бутров on 01.11.2021.
//

import Foundation
protocol DataManagerProtocol {
    func setTempType (type: String)
    func getTempType () -> String
    func getFav () -> [City]
    func addFav (city: City)
    func getFavWeather ()
    func setFavWeather ()
}

class DataManager: DataManagerProtocol {
    func addFav(city: City) {

    }
    
    static let shared: DataManager = DataManager()
    let userDefaults = UserDefaults.standard
    
    func setTempType (type: String){
        userDefaults.set(type, forKey: "tempType")
    }
    func getTempType () -> String {
        userDefaults.string(forKey: "tempType") ?? "C°"
    }
    
    func getFav () -> [City] {
        return [City(id: 0, name: "", state: "", country: "", coord: Coordinate(lon: 0, lat: 0))]
    }
    
    func getFavWeather () {
        
    }
    
    func setFavWeather () {
        
    }
}
