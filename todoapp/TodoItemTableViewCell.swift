//
//  TodoItemTableViewCell.swift
//  todoapp
//
//  Created by Amadeu Cavalcante Filho on 7/15/17.
//  Copyright © 2017 Amadeu Cavalcante Filho. All rights reserved.
//

import UIKit

class TodoItemTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var todoItemTitleTextField: UITextField!
    @IBOutlet weak var plusLabel: UILabel!
    @IBOutlet var completeCheckBox: DLRadioButton!
    
    public var todoItem: TodoItem! {
        didSet {
            todoItemTitleTextField.text = self.priorityToText(todoItem.priority) + todoItem.title
            completeCheckBox.isMultipleSelectionEnabled = true
        }
    }
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        plusLabel.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    private func priorityToText(_ from: Int) -> String {
        var response = ""
        for _ in 0 ... from {
            response += "!"
        }
        response += " "
        return response
    }
    
}
