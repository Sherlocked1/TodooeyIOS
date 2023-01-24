//Copyright © 2023 Mohammed

import Foundation
import UIKit

class MyViewController : UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.navigationController?.navigationBar.tintColor = .white
        handleEvents()
    }
    
    func handleEvents(){}
}
