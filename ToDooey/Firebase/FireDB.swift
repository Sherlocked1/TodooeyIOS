//Copyright © 2023 Mohammed

import Foundation
import FirebaseFirestore
import FirebaseAuth

class FireDB {
    
    var db:Firestore
    var currentUser = FirebaseAuth.Auth.auth().currentUser
    
    private init () {
        db = Firestore.firestore()
        
        Auth.auth().addStateDidChangeListener { auth, user in
            if let user = user {
                // User is signed in.
                self.currentUser = user
            } else {
                // No user is signed in.
                self.currentUser = nil
            }
        }
    }
    
    static let shared = FireDB()
    
    
    func getTodos(callBack : @escaping (_ todos:[TodoVM]?,_ error:Error?) -> Void){
        
        var todos:[TodoVM] = []
        
        let currentUserEmail = currentUser!.email!
        
        
        db.collection("todos").whereField("UserEmail", isEqualTo: currentUserEmail).getDocuments() {
            querySnapshop , error in
            
            if let error = error {
                print(error.localizedDescription)
                callBack(nil,error)
            }else{
                for document in querySnapshop!.documents {
                    
                    let title = document.get("Title") as! String
                    let isDone = document.get("IsDone") as! Bool
                    let date = document.get("Date") as! String
                    let id = document.documentID
                    
                    todos.append(.init(id: id, name: title, date: date, isDone: isDone))
                }
                
                callBack(todos,nil)
            }
        }
    }
    
    func addTodo(_ todo:TodoVM,callBack: @escaping (_ id:String?,_ error:Error?) -> Void ){
        
        let data = [
            "UserEmail":currentUser!.email!,
            "Title":todo.name,
            "Date":todo.date,
            "IsDone":todo.isDone,
        ] as [String:Any]
        
        var ref: DocumentReference? = nil
        ref = db.collection("todos").addDocument(data:data) { err in
            if let err = err {
                callBack(nil,err)
            } else {
                callBack(ref?.documentID,nil)
            }
        }
    }
    
    func deleteTodo(_ todo:TodoVM, callBack: @escaping (_ error:Error?) -> Void){
        db.collection("todos").document(todo.todoID).delete { error in
            if error != nil {
                callBack(error)
            }else{
                callBack(nil)
            }
        }
    }
    
    func updateTodoWith(_ id:String,andReplaceWith todo:TodoVM, callBack: @escaping (_ error:Error?) -> Void){
        db.collection("todos").document(id).updateData([
            "Title":todo.name,
            "IsDone":todo.isDone,
            "Date":todo.date
        ]) { error in
            if error != nil {
                callBack(error)
            }else{
                callBack(nil)
            }
        }
    }
    
}
