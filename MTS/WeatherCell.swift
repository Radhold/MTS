//
//  CollectionViewCell.swift
//  MTS
//
//  Created by Yaroslav Fomenko on 28.01.2022.
//

import UIKit

class WeatherCell: UICollectionViewCell, CellProtocol {
    static var name: String = "WeatherCell"
    
    let image: UIImageView = {
//        $0.image = UIImage(named: "01d")
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentMode = .scaleAspectFit
//        $0.sizeToFit()
        return $0
    }(UIImageView())
    
    let city: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont(name: "Helvetica Neue", size: 24)
        $0.textAlignment = .left
        $0.numberOfLines = 1
//        $0.text = "Moscowia"
//        $0.sizeToFit()
        return $0
    }(UILabel())
    
    let tempNow: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont(name: "Helvetica Neue", size: 14)
        $0.textAlignment = .left
        $0.numberOfLines = 1
//        $0.text = "25"
//        $0.sizeToFit()
        return $0
    }(UILabel())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.clipsToBounds = true
        self.contentView.layer.masksToBounds = true
        self.layer.cornerRadius = 20
        self.layout()
        self.backgroundColor = UIColor(red: 2/3, green: 2/3, blue: 2/3, alpha: 0.3)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        image.image = nil
        city.text = ""
        tempNow.text = ""
    }
    
    func layout() {
        contentView.addSubview(image)
        contentView.addSubview(city)
        contentView.addSubview(tempNow)
//        print(contentView.frame)
        
        NSLayoutConstraint.activate([
//
            image.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: -10),
            image.topAnchor.constraint(equalTo: contentView.topAnchor, constant: -10),
            image.heightAnchor.constraint(equalToConstant: 70),
            image.widthAnchor.constraint(equalToConstant: 70),

            city.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            city.centerYAnchor.constraint(equalTo: image.centerYAnchor),
//            city.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.33),
//            
            tempNow.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            tempNow.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
//            tempNow.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier:)
            
        ])
        print(image.frame)
    }
}
