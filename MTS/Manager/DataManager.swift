import Foundation
protocol DataManagerProtocol {
    func setTempType (type: String)
    func getTempType () -> String
    func getFav () -> [Int]
    func addFav (id: Int)
    func isFav (id: Int) -> Bool
    func deleteFav (id: Int)
    func getFavCurrentWeather () -> [CurrentWeather]
    func setFavCurrentWeather (weather: [CurrentWeather])
    func getFavOneCallWeather () -> [OneCall]
    func setFavOneCallWeather (weather: OneCall)
    func getFavOneCallWeatherByCoord (lat: Double, lon: Double) -> OneCall?
}

class DataManager: DataManagerProtocol {
    
    func getFavOneCallWeatherByCoord (lat: Double, lon: Double) -> OneCall? {
        if let saved = userDefaults.object(forKey: "OneCall") as? Data {
            let decoder = JSONDecoder()
            if let loaded = try? decoder.decode([OneCall].self, from: saved) {
                return loaded.first{
                    $0.lon == lon && $0.lat == lat
                }
            }
        }
        return nil
    }
    
    func getFavOneCallWeather () -> [OneCall] {
        if let saved = userDefaults.object(forKey: "OneCall") as? Data {
            let decoder = JSONDecoder()
            if let loaded = try? decoder.decode([OneCall].self, from: saved) {
                return loaded
            }
        }
        return []
    }
    
    func setFavOneCallWeather (weather: OneCall) {
        DispatchQueue.main.async {
            var loaded: [OneCall] = self.getFavOneCallWeather()
            loaded += [weather]
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(loaded){
                self.userDefaults.set(encoded, forKey: "OneCall")
            }
        }
    }
    
    func deleteFav(id: Int) {
        DispatchQueue.main.async {
            if var getFav = self.userDefaults.value(forKey: "FavouriteID") as? Array<Int> {
                let index = getFav.firstIndex(of: id)!
                getFav.remove(at: index)
                self.userDefaults.set(getFav, forKey: "FavouriteID")
                var getWeather = self.getFavCurrentWeather()
                let wIndex = getWeather.firstIndex{
                    $0.id == id
                }
                if let w = wIndex{
                    getWeather.remove(at: w)
                }
                self.setFavCurrentWeather(weather: getWeather)
            }
//            print(self.userDefaults.value(forKey: "FavouriteID"))
        }
        
    }
    
    func isFav(id: Int) -> Bool {
        if let getFav = self.userDefaults.value(forKey: "FavouriteID") as? Array<Int> {
            return getFav.contains(id)
        }
        else {
            return false
        }
    }
    
    func addFav(id: Int) {
        DispatchQueue.main.async {
            var fav = Array<Int>()
            if let getFav = self.userDefaults.value(forKey: "FavouriteID") as? Array<Int> {
                fav = getFav
            }
            fav.append(id)
            self.userDefaults.set(fav, forKey: "FavouriteID")
            print(self.userDefaults.value(forKey: "FavouriteID"))
        }
    }
    
    static let shared: DataManager = DataManager()
    let userDefaults = UserDefaults.standard
    
    func setTempType (type: String){
        userDefaults.set(type, forKey: "tempType")
    }
    func getTempType () -> String {
        userDefaults.string(forKey: "tempType") ?? "C°"
    }
    
    func getFav () -> [Int] {
        if let getFav = self.userDefaults.value(forKey: "FavouriteID") as? Array<Int> {
            return getFav
        }
        else {
            return [Int]()
        }
    }
    
    func getFavCurrentWeather () -> [CurrentWeather] {
        if let saved = userDefaults.object(forKey: "CurrentWeather") as? Data {
            let decoder = JSONDecoder()
            if let loaded = try? decoder.decode([CurrentWeather].self, from: saved) {
                let id = self.getFav()
                let filtred = loaded.filter{
                    id.contains($0.id)
                }
                return filtred
            }
        }
        return []
    }
    
    func setFavCurrentWeather (weather: [CurrentWeather]) {
        DispatchQueue.main.async {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(weather){
                self.userDefaults.set(encoded, forKey: "CurrentWeather")
            }
        }
    }
    
    
}
