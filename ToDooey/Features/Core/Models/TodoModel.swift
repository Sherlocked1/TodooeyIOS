//Copyright © 2023 Mohammed

import Foundation

struct TodoVM {
    var todoID  :String
    var name    :String
    var date    :String
    var isDone  :Bool
    
    init(fromCoreDataModel model:TodoCD){
        self.todoID = model.todoID!
        self.name = model.todoTitle!
        self.date = model.todoDate!
        self.isDone = model.isDone
    }
    
    init(id:String,name:String,date:String,isDone:Bool){
        self.todoID = id
        self.name = name
        self.date = date
        self.isDone = isDone
    }
}
