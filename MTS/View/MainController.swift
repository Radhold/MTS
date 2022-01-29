//
//  ViewController.swift
//  MTS
//
//  Created by Yaroslav Fomenko on 27.01.2022.
//
import CoreLocation
import UIKit

protocol MainVCProtocol: AnyObject {
    
}

class MainController: UIViewController, MainVCProtocol, CLLocationManagerDelegate {
    
    var presenter: MainPresenterProtocol!
    
    let locationManager = CLLocationManager()
    
    let searchBar: UISearchBar = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UISearchBar())
    
    let collectionView: UICollectionView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.register(classCell: WeatherCell.self)
        $0.backgroundColor = .white
        $0.isScrollEnabled = true
        return $0
    }(UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init()))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
//        if let location = self.locationManager.location{
//            presenter.getWeatherViaCoord(lon: location.coordinate.longitude, lat: location.coordinate.latitude, type: "current")
//        }
        presenter.getWeatherViaCoord(lon: 0, lat: 0, type: "current")
        locationManager.stopUpdatingLocation()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.layout()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.view.backgroundColor = .white
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue: CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
    }
    
    func layout() {
        
        NSLayoutConstraint.activate([
            searchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 50),
            collectionView.widthAnchor.constraint(equalTo: view.widthAnchor),
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 10),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    func configure() {
        self.view.addSubview(searchBar)
        self.view.addSubview(collectionView)
        self.title = "Погода"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: Settings.degreeType, style: .plain, target: self, action: #selector(pressButton(sender:)))
        presenter = MainPresenter(view: self)
        presenter.output = self
        collectionView.delegate = self
        collectionView.dataSource = self
        searchBar.delegate = self
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            collectionView.collectionViewLayout = layout
        }
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    @objc func pressButton(sender: Any){
        if let _ = sender as? UIBarButtonItem{
            presenter.buttonPressed(type: "UIBarButtonItem")
            DispatchQueue.main.async {
                self.navigationItem.rightBarButtonItem?.title = Settings.degreeType
            }
            
        }
    }


}

extension MainController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if !presenter.currentWeather.isEmpty{
            return 10
        }
        else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.create(cell: WeatherCell.self, at: indexPath)
        let element = presenter.currentWeather[0]
        
        cell.weatherImage.image = UIImage(named: element.weather.first!.icon)
        cell.thermoImage.image = UIImage(named: Settings.degreeType)
        if Settings.degreeType == "C°"{
            cell.thermo.text = "Сейчас: \(element.main.temp.description.toCelsius()). "
                                + "Ощущается: \(element.main.feelsLike.description.toCelsius()). "
                                + "Макс: \(element.main.tempMax.description.toCelsius()). "
                                + "Мин: \(element.main.tempMin.description.toCelsius())."
        }
        else {
            cell.thermo.text = "Сейчас: \(element.main.temp.description.toFarenheit()). "
                                + "Ощущается: \(element.main.feelsLike.description.toFarenheit()). "
                                + "Макс: \(element.main.tempMax.description.toFarenheit()). "
                                + "Мин: \(element.main.tempMin.description.toFarenheit())."
            
        }
        
        cell.city.text = element.name
        cell.time.text = element.dt.formatTime(timeZone: element.timezone)
        if let windDeg = element.wind.deg, let windSpeed = element.wind.speed {
            cell.wind.text = "\(windDeg.windDirection()). Скорость ветра \(windSpeed) м/c."
        }
        return cell
    }
}

extension MainController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width - 20, height: 160)
    }
}

extension MainController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // Do some search stuff
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        // Stop doing the search stuff
        // and clear the text in the search bar
        searchBar.text = ""
        // Hide the cancel button
        searchBar.setShowsCancelButton(false, animated: true)
        self.view.endEditing(true)
        // You could also change the position, frame etc of the searchBar
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
           searchBar.setShowsCancelButton(true, animated: true)
       }
}

extension MainController: MainPresenterOutput {
    func success() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func failure(error: Error) {
        
    }
}

