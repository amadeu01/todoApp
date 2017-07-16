//
//  TodoItemDetailViewController.swift
//  todoapp
//
//  Created by Amadeu Cavalcante Filho on 7/15/17.
//  Copyright © 2017 Amadeu Cavalcante Filho. All rights reserved.
//

import UIKit

class TodoItemDetailViewController: UIViewController {

    
    @IBOutlet weak var noteTextField: UITextField!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var prioritySegmentedControl: UISegmentedControl!
    var todoItem: TodoItem? {
        didSet {
            if noteTextField != nil {
                noteTextField.text = todoItem?.note
            }
            if titleTextField != nil {
                titleTextField.text = todoItem?.title
            }
            if prioritySegmentedControl != nil {
                prioritySegmentedControl.selectedSegmentIndex = (todoItem?.priority)!
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if noteTextField != nil {
            noteTextField.text = todoItem?.note
        }
        if titleTextField != nil {
            titleTextField.text = todoItem?.title
        }
        
        if prioritySegmentedControl != nil {
            prioritySegmentedControl.selectedSegmentIndex = (todoItem?.priority)!
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    @IBAction func okButtonTouched(_ sender: UIBarButtonItem) {
        dismiss(animated: true) {
            self.uiWrite {
                self.todoItem?.note = self.noteTextField.text!
                self.todoItem?.title = self.titleTextField.text!
                self.todoItem?.priority = self.prioritySegmentedControl.selectedSegmentIndex
            }
        }
    }
    
    init(_ item: TodoItem) {
        self.todoItem = item
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.todoItem = TodoItem()
        super.init(coder: aDecoder)
    }
    
    func uiWrite(block: () -> Void) {
        uiWriteNoUpdateList(block: block)
    }
    
    func uiWriteNoUpdateList(block: () -> Void) {
        todoItem?.realm?.beginWrite()
        block()
        commitUIWrite()
    }
    
    func finishUIWrite() {
        commitUIWrite()
    }
    private func commitUIWrite() {
        _ = try? todoItem?.realm?.commitWrite()
    }
}
