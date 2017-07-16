//
//  TodoListTableViewController.swift
//  todoapp
//
//  Created by Amadeu Cavalcante Filho on 7/15/17.
//  Copyright © 2017 Amadeu Cavalcante Filho. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListTableViewController: UITableViewController, ViewControllerProtocol {
    final let reusableCellIdentifier = "todoItemCell"
    var todoList = try! Realm().objects(TodoList.self).first!
    var todoItemsList = try! Realm().objects(TodoItem.self)
    let searchBar = UISearchBar()
    
    
    func uiWrite(block: () -> Void) {
        uiWriteNoUpdateList(block: block)
        didUpdateList(reload: false)
    }
    
    func uiWriteNoUpdateList(block: () -> Void) {
        todoList.items.realm?.beginWrite()
        block()
        commitUIWrite()
    }
    
    func finishUIWrite() {
        commitUIWrite()
        didUpdateList(reload: false)
    }
    
    func didUpdateList(reload: Bool) {
        if reload { tableView.reloadData() }
    }
    
    private func commitUIWrite() {
        _ = try? todoList.items.realm?.commitWrite()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        searchBar.delegate = self as UISearchBarDelegate
        searchBar.sizeToFit()
        self.navigationItem.titleView = searchBar
        tableView.tableFooterView = UIView(frame: .zero)
        self.navigationController!.navigationBar.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 100.0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.todoItemsList.count + 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.reusableCellIdentifier, for: indexPath) as! TodoItemTableViewCell
        if self.todoItemsList.count <= indexPath.row {
            cell.todoItemTitleTextField.text = ""
            cell.todoItemTitleTextField.delegate = self
            cell.completeCheckBox.isHidden = true
            cell.plusLabel.isHidden = false
            cell.accessoryType = .none
            return cell

        } else {
            cell.completeCheckBox.addTarget(self, action: #selector(TodoListTableViewController.logSelectedButton), for: UIControlEvents.touchUpInside)
            cell.todoItem = todoItemsList[indexPath.row]
            cell.todoItemTitleTextField.delegate = self
            cell.completeCheckBox.isHidden = false
            cell.plusLabel.isHidden = true
            cell.accessoryType = .detailButton
            
            return cell
        }
        
    }
    
    @objc @IBAction private func logSelectedButton(radioButton : DLRadioButton) {
        if let cell = radioButton.superview?.superview as? TodoItemTableViewCell {
            var indexPath = tableView.indexPath(for: cell)
            uiWrite {
                todoItemsList[(indexPath?.row)!].completed = radioButton.isSelected
            }
        }
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if indexPath.row >= todoList.items.count {
            return
        }
        if editingStyle == .delete {
            let item = self.todoItemsList[indexPath.row]
            uiWrite {
                todoItemsList.realm?.delete(item)
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
            didUpdateList(reload: true)
        } else if editingStyle == .insert {
            
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.row >= todoList.items.count {
            return false
        }
        return true
    }
        
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        performSegue(withIdentifier: "detailTodoItem", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailTodoItem" {
            let navVC = segue.destination as? UINavigationController
            let detailTodoItem = navVC?.viewControllers.first as! TodoItemDetailViewController
            detailTodoItem.todoItem = todoItemsList[(sender as! IndexPath).row]
        }
    }

}

extension TodoListTableViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text != nil {
            if textField.text != "" {
                let item = TodoItem()
                item.title = textField.text!
                item.createdAt = Date()
                item.priority = 0
                uiWrite {
                    todoList.items.insert(item, at: 0)
                    didUpdateList(reload: true)
                }
            }
        }
        return true
    }
}

extension TodoListTableViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != "" {
            let predicate = NSPredicate(format: "title CONTAINS %@", searchText)
            self.todoItemsList = try! Realm().objects(TodoItem.self).filter(predicate)
        } else {
            self.todoItemsList = try! Realm().objects(TodoItem.self)
        }
        tableView.reloadData()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
    }
}
