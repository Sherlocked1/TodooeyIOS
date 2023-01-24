//Copyright © 2023 Mohammed

import Foundation
import UIKit

class MyView : UIView {
    
    
    @IBInspectable var cornerType : String = "ALL"
    
    @IBInspectable var cornerSize : CGFloat = 8 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func layoutSubviews() {
        var corner = UIRectCorner.allCorners
        switch cornerType {
        case "ALL":
            corner = .allCorners
        case "TL":
            corner = .topLeft
        case "TR":
            corner = .topRight
        case "BL":
            corner = .bottomLeft
        case "BR":
            corner = .bottomRight
        case "TLR":
            corner = [.topLeft, .topRight]
        case "BLR":
            corner = [.bottomLeft, .bottomRight]
        case "xTL": // except top left
            corner = [.topRight, .bottomLeft, .bottomRight]
        default:
            corner = .allCorners
        }
        
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corner, cornerRadii: CGSize(width: cornerSize, height: cornerSize))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
        self.layer.masksToBounds = true
        setNeedsDisplay()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        commonInit()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        
        commonInit()
    }
    
    func commonInit(){
        
    }
    
}
