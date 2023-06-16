//
//  POIKeywordsSearchRequest.swift
//  PinkBook
//
//  Created by mac on 2023/5/25.
//


extension POIViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        dismiss(animated: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //不建议在网络请求的时候做实时搜索
        if searchText.isEmpty {
            
            //重置
            self.pois = copyPOIs
            setAroundSearchFooter()
            
            self.tableView.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text, !searchText.isBlank else { return }
        self.keywords = searchText
        pois.removeAll()
        //keywordsSearchRequest.keywords = self.keywords
        currentKeywordsPage = 1
        
        keywordsSearchFooter()
        
        HUD.showActivityIndicator()
        makeKeywordSearch(keywords: self.keywords)
        
    }
    
}

extension POIViewController {
    
    func keywordsSearchFooter() {
        self.footer.resetNoMoreData()
        footer.setRefreshingTarget(self, refreshingAction: #selector(keywordsSearchRequestToMJ))
    }
    
    @objc func keywordsSearchRequestToMJ() {
        currentKeywordsPage += 1
        makeKeywordSearch(keywords: keywords, page: currentKeywordsPage)
        endRefreshing(currentKeywordsPage)

    }
    
    func makeKeywordSearch(keywords: String, page: Int = 1 ) {
        keywordsSearchRequest.keywords = keywords
        keywordsSearchRequest.page = page
        mapSearch?.aMapPOIKeywordsSearch(keywordsSearchRequest)
    }

}



extension POIViewController: AMapSearchDelegate {
    
    func onPOISearchDone(_ request: AMapPOISearchBaseRequest!, response: AMapPOISearchResponse!) {
        
        print("count: \(response.count)")

        //self?.hideLoadHUD()
        DispatchQueue.main.async {
            HUD.hide()
        }
        if response.count > kOffset {
            pageCount = response.count / kOffset + 1
        } else {
            footer.endRefreshingWithNoMoreData()
        }
        
        if response.count == 0 {
            return
        }
        
        print("poi: \(response.pois.count)")
        
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


