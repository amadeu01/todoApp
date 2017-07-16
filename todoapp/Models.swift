//
//  Models.swift
//  todoapp
//
//  Created by Amadeu Cavalcante Filho on 7/15/17.
//  Copyright © 2017 Amadeu Cavalcante Filho. All rights reserved.
//

import Foundation
import RealmSwift

protocol ListPresentable {
    associatedtype Item: Object, CellPresentable
    var items: List<Item> { get }
}

protocol CellPresentable {
    var title: String {get set}
    var date: Date? { get set }
    var createdAt: Date? { get set}
    var completed: Bool { get set }
    var priority: Int { get set }
}

final class TodoListList: Object, ListPresentable {
    dynamic var id = 0
    let items = List<TodoList>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

final class TodoList: Object, CellPresentable, ListPresentable {
    dynamic var id = NSUUID().uuidString
    dynamic var title = ""
    dynamic var date: Date?
    dynamic var createdAt: Date?
    dynamic var completed = false
    dynamic var priority = 0
    let items = List<TodoItem>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

final class TodoItem: Object, CellPresentable {
    dynamic var title = ""
    dynamic var note = ""
    dynamic var date: Date?
    dynamic var createdAt: Date?
    dynamic var completed = false
    dynamic var priority = 0
    
    convenience init(_ title: String) {
        self.init()
        self.title = title
    }
}
