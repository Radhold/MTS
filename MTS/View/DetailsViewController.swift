//
//  DetailViewController.swift
//  MTS
//
//  Created by Yaroslav Fomenko on 31.01.2022.
//

import UIKit

protocol DetailsViewProtocol: AnyObject {
    var weather: OneCall? { get set }
    var city: String! { get set }
    var id: Int! { get set }
    var coord: Coordinate! { get set }
}

final class DetailsViewController: UIViewController, DetailsViewProtocol, WeatherManagerOutput {
    func success<T>(result: T) {
        if let result = result as? OneCall {
            weather = result
            if isFav {
                dataManager.setFavOneCallWeather(weather: result)
            }
        }
    }
    
    func failure(error: Error) {
    }
    
    var coord: Coordinate!
    
    var weather: OneCall? {
        didSet{
            guard let current = weather?.current else {
                return
            }
            DispatchQueue.main.async {
                
                self.weatherImage.image = UIImage(named: current.weather.first!.icon)
                self.tempNow.text = Settings.degreeType == "C°" ? current.temp.description.toCelsius() + "°": current.temp.description.toFarenheit() + "°"
                self.weatherDescription.text = current.weather.first!.description.firstUppercased
                guard let windSpeed = current.windSpeed, let windDeg = current.windDeg else {
                    return
                }
                self.wind.text = "\(windDeg.windDirection()). Скорость ветра \(windSpeed) м/c."
                self.aditional.text = "Давление: \(current.pressure.convertPressure()) мм рт ст, влажность: \(current.humidity)%"
                self.collectionView.reloadData()
                self.tableView.reloadData()
                self.tableView.heightAnchor.constraint(equalToConstant: CGFloat((self.weather!.daily?.count ?? 1/60) * 60)).isActive = true
            }
        }
    }
    var city: String! {
        didSet {
            self.title = city
        }
    }
    
    var id: Int!
    
    var isFav: Bool!
    
    let dataManager: DataManagerProtocol = DataManager.shared
    weak var output: MainVCProtocol? 
    let scrollView: UIScrollView = {
        //        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .white
        $0.isScrollEnabled = true
        $0.showsHorizontalScrollIndicator = false
        return $0
    }(UIScrollView(frame: .zero))
    
