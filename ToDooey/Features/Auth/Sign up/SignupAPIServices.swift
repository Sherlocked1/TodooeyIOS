//Copyright © 2023 Mohammed

import Foundation
import FirebaseAuth
class SignupAPIServices : SignupAPI {
    func signUpWith(_ email: String, name: String, andPassword password: String, handler: @escaping authHandler) {
        
        Auth.auth().createUser(withEmail: email, password: password,completion:handler)
        
    }
}
