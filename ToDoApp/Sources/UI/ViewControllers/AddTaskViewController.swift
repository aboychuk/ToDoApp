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
        self.setupView()
    }
    
    // MARK: - IBAction
    
    @IBAction func addTaskDidTouch(_ sender: Any) {
        
    }
    
    @objc func onCancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func onDone() {
        self.view.endEditing(true)
    }
    
    // MARK: - Private methods
    
    private func setupView() {
        self.prepareNavigationBar()
        self.prepareTextView()
        self.prepareToolbarDone()
    }
    
    private func prepareNavigationBar() {
        let navigationItem = UINavigationItem(title: Strings.AddItem.value)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(onCancel))
        self.navigationBar?.items = [navigationItem]
    }
    
    private func prepareTextView() {
        let viewLayer = self.taskDetailsTextView?.layer
        viewLayer?.borderColor = UIColor.lightGray.cgColor
        viewLayer?.borderWidth = CGFloat(1)
        viewLayer?.cornerRadius = CGFloat(6)
    }
    
    private func prepareToolbarDone() {
        let toolBarDone = UIToolbar()
        toolBarDone.isTranslucent = false
        toolBarDone.sizeToFit()
        toolBarDone.barTintColor = UIColor.red
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
        let barButtonDone = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(onDone))
        barButtonDone.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17),
                                              NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
        self.toolbarItems = [flexSpace, barButtonDone, flexSpace]
        self.taskNameTextField?.inputAccessoryView = toolBarDone
        self.taskDetailsTextView?.inputAccessoryView = toolBarDone
    }
}
