//
//  ToDoItemModel.swift
//  ToDoApp
//
//  Created by Andrew Boychuk on 1/9/19.
//  Copyright © 2019 Andrew Boychuk. All rights reserved.
//

import Foundation

struct ToDoItemModel {
    
    // MARK: - Properties
    
    var name: String
    var details: String
    var completionDate: Date
    var startDate: Date
    var isComplete: Bool
    
    // MARK - Init
    
    init(name: String, details: String, completionDate: Date) {
        self.name = name
        self.details = details
        self.completionDate = completionDate
        self.startDate = Date()
        self.isComplete = false
    }
 }
 
