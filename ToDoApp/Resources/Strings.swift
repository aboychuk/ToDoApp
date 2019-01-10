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
    case ToDoItem
    case Complete
    case Incomplete
    case ToDoList = "To Do List"
    
    var value: String {
        return self.rawValue
    }
}
