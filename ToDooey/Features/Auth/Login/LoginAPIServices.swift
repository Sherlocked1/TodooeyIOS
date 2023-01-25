//Copyright © 2023 Mohammed

import Foundation
import FirebaseAuth

class LoginAPIService : LoginAPI {
    func login(email: String, password: String, handler: @escaping handler) {
        Auth.auth().signIn(withEmail: email, password: password,completion: handler)
    }
}
