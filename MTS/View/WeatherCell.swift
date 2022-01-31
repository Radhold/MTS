//
//  CollectionViewCell.swift
//  MTS
//
//  Created by Yaroslav Fomenko on 28.01.2022.
//

import UIKit

class WeatherCell: UITableViewCell, CellProtocol {
    static var name: String = "WeatherCell"
    
    let weatherImage: UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentMode = .scaleAspectFit
//        $0.image = UIImage(named: "01d")
        return $0
    }(UIImageView())
    
    let thermoImage: UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentMode = .scaleAspectFit
        return $0
    }(UIImageView())
    
    let windImage: UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "wind")
        return $0
    }(UIImageView())
    
    let city: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont(name: "Helvetica Neue", size: 22)
        $0.textAlignment = .left
        $0.numberOfLines = 1
        return $0
    }(UILabel())
    
    let wind: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont(name: "Helvetica Neue", size: 18)
        $0.textAlignment = .left
        $0.numberOfLines = 3
        return $0
    }(UILabel())
    
    let thermo: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont(name: "Helvetica Neue", size: 18)
        $0.textAlignment = .left
        $0.numberOfLines = 2
//      $0.
        return $0
    }(UILabel())
    
    let time: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont(name: "Helvetica Neue", size: 20)
        $0.textAlignment = .center
        $0.numberOfLines = 1
        return $0
    }(UILabel())
    
    lazy var view: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.clipsToBounds = true
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 20
        $0.backgroundColor = UIColor(red: 2/3, green: 2/3, blue: 2/3, alpha: 0.3)
        return $0
    }(UIView(frame: CGRect.zero))
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(view)
        view.addSubview(weatherImage)
        view.addSubview(thermoImage)
        view.addSubview(city)
        view.addSubview(thermo)
        view.addSubview(time)
        view.addSubview(windImage)
        view.addSubview(wind)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layout()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        weatherImage.image = nil
        thermoImage.image = nil
        city.text = ""
        thermo.text = ""
        time.text = ""
    }
    
    
    func layout() {
        
        
        NSLayoutConstraint.activate([
            view.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            view.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
            view.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            weatherImage.heightAnchor.constraint(equalToConstant: 40),
            weatherImage.widthAnchor.constraint(equalToConstant: 40),
            weatherImage.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
            weatherImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 5),
            
            city.leftAnchor.constraint(equalTo: weatherImage.rightAnchor, constant: 10),
            city.bottomAnchor.constraint(equalTo: weatherImage.bottomAnchor, constant: -4),
            
            time.widthAnchor.constraint(equalToConstant: 70),
            time.centerYAnchor.constraint(equalTo: city.centerYAnchor),
            time.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
            city.rightAnchor.constraint(equalTo: time.leftAnchor),
        
            
            thermoImage.widthAnchor.constraint(equalToConstant: 20),
            thermoImage.heightAnchor.constraint(equalToConstant: 20),
            thermoImage.centerXAnchor.constraint(equalTo: weatherImage.centerXAnchor),
            
            thermo.topAnchor.constraint(equalTo: city.bottomAnchor, constant: 10),
            thermo.leftAnchor.constraint(equalTo: city.leftAnchor),
            thermo.rightAnchor.constraint(equalTo: time.rightAnchor),
            thermoImage.centerYAnchor.constraint(equalTo: thermo.centerYAnchor),
            
            wind.topAnchor.constraint(equalTo: thermo.bottomAnchor, constant: 10),
            wind.leftAnchor.constraint(equalTo: city.leftAnchor),
            wind.rightAnchor.constraint(equalTo: time.rightAnchor),
            windImage.centerYAnchor.constraint(equalTo: wind.centerYAnchor),
            
            windImage.widthAnchor.constraint(equalToConstant: 40),
            windImage.heightAnchor.constraint(equalToConstant: 40),
            windImage.leftAnchor.constraint(equalTo: weatherImage.leftAnchor),
            
        ])
    }
}
