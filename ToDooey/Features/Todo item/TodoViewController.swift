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
    
    @IBOutlet weak var titleField : MyTextField!
    @IBOutlet weak var descField  : UITextView!
    @IBOutlet weak var dateField  : MyTextField!
    
    @IBOutlet weak var ctaBtn     : MyButton!
    @IBOutlet weak var buttonBottomConstraint:NSLayoutConstraint!
    
    var todoDelegate:TodoActionDelegate?
    
    
    var todoItem:TodoVM?
    
    var action:TodoAction = .ADD
    
    override func viewDidLoad() {
        
        if let _ = todoItem {
            action = .UPDATE
        }
        
        super.viewDidLoad()
        
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
    
    func personalizeView(){
        ctaBtn.setTitle(action == .ADD ? "Add" : "Update", for: .normal)
        setupDatePicker()
    }
    
    func setupDatePicker(){
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.locale = Locale.init(identifier: "en_us")
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.addTarget(self, action: #selector(didChangeDate), for: .valueChanged)
        self.dateField.inputView = datePicker
    }
    
    @objc func didChangeDate(_ sender:UIDatePicker){
        let date = sender.date
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.init(identifier: "en_us")
        dateFormatter.dateFormat = "dd/MM/yyyy"
        self.dateField.text = dateFormatter.string(from: date)
    }
    
    func fillFields(){
        self.titleField.text = todoItem?.name
        self.dateField.text = todoItem?.date
        self.descField.text = ""
    }
    
    
    override func handleEvents(){
        super.handleEvents()
        
        //  Moving next button when keyboard appears
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(notification:)), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(notification:)), name:UIResponder.keyboardWillHideNotification, object: nil)
        
        ctaBtn.handleTap = action == .ADD ? addTodo : updateTodo
    }
    
    func addTodo(){
        let title = self.titleField.text!
//        let desc = self.descField.text!
        let date = self.dateField.text!
        
        let model:TodoVM = .init(id: 4, name: title, date: date, isDone: false)
        
        self.navigationController?.popViewController(animated: true)
        self.todoDelegate?.addTodo(model)
    }
    
    func updateTodo(){
        let title = self.titleField.text!
//        let desc = self.descField.text!
        let date = self.dateField.text!
        
        let model:TodoVM = .init(id: todoItem!.id, name: title, date: date, isDone: todoItem!.isDone)
        
        self.todoDelegate?.updateTodo(with: model)
        self.navigationController?.popViewController(animated: true)
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
