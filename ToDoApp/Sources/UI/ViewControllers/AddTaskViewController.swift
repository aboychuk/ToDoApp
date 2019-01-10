//
//  AddTaskViewController.swift
//  ToDoApp
//
//  Created by Andrew Boychuk on 1/9/19.
//  Copyright © 2019 Andrew Boychuk. All rights reserved.
//

import UIKit

class AddTaskViewController: UIViewController {
    
    // MARK: - Properties
    
    let toolBar = UIToolbar()
    var activeTextView: UITextView?
    var activeTextField: UITextField?
    lazy var touchView: UIView = {
        let _touchView = UIView()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        _touchView.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0)
        _touchView.addGestureRecognizer(tapGesture)
        _touchView.isUserInteractionEnabled = true
        _ = self.view.map {
            _touchView.frame = CGRect(x: 0,
                                      y: 0,
                                      width: $0.frame.width,
                                      height: $0.frame.height)
        }
        
        return _touchView
    }()
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var navigationBar: UINavigationBar?
    @IBOutlet weak var taskNameTextField: UITextField?
    @IBOutlet weak var taskDetailsTextView: UITextView?
    @IBOutlet weak var taskCompletionDatePicker: UIDatePicker?
    @IBOutlet weak var scrollView: UIScrollView?
    
    // MARK: - View lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.subscribe()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.unsubscribe()
    }
    
    // MARK: - IBAction
    
    @IBAction func addTaskDidTouch(_ sender: Any) {
        self.validate()
    }
    
    @objc func onCancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    @objc func keyboardWasShown(notification: NSNotification) {
        self.keyboardNotification = notification
        self.view.addSubview(self.touchView)
        // TODO: Fix force unwrap
        let info: NSDictionary = notification.userInfo! as NSDictionary
        let keybordSize = (info[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0.0,
                                         left: 0.0,
                                         bottom: (keybordSize!.height + self.toolBar.frame.size.height + 10),
                                         right: 0.0)
        self.scrollView?.contentInset = contentInsets
        
        var aRect = UIScreen.main.bounds
        aRect.size.height -= keybordSize!.height
        if self.activeTextField != nil {
            if (!aRect.contains(activeTextField!.frame.origin)) {
                self.scrollView?.scrollRectToVisible(activeTextField!.frame, animated: true)
            }
            else if self.activeTextView != nil {
                let textViewPoint = CGPoint(x: self.activeTextView!.frame.origin.x,
                                            y: self.activeTextView!.frame.size.height + self.activeTextView!.frame.size.height)
                if (aRect.contains(textViewPoint)) {
                    self.scrollView?.scrollRectToVisible(self.activeTextView!.frame, animated: true)
                }
            }
        }
    }
    
    @objc func keyboardWasHidden(notification: NSNotification) {
        self.touchView.removeFromSuperview()
        let contentInsets = UIEdgeInsets.zero
        self.scrollView?.contentInset = contentInsets
        self.scrollView?.scrollIndicatorInsets = contentInsets
        self.view.endEditing(true)
    }
    
    // MARK: - Private methods
    
    private func setupView() {
        self.prepareNavigationBar()
        self.prepareToolbarDone()
        self.prepareTextView()
        self.prepareTextField()
    }
    
    private func prepareNavigationBar() {
        let navigationItem = UINavigationItem(title: Strings.AddItem.value)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                            target: self,
                                                            action: #selector(onCancel))
        self.navigationBar?.items = [navigationItem]
    }
    
    private func prepareTextView() {
        let viewLayer = self.taskDetailsTextView?.layer
        viewLayer?.borderColor = UIColor.lightGray.cgColor
        viewLayer?.borderWidth = CGFloat(1)
        viewLayer?.cornerRadius = CGFloat(6)
        self.taskDetailsTextView?.delegate = self
        self.taskDetailsTextView?.inputAccessoryView = self.toolBar

    }
    
    private func prepareTextField() {
        self.taskNameTextField?.delegate = self
        self.taskNameTextField?.inputAccessoryView = self.toolBar

    }
    
    private func prepareToolbarDone() {
        let toolBarDone = self.toolBar
        toolBarDone.isTranslucent = false
        toolBarDone.sizeToFit()
        toolBarDone.barTintColor = UIColor.red
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace,
                                        target: self,
                                        action: nil)
        let barButtonDone = UIBarButtonItem(title: "Done",
                                            style: .plain,
                                            target: self,
                                            action: #selector(dismissKeyboard))
        barButtonDone.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17),
                                              NSAttributedString.Key.foregroundColor: UIColor.white],
                                             for: .normal)
        self.toolbarItems = [flexSpace, barButtonDone, flexSpace]
    }
    
    private func subscribe() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWasShown(notification:)),
                                               name: UIWindow.keyboardDidShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWasHidden(notification:)),
                                               name: UIWindow.keyboardWillHideNotification,
                                               object: nil)
    }
    
    private func unsubscribe() {
        NotificationCenter.default.removeObserver(self, name: UIWindow.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIWindow.keyboardWillHideNotification, object: nil)
    }
    
    private func validate() {
        guard let taskName = self.taskNameTextField?.text,
            let taskDetails = self.taskDetailsTextView?.text,
        let completionDate = taskCompletionDatePicker?.date else { return }
        if taskName.isEmpty {
            self.reportError(title: "Invalid task name", error: "Task name is required")
            
            return
        }
        if taskDetails.isEmpty {
            self.reportError(title: "Invalid task details", error: "Task details are required")
            
            return
        }
        if completionDate < Date() {
            self.reportError(title: "Invalid date", error: "Date must be in future")
            
            return
        }
        let toDoItem = ToDoItemModel(name: taskName, details: taskDetails, completionDate: completionDate)
        NotificationCenter.default.post(name: NSNotification.Name.init("com.todolistapp.additem"), object: toDoItem)
        self.dismiss(animated: true, completion: nil)
    }
    
    private func reportError(title: String, error: String) {
        let alertController = UIAlertController(title: title, message: error, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (alert) in
            alertController.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

extension AddTaskViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.activeTextField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.activeTextField = nil
    }
}

extension AddTaskViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.activeTextView = textView
//        guard let notification = self.keyboardNotification else { return }
//        let info: NSDictionary = notification.userInfo! as NSDictionary
//        let keybordSize = (info[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
//        let contentInsets = UIEdgeInsets(top: 0.0,
//                                         left: 0.0,
//                                         bottom: (keybordSize!.height + self.toolBar.frame.size.height + 10),
//                                         right: 0.0)
//        self.scrollView?.contentInset = contentInsets
//
//        var aRect = UIScreen.main.bounds
//        aRect.size.height -= keybordSize!.height
//        let textViewPoint = CGPoint(x: textView.frame.origin.x,
//                                    y: textView.frame.size.height + self.activeTextView!.frame.size.height)
//        if (aRect.contains(textViewPoint)) {
//            self.scrollView?.scrollRectToVisible(textView.frame, animated: true)
//        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.activeTextView = nil
    }
}
