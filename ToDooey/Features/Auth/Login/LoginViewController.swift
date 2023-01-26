//Copyright © 2023 Mohammed

import Foundation
import UIKit
import FirebaseAuth

class LoginViewController : MyViewController , LoginDisplayLogic {
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.hideNavBar = true
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
        let email = self.usernameField.text!.removeWhitespaces()
        let password = self.passwordField.text!.removeWhitespaces()
        
        UI.ShowLoadingView()
        viewModel?.loginUserWithEmail(email, andPassword: password)
    }
    
    //navigate to home view after a successful login
    func navigateToHome() {
        UI.HideLoadingView()
        HomeViewController.instantiateAndPush(navigationController: (self.navigationController)!, animated: true)
    }
}
