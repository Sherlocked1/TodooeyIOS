//Copyright © 2023 Mohammed

import Foundation
import UIKit
import FirebaseAuth

class HomeViewController:MyViewController {
    
    @IBOutlet weak var todoTable    :UITableView!
    
    @IBOutlet weak var addBtn       :MyButton!
    
    //todos
    var todos : [TodoVM] = DB.shared.fetchTodos()
    
    //fires when the view controller is loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        
        personalizeNavBar()
        setUpRightButton()
        disableBackGesture()
        
        //setup todo tableview
        self.todoTable.register(TodoTableViewCell.nib, forCellReuseIdentifier:TodoTableViewCell.identifier)
        self.todoTable.delegate = self
        self.todoTable.dataSource = self
        
        //remove text from add button
        self.addBtn.setTitle("", for: .normal)
        
        if todos.isEmpty {
            FireDB.shared.getTodos(callBack: { todos, error in
                if let error = error {
                    print(error.localizedDescription)
                }else{
                    self.todos = todos!
                    self.todoTable.reloadData()
                }
            })
        }
    }
    
    override func handleEvents() {
        super.handleEvents()
        self.addBtn.handleTap = addToDo
    }
    
    //Changes navigation bar's title, tint color and back button color
    func personalizeNavBar() {
        self.navigationController?.navigationBar.tintColor = .label
        self.navigationItem.title = "ToDooey"
        self.navigationController?.editButtonItem.tintColor = .label
    }
    
    //disables the back gesture and hides the back button
    //so the user is not able to go back to the previous screen
    func disableBackGesture() {
        navigationItem.setHidesBackButton(true, animated: true)
    }
    
    //setting up the signout button
    func setUpRightButton(){
        self.navigationItem.rightBarButtonItem = .init(image: .init(systemName: "power"), style: .done, target: self, action: #selector(didTapSignout))
    }
    
    func signOut(){
        
        do {
            UI.ShowLoadingView()
            try Auth.auth().signOut()
            UI.HideLoadingView()
            // Sign-out successful
            DB.shared.deleteAllTodos()
            let vc = LoginViewControlelr.instantiate(storyboard: .init(name: "Main", bundle: .main))
            let scene = UIApplication.shared.connectedScenes.first
            let window = (scene?.delegate as? SceneDelegate)?.window
            window?.rootViewController = UINavigationController(rootViewController: vc)
            window?.makeKeyAndVisible()
        } catch let error as NSError {
            // An error occurred while signing out
            print(error.localizedDescription)
        }
        
    }
    
    //add todo
    func addToDo(){
        let vc = TodoViewController.instantiate(storyboard: .init(name: "Main", bundle: .main))
        vc.todoDelegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //add button click event
    @objc func didTapSignout(){
        signOut()
    }
}

extension HomeViewController : UITableViewDelegate, UITableViewDataSource {
    //number of items in table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
    
    //cell configuration
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TodoTableViewCell.identifier, for: indexPath) as! TodoTableViewCell
        
        cell.data = todos[indexPath.row]
        
        return cell
    }
    
    //selection action handling
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = todos[indexPath.row]
        let vc = TodoViewController.instantiate(storyboard: .init(name: "Main", bundle: .main))
        vc.todoItem = data
        vc.todoDelegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //swiping right to delete item
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let item = todos[indexPath.row]
        
        return .init(actions: [
            .init(style: .destructive, title: "Delete", handler: { action, view, handle in
                self.deleteTodoItem(item,atRow:indexPath.row)
            })
        ])
    }
    
}

extension HomeViewController : TodoActionDelegate {
    func addTodo(_ todo: TodoVM) {
        
        FireDB.shared.addTodo(todo) { id, error in
            if let error = error {
                print(error.localizedDescription)
            }else{
                
                var newTodo = todo
                newTodo.todoID = id!
                
                DB.shared.add(TodoItem: newTodo)
                self.todos.append(newTodo)
                self.todoTable.reloadData()
            }
        }
        
    }
    
    func updateTodo(with newTodo: TodoVM) {
        let id = newTodo.todoID
        
        FireDB.shared.updateTodoWith(id, andReplaceWith: newTodo) { error in
            if let error = error {
                print(error.localizedDescription)
            }else{
                let newTodos:[TodoVM] = self.todos.map { todo in
                    if todo.todoID == id {
                        return .init(id: todo.todoID, name: newTodo.name, date: newTodo.date, isDone: newTodo.isDone)
                    }else{
                        return todo
                    }
                }
                self.todos = newTodos
                self.todoTable.reloadData()
            }
        }
    }
    
    //delete item from table view
    func deleteTodoItem(_ todoitem:TodoVM,atRow row:Int) {
        FireDB.shared.deleteTodo(todoitem) { [weak self] error in
            if let error = error {
                print(error.localizedDescription)
            }else{
                self?.todos.remove(at: row)
                self?.todoTable.deleteRows(at: [.init(row: row, section: 0)], with: .left)
                DB.shared.deleteTodo(withId:todoitem.todoID)
            }
        }
    }
}
