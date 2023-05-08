//
//  NoteEditReusableView.swift
//  PinkBook
//
//  Created by mac on 2023/5/6.
//

import UIKit

class NoteEditReusableView: UICollectionReusableView {
        
    @IBOutlet weak var addButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        addButton.layer.cornerRadius = 10
        addButton.layer.borderWidth = 1
        addButton.layer.borderColor = UIColor.opaqueSeparator.cgColor

    }
}
