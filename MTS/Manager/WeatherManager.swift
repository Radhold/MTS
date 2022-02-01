//
//  WeatherManager.swift
//  MTS
//
//  Created by Yaroslav Fomenko on 29.01.2022.
//

import Foundation

protocol WeatherManagerProtocol {
    var output: WeatherManagerOutput? { get set }
    var networkManager: NetworkManagerProtocol! { get }
    func load<T:Codable>(ofType: T.Type, url: String, via: String, lat: Double, lon: Double)
}

protocol WeatherManagerOutput: AnyObject {
    func success<T>(result: T)
    func failure(error: Error)
}

final class WeatherManager: WeatherManagerProtocol {
    func load<T: Codable>(ofType: T.Type, url: String, via: String, lat: Double = 0, lon: Double = 0){
        if via == "current" {
            let data = dataManager.getFavCurrentWeather()
            self.output?.success(result: data)
        }
        if via == "oneCall" {
            let data = dataManager.getFavOneCallWeatherByCoord(lat: lat, lon: lon)
            self.output?.success(result: data)
        }
        self.networkManager.get(ofType: T.self, url: url){[weak self] result in
            guard let self = self else {return}
            switch result{
            case .success(let items):
                self.output?.success(result: items)
            case .failure(let error):
                self.output?.failure(error: error)
            }
        }
    }
    
    static let shared: WeatherManagerProtocol = WeatherManager(networkManager: NetworkManager())
    let dataManager: DataManagerProtocol = DataManager.shared
    weak var output: WeatherManagerOutput?
    let networkManager: NetworkManagerProtocol!
    
    private init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
    }
    
}
