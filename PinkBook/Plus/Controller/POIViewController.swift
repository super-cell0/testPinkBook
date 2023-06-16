//
//  POIViewController.swift
//  PinkBook
//
//  Created by mac on 2023/5/22.
//

import UIKit
import MJRefresh

protocol POIViewControllerDelegate {
    func updatePOIName(name: String)
}

class POIViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var delegate: POIViewControllerDelegate?
    
    lazy var locationManager = AMapLocationManager()//定位
    lazy var mapSearch = AMapSearchAPI()//搜索POI用
    ///搜索周边POI请求
    lazy var aroundSearchRequest: AMapPOIAroundSearchRequest = {
        let request = AMapPOIAroundSearchRequest()
        request.location = AMapGeoPoint.location(withLatitude: CGFloat(latitude), longitude: CGFloat(longitude))
        request.types = kPOITypes
        //request.requireExtension = true// not find
        
        request.offset = kOffset
        return request
    }()
    ///关键字检索POI
    lazy var keywordsSearchRequest: AMapPOIKeywordsSearchRequest = {
        let request = AMapPOIKeywordsSearchRequest()
        request.offset = kOffset
        return request
    }()
    
    var pois = kPOIs
    var copyPOIs = kPOIs
    ///纬度
    var latitude = 0.0
    ///经度
    var longitude = 0.0
    var keywords = ""
    lazy var footer = MJRefreshAutoNormalFooter()
    
    var currentPage = 1
    var pageCount = 1
    var currentKeywordsPage = 1
    var poiName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        //带逆地理信息的一次定位（返回坐标和地址信息）
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        //定位超时时间，最低2s，此处设置为2s
        locationManager.locationTimeout = 10
        //逆地理请求超时时间，最低2s，此处设置为2s
        locationManager.reGeocodeTimeout = 10

        
        requestLocation()
        
        mapSearch?.delegate = self
        
        searchBar.delegate = self
        tableView.keyboardDismissMode = .onDrag
        tableView.mj_footer = footer
        
        if let cancelButton = searchBar.value(forKey: "cancelButton") as? UIButton {
            cancelButton.isEnabled = true
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    func endRefreshing(_ currentPage: Int){
        if currentPage < pageCount{
            footer.endRefreshing() //结束上拉加载小菊花的UI
        }else{
            footer.endRefreshingWithNoMoreData() //展示加载完毕UI，并使上拉加载功能失效（不触发@obj的方法了）
        }
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
        
        if poi[0] == poiName {
            cell.accessoryType = .checkmark
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath)!
        cell.accessoryType = .checkmark
        
        self.delegate?.updatePOIName(name: pois[indexPath.row][0])
        
        dismiss(animated: true)
        
    }
}
