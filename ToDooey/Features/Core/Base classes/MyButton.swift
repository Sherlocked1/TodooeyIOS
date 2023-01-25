//Copyright © 2023 Mohammed

import Foundation
import UIKit

class MyButton : UIButton {
    
    
    //MARK: - Button events
    ///handles button press
    var handleTap: (() -> Void)? = nil {
        didSet {
            if let _ = handleTap {
                addTarget(self, action: #selector(didTap(_:)), for: .touchUpInside)
            }
        }
    }
    
    @objc private func didTap(_ sender: MyButton) {
        handleTap?()
    }
    
    
    //MARK: - Button corners
    @IBInspectable var cornerType : String = "ALL"
    
    @IBInspectable var cornerSize : CGFloat = 15 {
        didSet {
            setNeedsDisplay()
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
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
        
        if corner == .allCorners {
            self.layer.cornerRadius = cornerSize
            setNeedsDisplay()
        }else{
            let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corner, cornerRadii: CGSize(width: cornerSize, height: cornerSize))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            self.layer.mask = mask
            self.layer.masksToBounds = true
            setNeedsDisplay()
        }
    }
    
}
