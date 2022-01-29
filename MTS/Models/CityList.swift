//
//  CityList.swift
//  MTS
//
//  Created by Yaroslav Fomenko on 29.01.2022.
//

import Foundation

struct City: Hashable {
    let id: Int
    let name: String
    let state: String?
    let country: String
    let coord: Coordinate
}
