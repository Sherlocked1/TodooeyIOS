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
    
    //validate fields data and and add the todo item to coredata and firestore
    func addTodoWithTitle(_ title:String,andDate date:String){
        if dataIsValid(title: title, date: date) {
            let todo = TodoVM.init(id: "", name: title, date: date, isDone: false)
            apiServices.addTodo(todo) { [weak self] todoID, error in
                if let error = error{
                    self?.controller.displayError(error: error.localizedDescription)
                } else {
                    var newTodo = todo
                    newTodo.todoID = todoID!
                    TodoNotificationManager.shared.scheduleNotification(for: newTodo)
                    DB.shared.add(TodoItem: newTodo)
                    self?.controller.displayAddedTodo(newTodo)
                }
            }
        }
        
    }
    
    ///validates the given title and date strings
    func dataIsValid(title:String,date:String) -> Bool {
        if title.isEmpty {
            self.controller.displayError(error: "Title cannot be empty!")
            return false
        }else if date.isEmpty {
            self.controller.displayError(error: "Please specify a date for your task.")
            return false
        }else{
            return true
        }
    }
    
    
    func updateTodoWithId(_ id:String,withData newTodo:TodoVM) {
        if dataIsValid(title: newTodo.name, date: newTodo.date){
            self.apiServices.updateTodoWithId(id, withData: newTodo) { error in
                if (error != nil){
                    self.controller.displayError(error: error!.localizedDescription)
                }else{
                    TodoNotificationManager.shared.updateTodo(newTodo)
                    DB.shared.updateTodoWithId(id, withNewTodo: newTodo)
                    self.controller.displayUpdatedTodo(newTodo)
                }
            }
        }
    }
}
