//Copyright © 2023 Mohammed

import Foundation


protocol SignupAPI{
    func signUpWith(_ email:String,name:String,andPassword password:String,handler:@escaping authHandler)
}

protocol SignupDisplayLogic {
    func navigateBack()
    func displayError(error:String)
}

class SignupViewModel {
    
    var controller:SignupDisplayLogic
    var apiServices:SignupAPI?
    
    init(controller:SignupDisplayLogic) {
        self.controller = controller
        self.apiServices = SignupAPIServices()
    }
    
    func signUpWithEmail(_ email:String,name:String,password:String,AndConfirmPassword confirmPassowrd:String){
        if (email.isEmpty){
            self.controller.displayError(error: "Email cannot be empty")
        }else if (name.isEmpty){
            self.controller.displayError(error: "Name cannot be empty")
        }else if (password.isEmpty || confirmPassowrd.isEmpty){
            self.controller.displayError(error: "Password cannot be empty")
        }else if (password != confirmPassowrd){
            self.controller.displayError(error: "The password and its confirmation don't match")
        }else{
            apiServices?.signUpWith(email, name: name, andPassword: password, handler: { [weak self] result, error in
                if error != nil {
                    self?.controller.displayError(error: error!.localizedDescription)
                }else{
                    self?.controller.navigateBack()
                }
            })
        }
    }
    
}
