//
//  MainPresenter.swift
//  MTS
//
//  Created by Yaroslav Fomenko on 27.01.2022.
//

import Foundation

protocol MainPresenterProtocol {
    func getFav () -> [Int]
    func getCoord(lon: Double, lat: Double) -> Void
    func getWeatherViaId(id: [Int]) -> Void
    func removeFromFav(id: Int) -> Void
    func inputCity(name: String) -> [City]
    func buttonPressed(type: String)
    var currentWeather: [CurrentWeather] { get set }
    var oneCallWeather: [OneCall] { get set }
    var output: MainPresenterOutput? { get set }
    var id: [Int]! { get set }
}


protocol MainPresenterOutput: AnyObject {
    func success()
    func failure(error: Error)
}

final class MainPresenter: MainPresenterProtocol{
    func getFav() -> [Int] {
        return dataManager.getFav()
    }
    
    func buttonPressed(type: String) {
        
        if type == "UIBarButtonItem"{
            Settings.degreeType = Settings.degreeType == "C°" ? "F°": "C°"
            output?.success()
        }
    }
    
    private var weatherManager: WeatherManagerProtocol = WeatherManager.shared
    
    private lazy var city = Set<City>()
    var id: [Int]!
    weak var view: MainVCProtocol!
    weak var output: MainPresenterOutput?
    let dataManager: DataManagerProtocol = DataManager.shared
    
    var currentWeather = [CurrentWeather]()
    
    var oneCallWeather: [OneCall] = [OneCall]()
    
    var geoWeather: CurrentWeather?
    
    init(view: MainVCProtocol) {
        self.view = view
        id = getFav()
        self.getWeatherViaId(id: self.id)
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
    
    func getCoord(lon: Double, lat: Double) {
        weatherManager.load(ofType: CurrentWeather.self, url: "https://api.openweathermap.org/data/2.5/weather?lon=\(lon)&lat=\(lat)", via: "", lat: 0, lon: 0)
        weatherManager.output = self
//        weatherManager.load(ofType: CurrentWeather.self, url: "https://api.openweathermap.org/data/2.5/weather?q=London&lang=ru", via: "")
    }
    
    func getWeatherViaId(id: [Int]) {
        if !id.isEmpty {
            var req = ""
            id.forEach{
                req += "\($0),"
            }
            weatherManager.output = self
            weatherManager.load(ofType: groupCurrent.self, url: "https://api.openweathermap.org/data/2.5/group?id=\(req)", via: "current", lat: 0, lon: 0)
        }
        else {
            weatherManager.output = self
            weatherManager.load(ofType: groupCurrent.self, url: "", via: "current", lat: 0, lon: 0)
        }
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
            geoWeather = result
            currentWeather = [result] + currentWeather
            self.output?.success()
        }
        else if let result = result as? groupCurrent {
            dataManager.setFavCurrentWeather(weather: result.list)
            if let geo = geoWeather {
                currentWeather = [geo] + result.list
            }
            else {
                currentWeather = result.list
            }
            self.output?.success()
        }
        else if let result = result as? OneCall{
            oneCallWeather.append(result)
        }
        else if let result = result as? [CurrentWeather]{
            if let geo = geoWeather {
                currentWeather = [geo] + result
                
            }
            else {
                currentWeather = result
            }
            self.output?.success()
        }
    }
    
    func failure(error: Error) {
        print(error.localizedDescription)
    }
    
    
    
}
