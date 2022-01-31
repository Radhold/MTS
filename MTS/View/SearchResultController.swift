//
//  SearchResultController.swift
//  MTS
//
//  Created by Yaroslav Fomenko on 30.01.2022.
//

import UIKit

class SearchResultController: UITableViewController, UIPopoverPresentationControllerDelegate {
    
    var result: [City] = [City(id: 0, name: "Moscow", state: "", country: "ru", coord: Coordinate(lon: 0, lat: 0))]
    
    required init(result: [City]){
        super.init(nibName: nil, bundle: nil)
        self.result = result
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
        cell.selectionStyle = .none
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
        
    }
    

}
