//
//  HourlyWeatherCell.swift
//  MTS
//
//  Created by Yaroslav Fomenko on 31.01.2022.
//

import UIKit

class HourlyWeatherCell: UICollectionViewCell, CellProtocol {
    
    static var name: String = "HourlyWeatherCell"
    
    let date: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont(name: "Helvetica Neue", size: 12)
        $0.textAlignment = .center
        $0.numberOfLines = 1
        return $0
    }(UILabel())
    
    let weatherImage: UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentMode = .scaleAspectFit
//        $0.image = UIImage(named: "01d")
        return $0
    }(UIImageView())
    
    let precipitation: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont(name: "Helvetica Neue", size: 12)
        $0.textAlignment = .center
        $0.numberOfLines = 1
        return $0
    }(UILabel())
    
    let temp: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont(name: "Helvetica Neue", size: 12)
        $0.textAlignment = .center
        $0.numberOfLines = 1
        return $0
    }(UILabel())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(date)
        contentView.addSubview(weatherImage)
        contentView.addSubview(precipitation)
        contentView.addSubview(temp)
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
        date.text = ""
        weatherImage.image = nil
        precipitation.text = ""
        temp.text = ""
    }
    
    private func layout () {
        NSLayoutConstraint.activate([
            date.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            date.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 5),
            date.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -5),
            date.heightAnchor.constraint(equalToConstant: 16),

            weatherImage.topAnchor.constraint(equalTo: date.bottomAnchor, constant: 5),
            weatherImage.widthAnchor.constraint(equalToConstant: 30),
            weatherImage.heightAnchor.constraint(equalToConstant: 30),
            weatherImage.centerXAnchor.constraint(equalTo: date.centerXAnchor),
            
            precipitation.topAnchor.constraint(equalTo: weatherImage.bottomAnchor, constant: 5),
            precipitation.heightAnchor.constraint(equalTo: date.heightAnchor),
            precipitation.centerXAnchor.constraint(equalTo: weatherImage.centerXAnchor),
            
            temp.topAnchor.constraint(equalTo: precipitation.bottomAnchor),
            temp.centerXAnchor.constraint(equalTo: precipitation.centerXAnchor),
            
            
            
            
        ])
    }
}
