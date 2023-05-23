//
//  POIViewController.swift
//  PinkBook
//
//  Created by mac on 2023/5/22.
//

import UIKit

class POIViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let locationManager = AMapLocationManager()
    var pois = [["不显示位置", ""]]

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
        requestLocation()

    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    

}

extension POIViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pois.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //POITabelViewCellID
        let cell = tableView.dequeueReusableCell(withIdentifier: "POITabelViewCellID", for: indexPath) as! POITableViewCell
        let poi = pois[indexPath.row]
        cell.poi = poi
        
        return cell
    }
    
    
}
