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
                self.todoTitle.attributedText = NSAttributedString.init(string: data.name, attributes: [.strikethroughStyle: data.isDone])
                self.todoDate.text = data.date.getDateStringWithFormat("EE - HH:mm")
                self.isDoneBtn.isChecked = data.isDone
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.isDoneBtn.onClicked = {
            [weak self] in
            self?.onToggle?()
        }
    }
    
    var onToggle:(()->Void)?
    
}
