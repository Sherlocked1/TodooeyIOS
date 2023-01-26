//Copyright © 2023 Mohammed

import Foundation
import UIKit

class MyCheckbox: MyButton {
    
    // Images
    let checkedImage = UIImage(systemName: "checkmark.circle.fill")!
    let uncheckedImage = UIImage(systemName: "circle")!
    
    //On click callback event
    var onClicked:(()->Void)?
    
    // Bool property
    var isChecked: Bool = false {
        didSet {
            if isChecked == true {
                self.setImage(checkedImage, for: UIControl.State.normal)
            } else {
                self.setImage(uncheckedImage, for: UIControl.State.normal)
            }
        }
    }
    
    //init
    override func awakeFromNib() {
        self.setTitle("", for: .normal)
        self.handleTap = btnClicked
    }
    
    //Checkbox click event
    func btnClicked(){
//        isChecked = !isChecked
        onClicked?()
    }
}
