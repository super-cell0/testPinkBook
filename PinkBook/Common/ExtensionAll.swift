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
    
    //static可以修饰class/struct/enum的存储属性、计算属性、方法 类方法不能继承
    //class能修饰类的计算属性和方法 类方法可以继承
    //在protocol中要用static
    static func loadView<T>(fromNib: String, type: T.Type) -> T {
        if let view = Bundle.main.loadNibNamed(fromNib, owner: nil)?.first as? T {
            return view
        } else {
            fatalError("加载\(type)失败🤯")
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

extension UIViewController {
    
    ///点击空白处关闭键盘
    func hideKeyboardOnTapped() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func showLoadHUD(title: String? = nil) {
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.label.text = title
        hud.contentColor = .mainColor
        hud.bezelView.color = .opaqueSeparator
        hud.bezelView.style = .blur

    }
    
    func hideLoadHUD() {
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
}

extension UITextField {
    var unwrappedText: String { text ?? ""}
}
