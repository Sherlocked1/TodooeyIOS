//Copyright © 2023 Mohammed

import Foundation
import UIKit

class LoginViewControlelr : MyViewController {
    
    @IBOutlet weak var usernameField    : MyTextField!
    @IBOutlet weak var passwordField    : MyTextField!
    
    @IBOutlet weak var loginButton      : MyButton!
    @IBOutlet weak var signupButton     : MyButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
    }
    
    override func handleEvents(){
        super.handleEvents()
        self.loginButton.handleTap = {
            [weak self] in
            HomeViewController.instantiateAndPush(navigationController: (self?.navigationController)!, animated: true)
        }
        self.signupButton.handleTap = {
            [weak self] in
            SignUpViewController.instantiateAndPush(navigationController: (self?.navigationController)!, animated: true)
        }
    }
}
