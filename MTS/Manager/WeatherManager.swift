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
    func load<T:Codable>(ofType: T.Type, url: String, via: String)
}

protocol WeatherManagerOutput: AnyObject {
    func success<T>(result: T)
    func failure(error: Error)
}

final class WeatherManager: WeatherManagerProtocol {
    func load<T: Codable>(ofType: T.Type, url: String, via: String){
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
    
    weak var output: WeatherManagerOutput?
    let networkManager: NetworkManagerProtocol!
    
    private init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
    }
    
}
