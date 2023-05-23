//
//  POIViewController.swift
//  PinkBook
//
//  Created by mac on 2023/5/22.
//

import UIKit
import MJRefresh

class POIViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    lazy var locationManager = AMapLocationManager()
    lazy var mapSearch = AMapSearchAPI()
    ///搜索周边POI请求
    lazy var aroundSearchRequest: AMapPOIAroundSearchRequest = {
        let request = AMapPOIAroundSearchRequest()
        request.location = AMapGeoPoint.location(withLatitude: CGFloat(latitude), longitude: CGFloat(longitude))
        //request.types = kPOITypes
        //request.requireExtension = true// not find
        request.offset = kOffset
        return request
    }()
    ///关键字检索POI
    lazy var keywordsSearchRequest: AMapPOIKeywordsSearchRequest = {
        let request = AMapPOIKeywordsSearchRequest()
        request.cityLimit = true
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        requestLocation()
        
        mapSearch?.delegate = self
        
        searchBar.delegate = self
        tableView.keyboardDismissMode = .onDrag
        tableView.mj_footer = footer
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    
}

extension POIViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        dismiss(animated: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //不建议在网络请求的时候做实时搜索
        //self.keywords = searchText
        //pois.removeAll()
        //HUD.showActivityIndicator()
        //keywordsSearchRequest.keywords = self.keywords
        //mapSearch?.aMapPOIKeywordsSearch(keywordsSearchRequest)
        if searchText.isEmpty {
            self.pois = copyPOIs
            self.tableView.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text, !searchText.isBlank else { return }
        self.keywords = searchText
        pois.removeAll()
        HUD.showActivityIndicator()
        keywordsSearchRequest.keywords = self.keywords
        mapSearch?.aMapPOIKeywordsSearch(keywordsSearchRequest)
        
    }
}

extension POIViewController: AMapSearchDelegate {
    
    func onPOISearchDone(_ request: AMapPOISearchBaseRequest!, response: AMapPOISearchResponse!) {
        
        //self?.hideLoadHUD()
        DispatchQueue.main.async {
            HUD.hide()
        }
        
        if response.count == 0 {
            return
        }
        
        for poi in response.pois {
            let province = poi.province == poi.city ? "" : poi.province
            let address = poi.district == poi.address ? "" : poi.address
            
            let poi = [poi.name ?? kNotFindPOI,
                       "\(province.unwrappedText)\(poi.city.unwrappedText)\(poi.district.unwrappedText)\(address.unwrappedText)"
            ]
            self.pois.append(poi)
            if request is AMapPOIAroundSearchRequest {
                self.copyPOIs.append(poi)
            }
        }
        tableView.reloadData()
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
