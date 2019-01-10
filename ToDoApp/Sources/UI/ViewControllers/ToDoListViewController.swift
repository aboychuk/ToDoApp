//
//  ToDoListViewController.swift
//  ToDoApp
//
//  Created by Andrew Boychuk on 1/9/19.
//  Copyright © 2019 Andrew Boychuk. All rights reserved.
//

import UIKit

class ToDoListViewController: UIViewController {
    
    // MARK: - Properties
    
    var model = [ToDoItemModel]()
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView?
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareViewController()
        self.tableView.map { self.prepare(tableView: $0) }
        // TODO: Delete test
        self.prepareTest()
    }
    
    // MARK: - Private methods
    
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
    
    // MARK: - Overrided methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Strings.TaskDetailsSegue.value {
            guard let destinationViewController = segue.destination as? ToDoDetailsViewController else { return }
            guard let selectedItem = sender as? ToDoItemModel else { return }
            destinationViewController.model = selectedItem
        }
    }
}

extension ToDoListViewController: UITableViewDelegate {
    
    // MARK: Table view delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = self.model[indexPath.row]
         self.performSegue(withIdentifier: Strings.TaskDetailsSegue.value, sender: selectedItem)
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

