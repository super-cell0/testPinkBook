//
//  ChannelViewController.swift
//  PinkBook
//
//  Created by mac on 2023/5/11.
//

import UIKit
import JXSegmentedView

//protocol ChannelViewControllerDelegate {
//    func updateChannel(channel: String, subChannel: String)
//}

class ChannelViewController: BaseViewController {
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var listView: UIView!
    
    let segmentView = JXSegmentedView()
    //let segmentDataSource = JXSegmentedTitleDataSource()
    let segmentDataSource = JXSegmentedTitleImageDataSource()
    
    //var channelDelegate: ChannelViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func setupView() {
        super.setupView()
        
    }
    
    override func bindView() {
        super.bindView()
        
        segmentDataSource.imageSize = CGSize(width: 20, height: 20)
        segmentDataSource.normalImageInfos = ["10", "9", "8", "7", "6", "5", "4", "3"]
        segmentDataSource.loadImageClosure = {imageView, normalImageInfo in
            imageView.image = UIImage(named: normalImageInfo)
        }
        segmentDataSource.titleImageType = .rightImage
        segmentView.backgroundColor = .mainColor

        segmentDataSource.titles = channels
        segmentDataSource.titleSelectedColor = .label
        segmentDataSource.titleNormalColor = .opaqueSeparator
        segmentDataSource.titleNormalFont = .myFont(ofSize: 14, weight: .bold)
        segmentDataSource.isTitleColorGradientEnabled = true
        segmentDataSource.isItemSpacingAverageEnabled = true
        
        
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
        vc.channels = channels[index]
        vc.subChannels = subAllChannels[index]

        return vc
    }


}
