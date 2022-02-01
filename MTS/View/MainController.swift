//
//  ViewController.swift
//  MTS
//
//  Created by Yaroslav Fomenko on 27.01.2022.
//
import CoreLocation
import UIKit

protocol MainVCProtocol: AnyObject {
    var favID: Int? {get set}
}

final class MainController: UIViewController, MainVCProtocol, CLLocationManagerDelegate {
    
    var favID: Int? {
        didSet {
            DispatchQueue.main.async{
                let favId = self.presenter.getFav()
                if favId.count != self.presenter.id.count {
                    self.presenter.id = favId
                    self.presenter.getWeatherViaId(id: favId)
                }

            }
        }
    }
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
    
    lazy var searchResultController: SearchResultController = SearchResultController(result: [City](), output: self)
    
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
        if let location = self.locationManager.location{
            presenter.getCoord(lon: location.coordinate.longitude, lat: location.coordinate.latitude)
        }
        //        presenter.getCoord(lon: 0, lat: 0, type: "current")
        locationManager.stopUpdatingLocation()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.layout()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let favId = presenter.getFav()
        if favId.count != presenter.id.count {
            presenter.id = favId
            presenter.getWeatherViaId(id: favId)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
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
        self.view.backgroundColor = .white
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
        let element = presenter.currentWeather[indexPath.row]
        
        cell.weatherImage.image = UIImage(named: element.weather.first!.icon)
        cell.thermoImage.image = UIImage(named: Settings.degreeType)
        if Settings.degreeType == "C°"{
            cell.thermo.text = "Сейчас: \(element.main.temp.description.toCelsius())°. "
            + "Ощущается: \(element.main.feelsLike.description.toCelsius())°. "
            + "Макс: \(element.main.tempMax.description.toCelsius())°. "
            + "Мин: \(element.main.tempMin.description.toCelsius())°."
        }
        else {
            cell.thermo.text = "Сейчас: \(element.main.temp.description.toFarenheit())°. "
            + "Ощущается: \(element.main.feelsLike.description.toFarenheit())°. "
            + "Макс: \(element.main.tempMax.description.toFarenheit())°. "
            + "Мин: \(element.main.tempMin.description.toFarenheit())°."
            
            
        }
        
        cell.city.text = element.name + ", " + element.sys.country
        if let timezone = element.timezone {
            cell.time.text = element.dt.formatTime(timeZone: timezone)
        }
        else if let timezone = element.sys.timezone {
            cell.time.text = element.dt.formatTime(timeZone: timezone)
        }
        if let windDeg = element.wind.deg, let windSpeed = element.wind.speed {
            cell.wind.text = "\(windDeg.windDirection()). Скорость ветра \(windSpeed) м/c."
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.currentWeather.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC: DetailsViewProtocol = DetailsViewController()
        //        detailVC.weather = presenter.oneCallWeather[0]
        detailVC.city = presenter.currentWeather[indexPath.row].name
        detailVC.id = presenter.currentWeather[indexPath.row].id
        detailVC.coord = Coordinate(lon: presenter.currentWeather[indexPath.row].coord.lon, lat: presenter.currentWeather[indexPath.row].coord.lon)
        navigationController?.pushViewController((detailVC as? DetailsViewController)!, animated: true)
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
        DispatchQueue.main.async {
            self.searchResultController.result = []
            if searchText.count <= 2 {
                if let _ = self.searchResultController.presentingViewController as? UINavigationController {
                    DispatchQueue.main.async {
                        self.searchResultController.tableView.reloadData()
                    }
                }
            }
            else if searchText.count > 2 {
                
                
                //            }
                self.searchResultController.result = self.presenter.inputCity(name: searchText)
                self.searchResultController.tableView.reloadData()
                if let _ = self.searchResultController.presentingViewController as? UINavigationController {
                    
                    //                DispatchQueue.main.async {
                    //                }
                    
                }
                else {
                    let nav = UINavigationController(rootViewController: self.searchResultController)
                    nav.modalPresentationStyle = .popover
                    nav.preferredContentSize = CGSize(width: self.view.frame.width - 70, height: self.view.frame.height - 200)
                    let popover = nav.popoverPresentationController
                    popover?.permittedArrowDirections = .up
                    popover?.delegate = self
                    popover?.sourceView = self.searchController.searchBar
                    popover?.sourceRect = CGRect(x: self.searchController.searchBar.center.x, y: self.searchController.searchBar.frame.maxY, width: 1, height: 1)
                    self.present(nav, animated: false)
                }
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

