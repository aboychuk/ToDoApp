//
//  Strings.swift
//  ToDoApp
//
//  Created by Andrew Boychuk on 1/9/19.
//  Copyright © 2019 Andrew Boychuk. All rights reserved.
//

import Foundation

public enum Strings: String {
    case TaskDetailsSegue
    case AddTaskSegue
    case ToDoItem
    case Complete
    case Incomplete
    case Delete
    case ToDoList = "To Do List"
    case AddItem = "Add Item"
    
    var value: String {
        return self.rawValue
    }
}
