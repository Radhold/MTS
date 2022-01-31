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
    //
    //        let searchBar: UISearchBar = {
    //            $0.translatesAutoresizingMaskIntoConstraints = false
    //            return $0
    //        }(UISearchBar())
    //
    let searchController: UISearchController = {
        $0.obscuresBackgroundDuringPresentation = false
        return $0
    }(UISearchController(searchResultsController: nil))
    
    lazy var searchResultController: SearchResultController = {
        return $0
    } (SearchResultController(result: [City(id: 0, name: "", state: "", country: "", coord: Coordinate(lon: 0, lat: 0))]))
    
    let tableView: UITableView = {
        $0.separatorStyle = .none
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.register(classCell: WeatherCell.self)
        $0.backgroundColor = .white
        $0.isScrollEnabled = true
        return $0
    }(UITableView(frame: CGRect.zero, style: .plain))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
        //        if let location = self.locationManager.location{
        //            presenter.getWeatherViaCoord(lon: location.coordinate.longitude, lat: location.coordinate.latitude, type: "current")
        //        }
        presenter.getCoord(lon: 0, lat: 0, type: "current")
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
            //            searchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            //            searchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            //            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            //            searchBar.heightAnchor.constraint(equalToConstant: 50),
            tableView.widthAnchor.constraint(equalTo: view.widthAnchor),
            tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            //            collectionView.topAnchor.constraint(equalTo: self.searchBar.bottomAnchor, constant: 10),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    func configure() {
        //        self.view.addSubview(searchController)
        //        self.view.addSubview(searchBar)
        self.view.addSubview(tableView)
        self.title = "Погода"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: Settings.degreeType, style: .plain, target: self, action: #selector(pressButton(sender:)))
        presenter = MainPresenter(view: self)
        presenter.output = self
        tableView.delegate = self
        tableView.dataSource = self
        //        searchBar.delegate = self
        definesPresentationContext = true
        searchController.searchBar.delegate = self
        
        navigationItem.searchController = searchController
        navigationItem.searchController?.searchBar.placeholder = "Поиск"
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
//        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
//            collectionView.collectionViewLayout = layout
//        }
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

extension MainController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.create(cell: WeatherCell.self, at: indexPath)
        cell.selectionStyle = .none
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.currentWeather.count * 10
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
}

//extension MainController: UICollectionViewDelegateFlowLayout{
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: self.view.frame.width - 20, height: 170)
//    }
//}

extension MainController: UISearchBarDelegate, UIPopoverPresentationControllerDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
        
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if let text = searchBar.text, !text.isEmpty {
            self.view.endEditing(true)
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count <= 2 {
            searchResultController.result = []
            if let _ = searchResultController.presentingViewController as? UINavigationController {
                searchResultController.tableView.reloadData()
            }
        }
        else if searchText.count > 2 {
            searchResultController.result = presenter.inputCity(name: searchText)
            if let _ = searchResultController.presentingViewController as? UINavigationController {
                searchResultController.tableView.reloadData()
            }
            else {
                searchResultController.modalPresentationStyle = .popover
                searchResultController.preferredContentSize = CGSize(width: view.frame.width - 100, height: view.frame.height - 300)
                let popover = searchResultController.popoverPresentationController
                popover?.permittedArrowDirections = .up
                popover?.delegate = self
                popover?.sourceView = self.searchController.searchBar
                popover?.sourceRect = CGRect(x: searchController.searchBar.center.x, y: searchController.searchBar.frame.maxY, width: 1, height: 1)
                present(searchResultController, animated: false, completion: nil)
            }
        }
        
        //        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        // Stop doing the search stuff
        // and clear the text in the search bar
        searchBar.text = ""
        searchBar.setShowsCancelButton(false, animated: true)
        self.searchController.searchBar.endEditing(true)
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        .none
    }
}

extension MainController: MainPresenterOutput {
    func success() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func failure(error: Error) {
        
    }
}

