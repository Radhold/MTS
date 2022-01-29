//
//  MainPresenter.swift
//  MTS
//
//  Created by Yaroslav Fomenko on 27.01.2022.
//

import Foundation

protocol MainPresenterProtocol {
    func getWeatherViaCoord(lon: Double, lat: Double, type: String) -> Void
    func getWeatherViaId(id: [Int], type: String) -> Void
    func removeFromFav(id: Int) -> Void
    func searchCity(name: String) -> [City]
    func buttonPressed(type: String)
    var currentWeather: [CurrentWeather] { get set }
    var output: MainPresenterOutput? { get set }
}

protocol MainPresenterOutput: AnyObject {
    func success()
    func failure(error: Error)
}

final class MainPresenter: MainPresenterProtocol{
    func buttonPressed(type: String) {
        
        if type == "UIBarButtonItem"{
            Settings.degreeType = Settings.degreeType == "C°" ? "F°": "C°"
            output?.success()
        }
    }
    
    private var weatherManager: WeatherManagerProtocol = WeatherManager.shared
    
    weak var view: MainVCProtocol!
    weak var output: MainPresenterOutput?
    
    var currentWeather = [CurrentWeather]()
    
    init(view: MainVCProtocol) {
        self.view = view
    }
    
    func searchCity(name: String) -> [City] {
        return [City(id: 0, name: "", state: "", country: "", coord: Coordinate(lon: 0, lat: 0))]
    }
    
    func getWeatherViaCoord(lon: Double, lat: Double, type: String) {
//        weatherManager.load(ofType: CurrentWeather.self, url: "https://api.openweathermap.org/data/2.5/weather?lon=\(lon)&lat=\(lat)&lang=ru", via: "")
        weatherManager.load(ofType: CurrentWeather.self, url: "https://api.openweathermap.org/data/2.5/weather?q=London&lang=ru", via: "")
        weatherManager.output = self
    }
    
    func getWeatherViaId(id: [Int], type: String) {
        
    }
    
    func removeFromFav(id: Int) {
        
    }
}

extension MainPresenter: WeatherManagerOutput {
    func success<T>(result: T) {
        if let result = result as? CurrentWeather{
            currentWeather.append(result)
            self.output?.success()
        }
    }
    
    func failure(error: Error) {
        print(error.localizedDescription)
    }
    
    
}
