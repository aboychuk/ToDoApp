//
//  ToDoListViewController.swift
//  ToDoApp
//
//  Created by Andrew Boychuk on 1/9/19.
//  Copyright © 2019 Andrew Boychuk. All rights reserved.
//

import UIKit

protocol ToDoListDelegate: class {
    func update(task: ToDoItemModel, index: Int)
}

class ToDoListViewController: UIViewController {
    
    // MARK: - Properties
    
    var model = [ToDoItemModel]()
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView?
    
    // MARK: - Deinit
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.init("com.todolistapp.additem"), object: nil)
    }
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tableView?.setEditing(false, animated: false)
    }
    
    // MARK: - Obj-C
    
    @objc func onAdd() {
        self.performSegue(withIdentifier: Strings.AddTaskSegue.value, sender: nil)
    }
    
    @objc func onEdit() {
        _ = self.tableView.map { $0.setEditing(!$0.isEditing, animated: true) }
        if tableView?.isEditing ?? false {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done,
                                                                     target: self,
                                                                     action: #selector(onEdit))
        } else {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit,
                                                                     target: self,
                                                                     action: #selector(onEdit))
        }
    }
    
    @objc func addNewTask(_ notification: NSNotification) {
        if let task = notification.object as? ToDoItemModel {
            self.model.append(task)
        } else {
            return
        }
        self.model.sort(by: { $0.completionDate > $1.completionDate })
        self.tableView?.reloadData()
    }
    
    // MARK: - Private methods
    
    private func prepareView() {
        self.prepareViewController()
        self.prepareNavigationItems()
        self.tableView.map { self.prepare(tableView: $0) }
        // TODO: Delete test
        self.prepareTest()
    }
    
    private func prepareNavigationItems() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                                target: self,
                                                                action: #selector(onAdd))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit,
                                                                 target: self,
                                                                 action: #selector(onEdit))
    }
    
    private func prepareViewController() {
        self.title = Strings.ToDoList.value
    }
    
    private func prepare(tableView: UITableView) {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }
    // TODO: Delete test method
    private func prepareTest() {
        let testItem = ToDoItemModel(name: "Test", details: "TestDetails", completionDate: Date())
        let testItem2 = ToDoItemModel(name: "Test 2", details: "TestDetails 2", completionDate: Date())

        self.model.append(testItem)
        self.model.append(testItem2)
    }
    
    private func prepareObserving() {
        NotificationCenter.default.addObserver(self, selector: #selector(addNewTask(_ :)), name: NSNotification.Name.init("com.todolistapp.additem"), object: nil)
    }
    
    // MARK: - Overrided methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Strings.TaskDetailsSegue.value {
            guard let destinationViewController = segue.destination as? ToDoDetailsViewController,
                  let toDoItemData = sender as? (Int, ToDoItemModel) else { return }
            destinationViewController.index = toDoItemData.0
            destinationViewController.model =  toDoItemData.1
            destinationViewController.delegate = self
        }
    }
}

extension ToDoListViewController: UITableViewDelegate {
    
    // MARK: Table view delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = self.model[indexPath.row]
        let toDoItemData = (indexPath.row, selectedItem)
        self.performSegue(withIdentifier: Strings.TaskDetailsSegue.value, sender: toDoItemData)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive,
                                          title: Strings.Delete.value)
        {
            (action, indexpath) in
            self.model.remove(at: indexPath.row)
            self.tableView?.deleteRows(at: [indexPath], with: .automatic)
        }
        
        return [delete]
    }
    
}

extension ToDoListViewController: UITableViewDataSource {
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.model.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = self.model[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: Strings.ToDoItem.value, for: indexPath)
        cell.textLabel?.text = item.name
        cell.detailTextLabel?.text = item.isComplete ? Strings.Complete.value : Strings.Incomplete.value
        
        return cell
    }
}

extension ToDoListViewController: ToDoListDelegate {
    
    // MARK: - Delegate
    
    func update(task: ToDoItemModel, index: Int) {
        self.model[index] = task
        self.tableView?.reloadData()
    }
}

