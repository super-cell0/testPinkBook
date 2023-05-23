//
//  POITableViewCell.swift
//  PinkBook
//
//  Created by mac on 2023/5/23.
//

import UIKit

class POITableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    var poi = ["", ""] {
        didSet {
            titleLabel.text = poi[0]
            subtitleLabel.text = poi[1]
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
