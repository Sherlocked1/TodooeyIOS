//Copyright © 2023 Mohammed

import Foundation

typealias addTodoHandler = (_ todoID:String?,_ error:Error?) -> Void
typealias updateTodoHandler = (_ error:Error?) -> Void

protocol TodoAPI {
    func addTodo(_ todo:TodoVM,handler:@escaping addTodoHandler)
    func updateTodoWithId(_ id:String,withData newTodo:TodoVM,handler:@escaping updateTodoHandler)
}

protocol TodoDisplayLogic {
    func displayAddedTodo(_ todo:TodoVM)
    func displayUpdatedTodo(_ todo:TodoVM)
    func displayError(error: String)
}

class TodoViewModel {
    var controller : TodoDisplayLogic
    
    var apiServices : TodoAPI
    
    init(controller: TodoDisplayLogic) {
        self.controller = controller
        self.apiServices = TodoAPIService()
    }
    
    func addTodoWithTitle(_ title:String,andDate date:String){
        if title.isEmpty {
            self.controller.displayError(error: "Title cannot be empty!")
        }else if date.isEmpty {
            self.controller.displayError(error: "Please specify a date for your task.")
        }else{
            let todo = TodoVM.init(id: "", name: title, date: date, isDone: false)
            apiServices.addTodo(todo) { [weak self] todoID, error in
                if let error = error{
                    self?.controller.displayError(error: error.localizedDescription)
                } else {
                    var newTodo = todo
                    newTodo.todoID = todoID!
                    
                    DB.shared.add(TodoItem: newTodo)
                    self?.controller.displayAddedTodo(newTodo)
                }
            }
        }
        
    }
    
    func updateTodoWithId(_ id:String,withData newTodo:TodoVM) {
        self.apiServices.updateTodoWithId(id, withData: newTodo) { error in
            if (error != nil){
                self.controller.displayError(error: error!.localizedDescription)
            }else{
                DB.shared.updateTodoWithId(id, withNewTodo: newTodo)
                self.controller.displayUpdatedTodo(newTodo)
            }
        }
    }
}
