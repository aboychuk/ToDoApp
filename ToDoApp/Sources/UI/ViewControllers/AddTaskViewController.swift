//
//  AddTaskViewController.swift
//  ToDoApp
//
//  Created by Andrew Boychuk on 1/9/19.
//  Copyright © 2019 Andrew Boychuk. All rights reserved.
//

import UIKit

class AddTaskViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var navigationBar: UINavigationBar?
    @IBOutlet weak var taskNameTextField: UITextField?
    @IBOutlet weak var taskDetailsTextView: UITextView?
    @IBOutlet weak var taskCompletionDatePicker: UIDatePicker?
    @IBOutlet weak var scrollView: UIScrollView?
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - IBAction
    
    @IBAction func addTaskDidTouch(_ sender: Any) {
        
    }
    
    // MARK: - Private methods
    
    private func prepareView() {
        self.prepareNavigationBar()
        self.prepareTextView()
    }
    
    private func prepareNavigationBar() {
        let navigationItem = UINavigationItem(title: Strings.AddItem.value)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(onCancel))
        self.navigationBar?.items = [navigationItem]
    }
    
    private func prepareTextView() {
        let textView = UITextView()
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.borderWidth = CGFloat(1)
        textView.layer.cornerRadius = CGFloat(6)
        self.taskDetailsTextView? = textView
    }
    
    
    @objc func onCancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
}