    let tableView: UITableView = {
        $0.separatorStyle = .singleLine
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.register(classCell: DayWeatherCell.self)
        $0.backgroundColor = .white
        $0.isScrollEnabled = false
        return $0
    }(UITableView(frame: CGRect.zero, style: .plain))
    
    
    let collectionView: UICollectionView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.register(classCell: HourlyWeatherCell.self)
        $0.backgroundColor = .white
        $0.isScrollEnabled = true
        return $0
    }(UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init()))
    
    let weatherImage: UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentMode = .scaleAspectFit
        //        $0.image = UIImage(named: "01d")
        return $0
    }(UIImageView())
    
    let tempNow: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont(name: "Helvetica Neue", size: 28)
        $0.textAlignment = .center
        $0.text = "Нет данных"
        $0.numberOfLines = 1
        return $0
    }(UILabel())
    
    let weatherDescription: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont(name: "Helvetica Neue", size: 18)
        $0.textAlignment = .center
        $0.numberOfLines = 1
        return $0
    }(UILabel())
    
    let wind: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont(name: "Helvetica Neue", size: 18)
        $0.textAlignment = .center
        $0.numberOfLines = 3
        return $0
    }(UILabel())
    
    let aditional: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont(name: "Helvetica Neue", size: 18)
        $0.textAlignment = .center
        $0.numberOfLines = 2
        return $0
    }(UILabel())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.isFav = dataManager.isFav(id: self.id)
        configure()
    }
    
    private func configure () {
        self.load()
        collectionView.delegate = self
        collectionView.dataSource = self
        tableView.dataSource = self
        tableView.delegate = self
        self.view.addSubview(scrollView)
        self.scrollView.addSubview(weatherImage)
        self.scrollView.addSubview(tempNow)
        self.scrollView.addSubview(weatherDescription)
        self.scrollView.addSubview(wind)
        self.scrollView.addSubview(aditional)
        self.scrollView.addSubview(tableView)
        self.scrollView.addSubview(collectionView)
        self.navigationController?.view.backgroundColor = .white
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.collectionView?.showsHorizontalScrollIndicator = false
            collectionView.collectionViewLayout = layout
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: isFav ? "heartFill": "heart")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(favClicked))
        
        //        self.navigationController?.navigationBar.bac
    }
    
    private func load() {
        self.weatherManager.output = self
        self.weatherManager.load(ofType: OneCall.self, url: "https://api.openweathermap.org/data/2.5/onecall?lat=\(self.coord.lat)&lon=\(self.coord.lon)&exclude=minutely,alerts&lang=ru", via: "oneCall", lat: coord.lat, lon: coord.lon)
    }
    
    private var weatherManager: WeatherManagerProtocol = WeatherManager.shared
    
    @objc func favClicked () {
        DispatchQueue.main.async {
            self.isFav.toggle()
            if self.isFav == false{
                self.dataManager.deleteFav(id: self.id)
            }
            else if self.isFav == true {
                self.dataManager.addFav(id: self.id)
            }
            self.output?.favID = self.id
            self.navigationItem.rightBarButtonItem?.image = UIImage(named: self.isFav ? "heartFill": "heart")?.withRenderingMode(.alwaysOriginal)
        }
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews();
        self.scrollView.frame = self.view.bounds;
        let contentRect: CGRect = scrollView.subviews.reduce(into: .zero) { rect, view in
            rect = rect.union(view.frame)
        }
        scrollView.contentSize = contentRect.size
    }
    
    override func viewDidLayoutSubviews() {
        layout()
    }
    private func layout () {
        
        NSLayoutConstraint.activate([
            //            scrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            //            scrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            //            scrollView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor),
            //            scrollView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor),
            tempNow.topAnchor.constraint(equalTo: self.scrollView.topAnchor, constant: 10),
            tempNow.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10),
            tempNow.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10),
            weatherImage.centerXAnchor.constraint(equalTo: tempNow.centerXAnchor),
            weatherImage.widthAnchor.constraint(equalToConstant: 50),
            weatherImage.heightAnchor.constraint(equalToConstant: 50),
            weatherImage.topAnchor.constraint(equalTo: tempNow.bottomAnchor, constant: 10),
            weatherDescription.topAnchor.constraint(equalTo: weatherImage.bottomAnchor, constant: 10),
            weatherDescription.leftAnchor.constraint(equalTo: tempNow.leftAnchor),
            weatherDescription.rightAnchor.constraint(equalTo: tempNow.rightAnchor),
            wind.leftAnchor.constraint(equalTo: tempNow.leftAnchor),
            wind.rightAnchor.constraint(equalTo: tempNow.rightAnchor),
            wind.topAnchor.constraint(equalTo: weatherDescription.bottomAnchor, constant: 10),
            aditional.topAnchor.constraint(equalTo: wind.bottomAnchor, constant: 10),
            aditional.leftAnchor.constraint(equalTo: tempNow.leftAnchor),
            aditional.rightAnchor.constraint(equalTo: tempNow.rightAnchor),
            collectionView.topAnchor.constraint(equalTo: aditional.bottomAnchor, constant: 10),
            collectionView.leftAnchor.constraint(equalTo: tempNow.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: tempNow.rightAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 110),
            tableView.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 10),
            tableView.leftAnchor.constraint(equalTo: tempNow.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: tempNow.rightAnchor),
            
        ])
    }
    
}

extension DetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let hourly = weather?.hourly {
            return hourly.count
        }
        else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.create(cell: HourlyWeatherCell.self, at: indexPath)
        let element = weather!.hourly![indexPath.row]
        cell.weatherImage.image = UIImage(named: element.weather.first!.icon)
        cell.temp.text = Settings.degreeType == "C°" ? element.temp.description.toCelsius() + "°": element.temp.description.toFarenheit() + "°"
        cell.precipitation.text = String(Int(element.pop) * 100) + "%"
        cell.date.text = element.dt.formatHour(timeZone: weather!.timezoneOffset)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width/7, height: collectionView.frame.height)
    }
    
}

extension DetailsViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let daily = weather?.daily {
            return daily.count
        }
        else {
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.create(cell: DayWeatherCell.self, at: indexPath)
        let element = weather!.daily![indexPath.row]
        cell.date.text = element.dt.formatDay(timeZone: weather!.timezoneOffset)
        cell.temp.text = Settings.degreeType == "C°" ? "Макс. \(element.temp.max.description.toCelsius())°, мин. \(element.temp.min.description.toCelsius())°": "Макс. \(element.temp.max.description.toFarenheit())°, мин. \(element.temp.min.description.toFarenheit())°"
        cell.weatherImage.image = UIImage(named: element.weather.first!.icon)
        cell.precipitation.text = element.pop.description + "%"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
