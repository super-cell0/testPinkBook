//
//  DiscoverViewController.swift
//  PinkBook
//
//  Created by mac on 2023/4/21.
//

import UIKit
import JXSegmentedView

class DiscoverViewController: BaseViewController {
    
    let segmentDataSource = JXSegmentedTitleDataSource()
    let segmentView = JXSegmentedView()
    
    lazy var segmentTitleView: UIView = {
        let v = UIView()
        return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        //处于第一个item的时候，才允许屏幕边缘手势返回
        navigationController?.interactivePopGestureRecognizer?.isEnabled = (segmentView.selectedIndex == 0)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        //离开页面的时候，需要恢复屏幕边缘手势，不能影响其他页面
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }

    
    override func setupView() {
        super.setupView()
        
    }
    
    override func bindView() {
        super.bindView()
                
        segmentDataSource.titles = DiscoverCategory.allCases.map(\.title)
        segmentDataSource.titleSelectedColor = .label
        segmentDataSource.titleNormalFont = .myFont(ofSize: 14, weight: .bold)
        segmentDataSource.titleNormalColor = .opaqueSeparator
        segmentDataSource.isTitleColorGradientEnabled = true
        segmentDataSource.isItemSpacingAverageEnabled = true
        
        segmentView.backgroundColor = .white
        segmentView.defaultSelectedIndex = 0
        segmentView.dataSource = segmentDataSource
        
        view.addSubview(segmentTitleView)
        segmentTitleView.translatesAutoresizingMaskIntoConstraints = false
        
        segmentTitleView.addSubview(segmentView)
        segmentView.translatesAutoresizingMaskIntoConstraints = false
        
        let listContainerView = JXSegmentedListContainerView(dataSource: self)
        segmentView.listContainer = listContainerView
        view.addSubview(listContainerView)
        listContainerView.translatesAutoresizingMaskIntoConstraints = false
                
        NSLayoutConstraint.activate([
            segmentTitleView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            segmentTitleView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            segmentTitleView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            segmentTitleView.heightAnchor.constraint(equalToConstant: 44),
                        
            segmentView.topAnchor.constraint(equalTo: self.segmentTitleView.topAnchor, constant: 0),
            segmentView.bottomAnchor.constraint(equalTo: self.segmentTitleView.bottomAnchor, constant: 0),
            segmentView.leadingAnchor.constraint(equalTo: self.segmentTitleView.leadingAnchor, constant: 0),
            segmentView.trailingAnchor.constraint(equalTo: self.segmentTitleView.trailingAnchor, constant: 0),

            listContainerView.topAnchor.constraint(equalTo: self.segmentTitleView.bottomAnchor, constant: 0),
            listContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            listContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            listContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
        ])
        
    }

}

extension DiscoverViewController: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return view
    }
}

extension DiscoverViewController: JXSegmentedListContainerViewDataSource {
    func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
        return DiscoverCategory.allCases.count
    }
    
    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
        let vc = ListContainerViewController()
        return vc
    }
    
    
}
