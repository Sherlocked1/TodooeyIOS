//Copyright © 2023 Mohammed

import Foundation
import UIKit

class MyViewController : UIViewController {
    
    var hideNavBar : Bool? = false {
        didSet {
            if let hideNavBar = hideNavBar{
                self.navigationController?.isNavigationBarHidden = hideNavBar
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.navigationController?.navigationBar.tintColor = .white
        handleEvents()
    }
    
    func displayError(error:String){
        UI.HideLoadingView()
        showAlertMessage(error)
    }
    
    func showAlertMessage(_ message:String){
        let alertVc = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertVc.addAction(.init(title: "Ok", style: .default))
        self.present(alertVc, animated: true)
    }
    
    func handleEvents(){}
}
