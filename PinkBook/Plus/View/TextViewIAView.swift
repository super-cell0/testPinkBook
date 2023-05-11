//
//  TextViewIAView.swift
//  PinkBook
//
//  Created by mac on 2023/5/11.
//

import UIKit

class TextViewIAView: UIView {

    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var textCountStackView: UIStackView!
    @IBOutlet weak var textCountLabel: UILabel!
    @IBOutlet weak var maxCountLabel: UILabel!
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var currentTextCount = 0 {
        didSet {
            if currentTextCount <= kMaxNoteEditTextViewCount {
                doneButton.isHidden = false
                textCountStackView.isHidden = true
            } else {
                doneButton.isHidden = true
                textCountStackView.isHidden = false
                textCountLabel.text = "\(currentTextCount)"
            }
        }
    }

}
