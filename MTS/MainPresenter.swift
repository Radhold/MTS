//
//  MainPresenter.swift
//  MTS
//
//  Created by Yaroslav Fomenko on 27.01.2022.
//

import Foundation

protocol MainPresenter {
    func getWeather(lon: Double, lat: Double, type: String) -> Void
    func addToFav(id: Int) -> Void
}
