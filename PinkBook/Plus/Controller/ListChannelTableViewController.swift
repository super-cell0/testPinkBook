//
//  ListChannelTableViewController.swift
//  PinkBook
//
//  Created by mac on 2023/5/16.
//

import UIKit
import JXSegmentedView

class ListChannelTableViewController: UITableViewController {
    
    var channels = ""
    var subChannels: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()

    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return subChannels.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listChannelCellID", for: indexPath) as! ChannelTableViewCell

        cell.iconImageView.image = UIImage(systemName: "number")
        cell.titleLabel.text = subChannels[indexPath.row]

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    

}

extension ListChannelTableViewController: JXSegmentedListContainerViewListDelegate {
    
    func listView() -> UIView {
        return view
    }
    
}
