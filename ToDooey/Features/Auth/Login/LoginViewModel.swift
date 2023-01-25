//Copyright © 2023 Mohammed

import Foundation
import FirebaseAuth

typealias handler = ((_ result:AuthDataResult?,_ error:Error?)->Void)

protocol LoginAPI {
    func login(email:String,password:String,handler:@escaping handler)
}

protocol LoginDisplayLogic {
    func displayError(error:String)
    func navigateToHome()
}

class LoginViewModel {
    let controller : LoginDisplayLogic!
    let apiService:LoginAPI!
    
    init(controller: LoginDisplayLogic!) {
        self.controller = controller
        self.apiService = LoginAPIService()
    }
    
    func loginUserWithEmail(_ email:String,andPassword password:String){
        if email.isEmpty {
            self.controller.displayError(error: "The email field can't be empty")
        }else if password.isEmpty {
            self.controller.displayError(error: "The password field can't be empty")
        }else{
            apiService.login(email: email, password: password) { [weak self] result, error in
                if (error != nil){
                    self?.controller.displayError(error: error!.localizedDescription)
                }else if (result != nil){
                    self?.controller.navigateToHome()
                }
            }
        }
    }
    
}
