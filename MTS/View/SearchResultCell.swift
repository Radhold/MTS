//
//  SearchResultCell.swift
//  MTS
//
//  Created by Yaroslav Fomenko on 30.01.2022.
//

import UIKit

class SearchResultCell: UITableViewCell, CellProtocol {
    static var name: String = "SearchResultCell"
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    let city: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont(name: "Helvetica Neue", size: 18)
        $0.textAlignment = .left
        $0.numberOfLines = 1
        return $0
    }(UILabel())
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        self.addSubview(city)
        backgroundColor = .white
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
        city.text = ""
    }
    
    
    func layout() {
        
        
        NSLayoutConstraint.activate([
            city.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 5),
            city.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 5),
            city.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
//            city.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 5),
            city.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            ])
    }
}
