//
//  HomeViewController.swift
//  PinkBook
//
//  Created by mac on 2023/4/21.
//

import UIKit
import JXSegmentedView

class HomeViewController: BaseViewController {
    
    let segmentDataSource = JXSegmentedTitleDataSource()
    let segmentView = JXSegmentedView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func setupView() {
        super.setupView()
        
        segmentDataSource.titles = HomesCategory.allCases.map(\.title)
        segmentDataSource.titleSelectedColor = .mainColor
        segmentDataSource.titleNormalFont = .myFont(ofSize: 15, weight: .bold)
        segmentDataSource.titleNormalColor = UIColor.label
        segmentDataSource.isTitleColorGradientEnabled = true
        segmentDataSource.isItemSpacingAverageEnabled = true
        
        let indicatorView = JXSegmentedIndicatorLineView()
        indicatorView.indicatorWidth = 16
        indicatorView.indicatorHeight = 2
        indicatorView.verticalOffset = 10
        indicatorView.indicatorColor = .mainColor
        
        segmentView.backgroundColor = .white
        segmentView.defaultSelectedIndex = 1
        segmentView.dataSource = segmentDataSource
        segmentView.indicators = [indicatorView]
        segmentView.frame.size = CGSize(width: UIScreen.main.bounds.size.width - 110, height: UIScreen.main.bounds.size.height)
        navigationItem.titleView = segmentView
        navigationItem.titleView?.backgroundColor = .clear
        
        let listContainer = JXSegmentedListContainerView(dataSource: self)
        segmentView.listContainer = listContainer
        view.addSubview(listContainer)
        listContainer.frame = self.view.bounds

        

    }
    
    override func bindView() {
        super.bindView()
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension HomeViewController: JXSegmentedListContainerViewDataSource {
    func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
        return HomesCategory.allCases.count
    } 
    
    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
        guard let titles = HomesCategory(rawValue: index + 1) else { fatalError()}
        switch titles {
        case .follow:
            return FollowViewController()
        case .discover:
            return DiscoverViewController()
        case .nearby:
            return NearbyViewController()
        }
    }
    
    
}
