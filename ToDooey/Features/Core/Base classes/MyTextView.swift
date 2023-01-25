//Copyright © 2023 Mohammed

import Foundation
import UIKit

class MyTextView : UITextView {
    
    @IBInspectable var placeholderColor : UIColor = .gray
    @IBInspectable var placeholder : String = ""
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.backgroundColor = .foreground_10
        
        addCornerRadius()
        addPadding()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        commonInit()
    }
    
    func commonInit(){
        setupPlaceholder()
    }
    
    func setupPlaceholder(){
        delegate = self
        text = placeholder
        textColor = placeholderColor
    }
    
    func addCornerRadius () {
        self.layer.cornerRadius = 15
        self.clipsToBounds = true
    }
    
    func addPadding(){
        contentInset = .init(top: 10, left: 15, bottom: 10, right: 15)
    }
}

extension MyTextView:UITextViewDelegate {
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textColor == placeholderColor {
            text = nil
            textColor = .foreground
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if text.isEmpty {
            text = placeholder
            textColor = placeholderColor
        }
    }
    
}
