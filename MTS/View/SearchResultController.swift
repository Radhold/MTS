//
//  SearchResultController.swift
//  MTS
//
//  Created by Yaroslav Fomenko on 30.01.2022.
//

import UIKit

class SearchResultController: UITableViewController, UIPopoverPresentationControllerDelegate {
    
    var result: [City] = [City]()
    weak var output: MainVCProtocol?
    required init(result: [City], output: MainVCProtocol){
        super.init(nibName: nil, bundle: nil)
        self.result = result
        self.output = output
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(classCell: SearchResultCell.self)
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return result.count
        
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.create(cell: SearchResultCell.self, at: indexPath)
//        cell.selectionStyle = .none
        let element = result[indexPath.row]
        cell.city.text = "\(element.name), \(element.country)"
        return cell
    }
    
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        .none
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 35
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc: DetailsViewProtocol = DetailsViewController()
        guard let detailVC = vc as? DetailsViewController else {return}
//        detailVC.weather = presenter.oneCallWeather[0]
        let element = result[indexPath.row]
        detailVC.city = element.name
        detailVC.id = element.id
        detailVC.coord = Coordinate(lon: element.coord.lon, lat: element.coord.lon)
        detailVC.modalPresentationStyle = .currentContext
        detailVC.output = self.output
        self.navigationController?.pushViewController(detailVC, animated: true)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        self.result = []
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    

}
