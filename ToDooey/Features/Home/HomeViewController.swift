//Copyright © 2023 Mohammed

import Foundation
import UIKit

class HomeViewController:MyViewController {
    
    @IBOutlet weak var todoTable    :UITableView!
    
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
    
    //setting up the add button
    func setUpRightButton(){
        self.navigationItem.rightBarButtonItem = .init(image: .init(systemName: "plus"), style: .done, target: self, action: #selector(didTapAdd))
    }
    
    //add todo
    func addToDo(){
        let vc = TodoViewController.instantiate(storyboard: .init(name: "Main", bundle: .main))
        vc.todoDelegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //add button click event
    @objc func didTapAdd(){
        addToDo()
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
        self.todos.append(todo)
        
        self.todoTable.reloadData()
        DB.shared.add(TodoItem: todo)
    }
    
    func updateTodo(with newTodo: TodoVM) {
        let id = newTodo.todoID
        
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
    
    //delete item from table view
    func deleteTodoItem(_ todoitem:TodoVM,atRow row:Int) {
        todos.remove(at: row)
        todoTable.deleteRows(at: [.init(row: row, section: 0)], with: .left)
        DB.shared.deleteTodo(withId:todoitem.todoID)
    }
}
