//Copyright © 2023 Mohammed

import Foundation

typealias fetchHandler = (_ todos:[TodoVM]?,_ error:Error?)->Void
typealias signOutHandler = (_ error:Error?)->Void
typealias deleteTodoHandler = (_ error:Error?)->Void

protocol HomeAPI {
    func fetchTodos(handler:@escaping fetchHandler)
    func signOut(handler:@escaping signOutHandler)
    func deleteTodo(_ todo:TodoVM,handler:@escaping deleteTodoHandler)
}

protocol HomeDisplayLogic {
    func displayTodos(_ todos:[TodoVM])
    func displayError(error:String)
    func logUserOut()
    func displayDeletedTodoAtRow(_ row:Int)
}

class HomeViewModel {
    
    var controller:HomeDisplayLogic
    
    var apiServices:HomeAPI
    
    init(controller: HomeDisplayLogic) {
        self.controller = controller
        self.apiServices = HomeAPIServices()
    }
    
    func fetchTodos(){
        self.apiServices.fetchTodos { todos, error in
            if (error != nil){
                self.controller.displayError(error:error!.localizedDescription)
            }else{
                self.controller.displayTodos(todos ?? [])
            }
        }
    }
    
    func signOut(){
        apiServices.signOut { error in
            if (error != nil){
                self.controller.displayError(error: error!.localizedDescription)
            }else{
                self.controller.logUserOut()
            }
        }
    }
    
    
    func deleteTodo(_ todo:TodoVM,atRow row:Int) {
        apiServices.deleteTodo(todo) { error in
            if (error != nil){
                self.controller.displayError(error: error!.localizedDescription)
            }else{
                DB.shared.deleteTodo(withId:todo.todoID)
                self.controller.displayDeletedTodoAtRow(row)
            }
        }
    }
    
}
