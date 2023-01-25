//Copyright © 2023 Mohammed

import UIKit

class TodoTableViewCell: MyTableCell {
    
    @IBOutlet weak var todoView     :MyView!
    @IBOutlet weak var todoTitle    :UILabel!
    @IBOutlet weak var todoDate     :UILabel!
    @IBOutlet weak var isDoneBtn    :MyCheckbox!

    var data:TodoVM? {
        didSet{
            if let data = data {
                self.todoTitle.text = data.name
                self.todoDate.text = data.date.getDateStringWithFormat("EE - HH:mm")
                
                isDoneBtn.onChange = {
                    status in
                    if status {
                        let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: self.todoTitle.text!)
                        
                        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSRange(location: 0, length: attributeString.length))
                        
                        self.todoTitle.attributedText = attributeString
                    }else{
                        let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: self.todoTitle.text!)
                        
                        attributeString.removeAttribute(NSAttributedString.Key.strikethroughStyle, range: NSRange.init(location: 0, length: attributeString.length))
                        
                        self.todoTitle.attributedText = attributeString
                    }
                    
                }
            }
        }
    }
    
}
