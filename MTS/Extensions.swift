//
//  Extensions.swift
//  MTS
//
//  Created by Yaroslav Fomenko on 29.01.2022.
//

import Foundation
import UIKit

extension UICollectionView {
    
    func create<A: CellProtocol>(cell: A.Type, at index: IndexPath) -> A {
        return self.dequeueReusableCell(withReuseIdentifier: cell.name, for: index) as! A
    }
    
    func register<A: CellProtocol>(classXIB: A.Type) {
        let cell = UINib(nibName: classXIB.name, bundle: nil)
        self.register(cell, forCellWithReuseIdentifier: classXIB.name)
    }
    
    func register<A: CellProtocol>(classCell: A.Type) {
        self.register(classCell.self, forCellWithReuseIdentifier: classCell.name)
    }
    
}

extension UITableView {
    
    func create<A: CellProtocol>(cell: A.Type) -> A {
        self.dequeueReusableCell(withIdentifier: cell.name) as! A
    }
    
    func create<A: CellProtocol>(cell: A.Type, at index: IndexPath) -> A {
        self.dequeueReusableCell(withIdentifier: cell.name, for: index) as! A
    }
    
    func register<A: CellProtocol>(classCell: A.Type) {
        self.register(classCell.self, forCellReuseIdentifier: classCell.name)
    }
    
    func register(nibName name: String, forCellReuseIdentifier identifier: String) {
        let someNib = UINib(nibName: name, bundle: nil)
        self.register(someNib, forCellReuseIdentifier: identifier)
    }
}
extension String {
    func toCelsius () -> String {
        var temp = Double(self) ?? 0
        temp -= 273.15
        temp.round()
        return String(Int(temp))
    }
    
    func toFarenheit () -> String {
        var temp = Double(self) ?? 0
        temp = (temp - 273.15) * 9/5 + 32
        temp.round()
        return String(Int(temp))
    }
    subscript(_ range: CountableRange<Int>) -> String {
        let start = index(startIndex, offsetBy: max(0, range.lowerBound))
        let end = index(start, offsetBy: min(self.count - range.lowerBound,
                                             range.upperBound - range.lowerBound))
        return String(self[start..<end])
    }
    
    subscript(_ range: CountablePartialRangeFrom<Int>) -> String {
        let start = index(startIndex, offsetBy: max(0, range.lowerBound))
        return String(self[start...])
    }
    
    
}

extension Int {
    func formatTime (timeZone: Int) -> String {
        let date = Date(timeIntervalSince1970: Double(self + timeZone))
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        return dateFormatter.string(from: date)
    }
    
    func windDirection () -> String{
        switch self{
        case 349...360, 0...11:
            return "Северный ветер"
        case 12...33:
            return "Северо-северо западный ветер"
        case 34...56:
            return "Северо-западный ветер"
        case 57...78:
            return "Западно северо-западный ветер"
        case 79...101:
            return "Западный ветер"
        case 102...123:
            return "Западно юго-западный ветер"
        case 124...146:
            return "Юго-западный ветер"
        case 147...168:
            return "Юго юго-западный ветер"
        case 169...191:
            return "Южный ветер"
        case 192...213:
            return "Юго юго-восточный ветер"
        case 214...236:
            return "Юго-восточный ветер"
        case 237...258:
            return "Восточно юго-восточный ветер"
        case 259...281:
            return "Восточный ветер"
        case 282...303:
            return "Восточно северо-восточный ветер"
        case 304...326:
            return "Северо-восточный ветер"
        case 327...348:
            return "Северо северо-восточный ветер"
        default:
            return "Нет ветра"
        }
    }
}

protocol CellProtocol: UIView {
    static var name: String { get }
}
