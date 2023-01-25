//Copyright © 2023 Mohammed

import Foundation

class TodoAPIService : TodoAPI {
    func addTodo(_ todo: TodoVM, handler: @escaping addTodoHandler) {
        FireDB.shared.addTodo(todo) { id, error in
            if let error = error {
                handler(nil,error)
            }else{
                handler(id,nil)
            }
        }
    }
    
    func updateTodoWithId(_ id: String, withData newTodo: TodoVM, handler: @escaping updateTodoHandler) {
        FireDB.shared.updateTodoWith(id, andReplaceWith: newTodo,callBack: handler)
    }
}
