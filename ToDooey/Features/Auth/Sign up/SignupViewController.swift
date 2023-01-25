//Copyright © 2023 Mohammed

import Foundation
import UIKit
import FirebaseAuth

class SignUpViewController : MyViewController, SignupDisplayLogic{
    
    @IBOutlet weak var nameField            : MyTextField!
    @IBOutlet weak var emailField           : MyTextField!
    @IBOutlet weak var passwordField        : MyTextField!
    @IBOutlet weak var confirmPasswordField : MyTextField!
    
    @IBOutlet weak var signUpBtn            : MyButton!
    
    
    var viewModel:SignupViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationItem.title = "Sign up"
        viewModel = SignupViewModel(controller: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.hideNavBar = false
    }
    
    override func handleEvents() {
        super.handleEvents()
        
        self.signUpBtn.handleTap = signUp
    }
    
    func navigateBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func signUp(){
        let name = self.nameField.text!
        let email = self.emailField.text!
        let password = self.passwordField.text!
        let confirmPassword = self.confirmPasswordField.text!
        
        viewModel?.signUpWithEmail(email, name: name, password: password, AndConfirmPassword: confirmPassword)
    }
}
