//Copyright © 2023 Mohammed

import Foundation
import UIKit
import FirebaseAuth

class SignUpViewController : MyViewController {
    
    @IBOutlet weak var nameField            : MyTextField!
    @IBOutlet weak var emailField           : MyTextField!
    @IBOutlet weak var passwordField        : MyTextField!
    @IBOutlet weak var confirmPasswordField : MyTextField!
    
    @IBOutlet weak var signUpBtn            : MyButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationItem.title = "Sign up"
    }
    
    override func handleEvents() {
        super.handleEvents()
        
        self.signUpBtn.handleTap = signUp
    }
    
    func signUp(){
        let email = self.emailField.text!
        let password = self.passwordField.text!
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            if error != nil {
                print(error?.localizedDescription)
            }else{
                self?.navigationController?.popViewController(animated: true)
            }
          // ...
        }
    }
}
