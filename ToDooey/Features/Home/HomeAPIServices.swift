//Copyright © 2023 Mohammed

import Foundation
import FirebaseAuth

class HomeAPIServices : HomeAPI {
    func fetchTodos(handler: @escaping fetchHandler) {
        FireDB.shared.getTodos(callBack:handler)
    }
    
    func signOut(handler: @escaping signOutHandler) {
        do {
            try Auth.auth().signOut()
            //successfully logged out
            //Delete all todo data
            DB.shared.deleteAllTodos()
            //Move back to login screen
            handler(nil)
        }catch{
            handler(error)
        }
    }
    
    func deleteTodo(_ todo:TodoVM,handler:@escaping deleteTodoHandler){
        FireDB.shared.deleteTodo(todo) {error in
            if let error = error {
                handler(error)
            }else{
                handler(nil)
            }
        }
    }
}
