//
//  Settings.swift
//  KinoLib
//
//  Created by KoroLion on 17.12.2021.
//

struct Settings {
    static let dataManager = DataManager.shared
    static let apiKey = "7e9d56a1cac69f691cae6d7c1ec5ba8a"
    static let baseUrl = "https://api.openweathermap.org/data/2.5/"
    static var degreeType: String = dataManager.getTempType() {
        didSet {
            dataManager.setTempType(type: degreeType)
        }
    }
    
}
