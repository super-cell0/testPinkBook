//
//  ChannelViewController.swift
//  PinkBook
//
//  Created by mac on 2023/5/11.
//

import UIKit
import JXSegmentedView

class ChannelViewController: BaseViewController {
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var listView: UIView!
    
    let segmentView = JXSegmentedView()
    let segmentDataSource = JXSegmentedTitleDataSource()
        
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func setupView() {
        super.setupView()
        
    }
    
    override func bindView() {
        super.bindView()
        
        segmentDataSource.titles = channels
        segmentDataSource.titleSelectedColor = .label
        segmentDataSource.titleNormalColor = .opaqueSeparator
        segmentDataSource.titleNormalFont = .myFont(ofSize: 14, weight: .bold)
        segmentDataSource.isTitleColorGradientEnabled = true
        segmentDataSource.isItemSpacingAverageEnabled = true
        
        segmentView.backgroundColor = .mainColor
        segmentView.defaultSelectedIndex = 0
        segmentView.dataSource = segmentDataSource
        
        topView.addSubview(segmentView)
        segmentView.translatesAutoresizingMaskIntoConstraints = false
        segmentView.frame = topView.bounds
        
        let listContainerView = JXSegmentedListContainerView(dataSource: self)
        segmentView.listContainer = listContainerView
        listView.addSubview(listContainerView)
        listContainerView.translatesAutoresizingMaskIntoConstraints = false
        listContainerView.frame = listView.bounds
        
    }
    

}



extension ChannelViewController: JXSegmentedListContainerViewDataSource {
    
    func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
        return channels.count
    }

    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
        //let vc = ListChannelTableViewController()
        let vc = storyboard?.instantiateViewController(withIdentifier: "ListChannelTableViewID") as! ListChannelTableViewController
        vc.subChannels = subAllChannels[index]

        return vc
    }


}
