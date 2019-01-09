//
//  ToDoDetailsViewController.swift
//  ToDoApp
//
//  Created by Andrew Boychuk on 1/9/19.
//  Copyright © 2019 Andrew Boychuk. All rights reserved.
//

import UIKit

class ToDoDetailsViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var taskTitleLabel: UILabel!
    @IBOutlet weak var taskDetailsTextView: UITextView!
    @IBOutlet weak var taskCompletionButton: UIButton!
    @IBOutlet weak var taskCompletionDate: UILabel!
    
    // MARK: - View lyfecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - IBActions
    
    @IBAction func taskDidComplete(_ sender: Any) {
    }
}

