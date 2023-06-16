//
//  POIRequestLocation.swift
//  PinkBook
//
//  Created by mac on 2023/5/23.
//

import Foundation

extension POIViewController {
    
    ///高德定位
    func requestLocation() {
        
        //self.showLoadHUD()
        DispatchQueue.main.async {
            HUD.showActivityIndicator()
        }
        //定位
        locationManager.requestLocation(withReGeocode: true, completionBlock: { [weak self] (location: CLLocation?, reGeocode: AMapLocationReGeocode?, error: Error?) in
            
            guard let self = self else { return }
            
            if let error = error {
                let error = error as NSError
                
                if error.code == AMapLocationErrorCode.locateFailed.rawValue {
                    //定位错误：此时location和regeocode没有返回值，不进行annotation的添加
                    print("定位错误:{\(error.code) - \(error.localizedDescription)};")
                    //self?.hideLoadHUD()
                    DispatchQueue.main.async {
                        HUD.hide()
                    }
                    return
                } else if error.code == AMapLocationErrorCode.reGeocodeFailed.rawValue
                            || error.code == AMapLocationErrorCode.timeOut.rawValue
                            || error.code == AMapLocationErrorCode.cannotFindHost.rawValue
                            || error.code == AMapLocationErrorCode.badURL.rawValue
                            || error.code == AMapLocationErrorCode.notConnectedToInternet.rawValue
                            || error.code == AMapLocationErrorCode.cannotConnectToHost.rawValue {
                    
                    //逆地理错误：在带逆地理的单次定位中，逆地理过程可能发生错误，此时location有返回值，regeocode无返回值，进行annotation的添加
                    print("逆地理错误:{\(error.code) - \(error.localizedDescription)};")
                    //self?.hideLoadHUD()
                    DispatchQueue.main.async {
                        HUD.hide()
                    }
                    return
                } else {
                    //没有错误：location有返回值，regeocode是否有返回值取决于是否进行逆地理操作，进行annotation的添加
                }
            }
            
            if let location = location {
                //print("location: \(location)")
                self.latitude = location.coordinate.latitude
                self.longitude = location.coordinate.longitude
                
                //self.footer.setRefreshingTarget(self, refreshingAction: #selector(self.aroundSearchRequestToMJ))
                self.setAroundSearchFooter()
                //检索周边POI
                self.makeAroundSearch()
            }
            
            if let reGeocode = reGeocode {
                //print("reGeocode: \(reGeocode)")
                //print(reGeocode.formattedAddress as Any)
                guard let formattedAddress = reGeocode.formattedAddress, !formattedAddress.isEmpty else { return }
                
                let province = reGeocode.province == reGeocode.city ? "" : reGeocode.province
                
                let currentPOI = [
                    reGeocode.poiName ?? kNotFindPOI,
                    "\(province.unwrappedText)\(reGeocode.city.unwrappedText)\(reGeocode.district.unwrappedText)\(reGeocode.street.unwrappedText)\(reGeocode.number.unwrappedText)"
                ]
                
                self.pois.append(currentPOI)
                self.copyPOIs.append(currentPOI)
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        })
        
    }
    
    func makeAroundSearch(page: Int = 1) {
        self.aroundSearchRequest.page = page
        self.mapSearch?.aMapPOIAroundSearch(self.aroundSearchRequest)
    }
    
}

extension POIViewController {
    
    func setAroundSearchFooter() {
        self.footer.resetNoMoreData()
        self.footer.setRefreshingTarget(self, refreshingAction: #selector(aroundSearchRequestToMJ))
    }
    
    
    @objc func aroundSearchRequestToMJ() {
        self.currentPage += 1
        self.makeAroundSearch(page: currentPage)
        endRefreshing(currentPage)
    }
    
}
