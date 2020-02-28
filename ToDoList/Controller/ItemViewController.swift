//
//  ItemViewController.swift
//  ToDoList
//
//  Created by Manpreet Singh on 2020-02-27.
//  Copyright © 2020 Manpreet Singh. All rights reserved.
//

import UIKit
import CoreData

class ItemViewController: UITableViewController {

    var itemArray = [Item]()
    var context = PersistenceService.context

    var selectedItemCategory = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        showAlert()
    }
}

// MARK:- ShowAlert
extension ItemViewController {

    func showAlert() {
        var textField = UITextField()
        let alert = UIAlertController(title: Constants.Alert.alertTitle , message: "", preferredStyle: .alert)
        let action = UIAlertAction(title:  Constants.Alert.actionTitle, style: .default) { (action) in
            let item = Item(context: self.context)
            item.title = textField.text!
            item.done = false
            self.itemArray.append(item)
            self.saveData()
            self.tableView.reloadData()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = Constants.Alert.alertPlaceholder
            textField = alertTextField
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK:- TableView Data Source
extension ItemViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.itemCellIdentifier, for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row].title
        return cell
    }
}

// MARK:- TableView Delegate
extension ItemViewController {

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = itemArray[indexPath.row]
    }
}

// MARK:- CRUD operation
extension ItemViewController {

    func saveData() {
        PersistenceService.saveContext()
    }

    func loadData() {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        do {
          itemArray = try context.fetch(request)
        } catch {
            print("Error occured while reteriving data \(error)")
        }

    }
}
