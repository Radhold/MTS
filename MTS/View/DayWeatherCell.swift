//
//  DayWeatherCell.swift
//  MTS
//
//  Created by Yaroslav Fomenko on 31.01.2022.
//

import UIKit

class DayWeatherCell: UITableViewCell, CellProtocol {
    
    static var name: String = "DayWeatherCell"
    
    let date: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont(name: "Helvetica Neue", size: 14)
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
        $0.font = UIFont(name: "Helvetica Neue", size: 14)
        $0.textAlignment = .center
        $0.numberOfLines = 1
        return $0
    }(UILabel())
    
    let temp: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont(name: "Helvetica Neue", size: 14)
        $0.textAlignment = .center
        $0.numberOfLines = 1
        return $0
    }(UILabel())
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
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
    
    private func layout() {
        NSLayoutConstraint.activate([
            date.topAnchor.constraint(equalTo: contentView.topAnchor),
            date.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 5),
            date.bottomAnchor.constraint(equalTo: bottomAnchor),
            date.widthAnchor.constraint(equalToConstant: 50),
            
            weatherImage.topAnchor.constraint(equalTo: date.topAnchor),
            weatherImage.widthAnchor.constraint(equalToConstant: 30),
            weatherImage.heightAnchor.constraint(equalToConstant: 30),
            weatherImage.leftAnchor.constraint(equalTo: date.rightAnchor, constant: 10),
            
            precipitation.topAnchor.constraint(equalTo: weatherImage.bottomAnchor, constant: 5),
//            precipitation.bottomAnchor.constraint(equalTo: date.bottomAnchor),
            precipitation.centerXAnchor.constraint(equalTo: weatherImage.centerXAnchor),
            
            temp.leftAnchor.constraint(equalTo: weatherImage.rightAnchor, constant: 10),
            temp.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant:  -10),
            temp.centerYAnchor.constraint(equalTo: date.centerYAnchor),
            
            
        ])
    }

}
