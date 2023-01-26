//Copyright © 2023 Mohammed

import Foundation
import UIKit
import FirebaseAuth

class HomeViewController:MyViewController {
    
    @IBOutlet weak var todoTable    :UITableView!
    @IBOutlet weak var addBtn       :MyButton!
    let refreshControl = UIRefreshControl()
    
    var viewModel:HomeViewModel?
    
    //todos
    var todos : [TodoVM] = DB.shared.fetchTodos()
    
    //fires when the view controller is loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = HomeViewModel(controller: self)
        
        personalizeNavBar()
        setUpRightButton()
        disableBackGesture()
        
        //setup todo tableview
        self.todoTable.register(TodoTableViewCell.nib, forCellReuseIdentifier:TodoTableViewCell.identifier)
        self.todoTable.delegate = self
        self.todoTable.dataSource = self
        
        //remove text from add button
        self.addBtn.setTitle("", for: .normal)
        
        //adds refresh control to the table view
        todoTable.addSubview(refreshControl)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if todos.isEmpty {
            fetchAllTodos()
        }
        
    }
    
    func fetchAllTodos(){
        UI.ShowLoadingView()
        viewModel?.fetchTodos()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.hideNavBar = false
    }
    
    override func handleEvents() {
        super.handleEvents()
        self.addBtn.handleTap = addToDo
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
    }
    
    @objc func refresh(_ sender: AnyObject) {
       // Code to refresh table view
        self.fetchAllTodos()
    }
    
    //Changes navigation bar's title, tint color and back button color
    func personalizeNavBar() {
        self.navigationController?.navigationBar.tintColor = .label
        self.navigationItem.title = Auth.auth().currentUser?.displayName ?? "ToDooey"
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
    
    
    func signOut(_ action:UIAlertAction){
        UI.ShowLoadingView()
        viewModel?.signOut()
    }
    
    //add todo
    func addToDo(){
        let vc = TodoViewController.instantiate(storyboard: .init(name: "Main", bundle: .main))
        vc.todoDelegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //sign out button click event
    @objc func didTapSignout(){
        let alertVc = UIAlertController.init(title: "Sign out", message: "Are you sure you want to sign out ?", preferredStyle: .alert)
        alertVc.addAction(.init(title: "Yes", style: .default, handler: signOut))
        alertVc.addAction(.init(title: "Cancel", style: .cancel))
        
        self.present(alertVc, animated: true)
    }
    
    override func displayError(error: String) {
        super.displayError(error: error)
        if refreshControl.isRefreshing {
            self.refreshControl.endRefreshing()
        }
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
        cell.onToggle = {[weak self] in self?.toggleTodoAtRow(indexPath.row)}
        
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
    
    //delete item from table view
    func deleteTodoItem(_ todoitem:TodoVM,atRow row:Int) {
        UI.ShowLoadingView()
        viewModel?.deleteTodo(todoitem, atRow: row)
    }
    
    func addTodo(_ todo: TodoVM) {
        self.todos.append(todo)
        self.todoTable.reloadData()
    }
    
    func updateTodo(with newTodo: TodoVM) {
        self.displayUpdatedTodo(newTodo: newTodo)
    }
    
    func toggleTodoAtRow(_ row:Int){
        let todo = todos[row]
        UI.ShowLoadingView()
        viewModel?.toggleTodo(todo: todo)
    }
}

extension HomeViewController:HomeDisplayLogic {
    
    func displayTodos(_ todos: [TodoVM]) {
        UI.HideLoadingView()
        refreshControl.endRefreshing()
        self.todos = todos
        self.todoTable.reloadData()
    }
    
    func logUserOut() {
        UI.HideLoadingView()
        let vc = LoginViewController.instantiate(storyboard: .init(name: "Main", bundle: .main))
        let scene = UIApplication.shared.connectedScenes.first
        let window = (scene?.delegate as? SceneDelegate)?.window
        window?.rootViewController = UINavigationController(rootViewController: vc)
        window?.makeKeyAndVisible()
    }
    
    func displayDeletedTodoAtRow(_ row: Int) {
        UI.HideLoadingView()
        self.todos.remove(at: row)
        self.todoTable.deleteRows(at: [.init(row: row, section: 0)], with: .left)
    }
    
    func displayUpdatedTodo(newTodo:TodoVM) {
        UI.HideLoadingView()
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
}
