//
//  FontExtension.swift
//  PinkBook
//
//  Created by mac on 2023/4/21.
//

import UIKit

extension UIFont {
    
    static func myFont(ofSize: CGFloat, weight: UIFont.Weight) -> UIFont {
        switch weight {
        case .regular:
            return UIFont(name: "", size: ofSize) ?? UIFont.systemFont(ofSize: ofSize, weight: weight)
        case .medium:
            return UIFont(name: "", size: ofSize) ?? UIFont.systemFont(ofSize: ofSize, weight: weight)
        case .bold:
            return UIFont(name: "", size: ofSize) ?? UIFont.systemFont(ofSize: ofSize, weight: weight)
        default:
            return UIFont(name: "", size: ofSize) ?? UIFont.systemFont(ofSize: ofSize, weight: weight)
        }
        
    }
}

