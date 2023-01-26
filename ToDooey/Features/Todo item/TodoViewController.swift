//Copyright © 2023 Mohammed

import Foundation
import UIKit


enum TodoAction {
    case ADD
    case UPDATE
}

protocol TodoActionDelegate {
    func addTodo(_ todo:TodoVM)
    func updateTodo(with newTodo:TodoVM)
}

//add default implementations to make the functions optional
extension TodoActionDelegate {
    func addTodo(_ todo:TodoVM){}
    func updateTodo(with newTodo:TodoVM){}
}

class TodoViewController : MyViewController {
    
    @IBOutlet weak var titleField            : MyTextField!
    @IBOutlet weak var dateField             : UIDatePicker!
    @IBOutlet weak var ctaBtn                : MyButton!
    @IBOutlet weak var buttonBottomConstraint: NSLayoutConstraint!
    
    var todoDelegate:TodoActionDelegate?
    var viewModel:TodoViewModel?
    
    
    var todoItem:TodoVM?
    
    var action:TodoAction = .ADD
    
    override func viewDidLoad() {
        if let _ = todoItem {
            action = .UPDATE
        }
        super.viewDidLoad()
        
        viewModel = TodoViewModel(controller: self)
        personalizeNavBar()
        personalizeView()
        
        if action == .UPDATE {
            fillFields()
        }
    }
    
    //Changes navigation bar tint color and title
    func personalizeNavBar() {
        self.navigationController?.navigationBar.tintColor = .label
        self.navigationItem.title = action == .ADD ? "Add todo" : "Update todo"
    }
    
    ///set some attributes depending on the current flow (either is adding a todo or updating one)
    func personalizeView(){
        ctaBtn.setTitle(action == .ADD ? "Add" : "Update", for: .normal)
        dateField.date = Date()
    }
    
    ///fill form field if the user is updating a todo
    func fillFields(){
        self.titleField.text = todoItem?.name
        self.dateField.date = todoItem!.date.toDate()
    }
    
    //event handling for components
    override func handleEvents(){
        super.handleEvents()
        
        //  Moving next button when keyboard appears
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(notification:)), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(notification:)), name:UIResponder.keyboardWillHideNotification, object: nil)
        
        //Call to action button event will change depending on the action
        ctaBtn.handleTap = action == .ADD ? addTodo : updateTodo
    }
    
    //add a todo item
    func addTodo(){
        let title = self.titleField.text!.removeWhitespaces()
        let date = dateField.date.toString()
        
        UI.ShowLoadingView()
        self.viewModel?.addTodoWithTitle(title, andDate: date)
    }
    
    //update a todo item
    func updateTodo(){
        let title = self.titleField.text!.removeWhitespaces()
        let date = dateField.date.toString()
        
        let model:TodoVM = .init(id: todoItem!.todoID, name: title, date: date, isDone: todoItem!.isDone)
        
        UI.ShowLoadingView()
        viewModel?.updateTodoWithId(model.todoID, withData: model)
    }
    
    //move the button up when the keyboard shows
    @objc func keyboardWillShow(notification:NSNotification){
        let userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        self.buttonBottomConstraint.constant = keyboardFrame.size.height + 5
    }
    
    //move the button back to bottom when the keyboard is hidden
    @objc func keyboardWillHide(notification:NSNotification){
        self.buttonBottomConstraint.constant = 10
    }
}

extension TodoViewController : TodoDisplayLogic {
    //display added todo item (after the call is finished)
    func displayAddedTodo(_ todo: TodoVM) {
        UI.HideLoadingView()
        self.navigationController?.popViewController(animated: true)
        todoDelegate?.addTodo(todo)
    }
    //display updated todo item
    func displayUpdatedTodo(_ todo: TodoVM) {
        UI.HideLoadingView()
        self.navigationController?.popViewController(animated: true)
        todoDelegate?.updateTodo(with: todo)
    }
}
