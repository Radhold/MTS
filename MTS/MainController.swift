//
//  ViewController.swift
//  MTS
//
//  Created by Yaroslav Fomenko on 27.01.2022.
//
import CoreLocation
import UIKit

class MainController: UIViewController, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
    
    let searchBar: UISearchBar = {
        $0.translatesAutoresizingMaskIntoConstraints = false
//        $0.showsCancelButton = true
//        $0.setShowsCancelButton(true, animated: true)
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
        collectionView.delegate = self
        collectionView.dataSource = self
        searchBar.delegate = self
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
//            layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
            collectionView.collectionViewLayout = layout
        }
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }


}

extension MainController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.create(cell: WeatherCell.self, at: indexPath)
        cell.tempNow.text = "-11"
        cell.image.image = UIImage(named: "01d")
        cell.city.text = "Moscow"
        return cell
    }
}

extension MainController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width - 20, height: 100)
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

protocol CellProtocol: UIView {
    static var name: String { get }
}

