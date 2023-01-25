//Copyright © 2023 Mohammed

import Foundation
import UIKit
import FirebaseAuth

class LoginViewControlelr : MyViewController , LoginDisplayLogic {
    
    @IBOutlet weak var usernameField    : MyTextField!
    @IBOutlet weak var passwordField    : MyTextField!
    
    @IBOutlet weak var loginButton      : MyButton!
    @IBOutlet weak var signupButton     : MyButton!
    
    var viewModel:LoginViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        viewModel = LoginViewModel(controller: self)
    }
    
    override func handleEvents(){
        super.handleEvents()
        self.loginButton.handleTap = signIn
        self.signupButton.handleTap = {
            [weak self] in
            SignUpViewController.instantiateAndPush(navigationController: (self?.navigationController)!, animated: true)
        }
    }
    
    func signIn () {
        let email = self.usernameField.text!
        let password = self.passwordField.text!
        
        UI.ShowLoadingView()
        viewModel?.loginUserWithEmail(email, andPassword: password)
    }
    
    func navigateToHome() {
        UI.HideLoadingView()
        HomeViewController.instantiateAndPush(navigationController: (self.navigationController)!, animated: true)
    }
}
