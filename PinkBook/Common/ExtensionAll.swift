//
//  ExtensionAll.swift
//  PinkBook
//
//  Created by mac on 2023/5/5.
//

import Foundation
import MBProgressHUD

extension Bundle {
    var appName: String {
        if let appName = localizedInfoDictionary?["CFBundleDisplayName"] as? String {
            return appName
        } else {
            return infoDictionary!["CFBundleDisplayName"] as! String
        }

    }
}

struct HUD {
    
    static let keyWindow = UIApplication.shared.connectedScenes
        .filter({$0.activationState == .foregroundActive})
        .compactMap({$0 as? UIWindowScene})
        .first?.windows
        .filter({$0.isKeyWindow}).first
    
    static func showActivityIndicator() {
        guard let view = keyWindow else { return }
        MBProgressHUD.hide(for: view, animated: true)
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.contentColor = .white
        hud.bezelView.color = .mainColor
        hud.bezelView.style = .solidColor
    }
    
    static func show(_ message: String) {
        guard let view = keyWindow else { return }
        MBProgressHUD.hide(for: view, animated: true)
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.mode = .text
        hud.label.text = message
        hud.label.font = .myFont(ofSize: 14, weight: .medium)
        hud.label.numberOfLines = 0
        hud.contentColor = .white
        hud.bezelView.color = .mainColor
        hud.bezelView.style = .solidColor
        hud.isUserInteractionEnabled = false
        hud.hide(animated: true, afterDelay: 2.5)
        
    }
    
    static func show(_ error: Error) {
        Self.show(error.localizedDescription)
    }
    
    static func hide() {
        guard let view = keyWindow else { return }
        MBProgressHUD.hide(for: view, animated: true)
    }
}

