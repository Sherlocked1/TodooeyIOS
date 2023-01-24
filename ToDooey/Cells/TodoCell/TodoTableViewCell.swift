//Copyright © 2023 Mohammed

import UIKit

class TodoTableViewCell: MyTableCell {
    
    @IBOutlet weak var todoView:MyView!
    @IBOutlet weak var todoTitle:UILabel!
    @IBOutlet weak var todoDate :UILabel!

    var data:TodoVM? {
        didSet{
            if let data = data {
                self.todoTitle.text = data.name
                self.todoDate.text = data.date
            }
        }
    }
    
}
