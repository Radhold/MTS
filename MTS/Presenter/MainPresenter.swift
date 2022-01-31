//
//  MainPresenter.swift
//  MTS
//
//  Created by Yaroslav Fomenko on 27.01.2022.
//

import Foundation

protocol MainPresenterProtocol {
    func getCoord(lon: Double, lat: Double, type: String) -> Void
    func getWeatherViaId(id: [Int], type: String) -> Void
    func removeFromFav(id: Int) -> Void
    func inputCity(name: String) -> [City]
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
    
    private lazy var city = Set<City>()
    weak var view: MainVCProtocol!
    weak var output: MainPresenterOutput?
    
    var currentWeather = [CurrentWeather]()
    
    init(view: MainVCProtocol) {
        self.view = view
        if let data = readLocalFile(forName: "cityList") {
            parseJSON(jsonData: data)
        }
//        print(inputCity(name: "mos"))
    }
    
    func inputCity(name: String) -> [City] {
        let result = city.filter{
            $0.name[0..<name.count].lowercased().contains(name.lowercased())
        }
        return Array(result)
    }
    
    func getCoord(lon: Double, lat: Double, type: String) {
//        weatherManager.load(ofType: CurrentWeather.self, url: "https://api.openweathermap.org/data/2.5/weather?lon=\(lon)&lat=\(lat)&lang=ru", via: "")
        weatherManager.load(ofType: CurrentWeather.self, url: "https://api.openweathermap.org/data/2.5/weather?q=London&lang=ru", via: "")
        weatherManager.output = self
    }
    
    func getWeatherViaId(id: [Int], type: String) {
        
    }
    
    func removeFromFav(id: Int) {
        
    }
    
    func readLocalFile(forName name: String) -> Data? {
        do {
            if let bundlePath = Bundle.main.path(forResource: name,
                                                 ofType: "json"),
                let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                return jsonData
            }
        } catch {
            print(error)
        }
        
        return nil
    }
    
    func parseJSON(jsonData: Data) {
            do {
                city = try JSONDecoder().decode(Set<City>.self,
                                                           from: jsonData)
//                print(city.first)
            } catch {
                print("decode error")
            }
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
