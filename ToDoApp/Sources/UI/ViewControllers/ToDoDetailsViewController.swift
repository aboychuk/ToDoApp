//
//  ToDoDetailsViewController.swift
//  ToDoApp
//
//  Created by Andrew Boychuk on 1/9/19.
//  Copyright © 2019 Andrew Boychuk. All rights reserved.
//

import UIKit

class ToDoDetailsViewController: UIViewController {
    
    // MARK: - Properties
    
    var model: ToDoItemModel?
    var index: Int?
    weak var delegate: ToDoListDelegate?
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var taskTitleLabel: UILabel?
    @IBOutlet weak var taskDetailsTextView: UITextView?
    @IBOutlet weak var taskCompletionButton: UIButton?
    @IBOutlet weak var taskCompletionDate: UILabel?
    
    // MARK: - View lyfecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareView()
    }
    
    // MARK: - IBActions
    
    @IBAction func taskDidComplete(_ sender: Any) {
        guard var model = self.model, let index = self.index else { return }
        model.isComplete = true
        self.delegate?.update(task: model, index: index)
    }
    
    // MARK: - Private methods
    
    private func disableButton() {
        self.taskCompletionButton?.backgroundColor = UIColor.gray
        self.taskCompletionButton?.isEnabled = false
    }
    
    private func format(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy hh:mm"
        
        return formatter.string(from: date)
    }
    
    private func prepareView() {
        guard let model = self.model else { return }
        if model.isComplete {
            self.disableButton()
        }
        let taskDate = self.format(date: model.completionDate)
        self.taskTitleLabel?.text = model.name
        self.taskDetailsTextView?.text = model.details
        self.taskCompletionDate?.text = taskDate
    }
}

