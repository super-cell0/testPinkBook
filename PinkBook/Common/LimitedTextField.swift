//
//  LimitedTextField.swift
//  PinkBook
//
//  Created by mac on 2023/5/10.
//

import UIKit

@objc protocol DeleteBackDelegate {
    func deleteBack(_ textField: UITextField) -> Void
}

class LimitedTextField: UITextField {
    
    /// 最大可输入字数
    @IBInspectable var maximumLength: Int = 0
    
    @IBInspectable var allowedCharacters: String?
    
    var deleteBackDelegate: DeleteBackDelegate?
    
    private var realDelegate: UITextFieldDelegate?
    
    override var delegate: UITextFieldDelegate? {
        get {
            return realDelegate
        }
        set {
            realDelegate = newValue
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initialization()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initialization()
    }
    
    private func initialization() {
        
        super.delegate = self
        addTarget(self, action: #selector(textFieldTextDidChange(sender:)), for: .editingChanged)
    }
    
    override func forwardingTarget(for aSelector: Selector!) -> Any? {
        if let realDelegate = realDelegate, realDelegate.responds(to: aSelector) {
            return realDelegate
        } else {
            return super.forwardingTarget(for: aSelector)
        }
    }
    
    override func deleteBackward() {
        super.deleteBackward()
        self.deleteBackDelegate?.deleteBack(self)
    }
    
    // This is another third of the magic
    override func responds(to aSelector: Selector!) -> Bool {
        if let realDelegate = realDelegate, realDelegate.responds(to: aSelector) {
            return true
        } else {
            return super.responds(to: aSelector)
        }
    }
    
    @objc private func textFieldTextDidChange(sender: UITextField) {
        
        let string = text ?? ""
        
        if (maximumLength > 0) {
            
            let selectedRange: UITextRange? = markedTextRange
            let tempSelectedTextRange = selectedTextRange
            if selectedRange == nil {
                
                let substring = string.prefix(maximumLength)
                
                text = String(substring)
                selectedTextRange = tempSelectedTextRange
            }
        }
        
    }
    
}

extension LimitedTextField: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if let aText = textField.text, let textRange = Range(range, in: aText) {

            let updatedText = aText.replacingCharacters(in: textRange, with: string)
            
            if !updatedText.isEmpty, let allowedCharacters = allowedCharacters {
                let allowedcharacterSet = CharacterSet(charactersIn: allowedCharacters).inverted
                if updatedText.rangeOfCharacter(from: allowedcharacterSet) != nil {
                    return false
                }
            }
        }
        
        
        if let delegate = realDelegate, delegate.responds(to: #selector(textField(_:shouldChangeCharactersIn:replacementString:))) {
            return delegate.textField!(textField, shouldChangeCharactersIn: range, replacementString: string)
        } else {
            return true
        }
    }
    
    
}


