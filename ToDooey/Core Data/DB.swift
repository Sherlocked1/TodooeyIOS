//Copyright © 2023 Mohammed

import Foundation
import UIKit
import CoreData

class DB {
    var appDelegate:AppDelegate
    var context:NSManagedObjectContext
    
    
    private init(){
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
    }
    
    static let shared = DB()
}

//MARK: - Todo crud
extension DB {
    
    ///get all todos
    func fetchTodos() -> [TodoVM] {
        do{
            let todos = try context.fetch(TodoCD.fetchRequest())
            return todos.map { todoCd in
                return TodoVM.init(fromCoreDataModel: todoCd)
            }
        }catch{
            print(error.localizedDescription)
            return []
        }
    }
    
    ///add todo
    func add(TodoItem todo:TodoVM){
        do {
            let todoCd = TodoCD.init(context: context)
            todoCd.todoID = todo.todoID
            todoCd.todoTitle = todo.name
            todoCd.todoDate = todo.date
            todoCd.isDone = todo.isDone
            try context.save()
        }catch{
            print(error.localizedDescription)
        }
    }
    
    ///Add multiple todos
    func add(todos:[TodoVM]){
        do {
            for todo in todos {
                let todoCD = TodoCD.init(context: context)
                todoCD.todoID = todo.todoID
                todoCD.todoTitle = todo.name
                todoCD.todoDate = todo.date
                todoCD.isDone = todo.isDone
                try context.save()
            }
        }catch{
            print(error.localizedDescription)
        }
    }
    
    ///update todo
    ///- parameter id: the id for the todo item to update
    ///- parameter newTodo: the new todo item data
    func updateTodoWithId(_ id:String,withNewTodo newTodo:TodoVM){
        let fetchRequest = TodoCD.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "todoID = %@", id)
        
        do {
            let fetchResults = try context.fetch(fetchRequest)
            
            if fetchResults.count != 0 {
                let object = fetchResults[0]
                object.setValuesForKeys(
                    [
                        "isDone":newTodo.isDone,
                        "todoDate":newTodo.date,
                        "todoTitle":newTodo.name
                    ] as [String:Any]
                    
                )
            }
            
            try context.save()
        }  catch let error as NSError {
            print("Could not delete. \(error), \(error.userInfo)")
        }
    }
    
    
    ///delete todo
    ///- parameter id: the id for the todo to delete
    func deleteTodo(withId id:String){
        let fetchRequest = TodoCD.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "todoID = %@", id)
        do {
            let fetchResults = try context.fetch(fetchRequest)
            
            if fetchResults.count != 0 {
                let object = fetchResults[0]
                context.delete(object)
            }
            
            try context.save()
        }  catch let error as NSError {
            print("Could not delete. \(error), \(error.userInfo)")
        }
    }
    
    func deleteAllTodos(){
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "TodoCD")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        do{
            try context.execute(deleteRequest)
            try context.save()
            
        }catch{
            print("Could not delete cards \n error: \(error)\n DeleteRequest: \(deleteRequest)")
        }
    }
    
}
