//Copyright © 2023 Mohammed

import Foundation
import UIKit

class MyTextField : UITextField {
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        commonInit()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    func commonInit(){
        self.backgroundColor = .foreground_10
        self.borderStyle = .none
        addPadding()
        addCornerRadius()
        
        //default placeholder color
        self.setPlaceholderColor(.foreground!)
    }
    
    func addPadding(){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = .always
        
        self.rightView = paddingView
        self.rightViewMode = .always
    }
    
    func addCornerRadius () {
        self.layer.cornerRadius = 15
        self.clipsToBounds = true
    }
    
    
    @IBInspectable
    var placeHolderColor : UIColor = .placeholderText {
        didSet{
            self.setPlaceholderColor(placeHolderColor)
        }
    }
    
    func setPlaceholderColor(_ color: UIColor) {
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor: color])
    }
    
    
}
