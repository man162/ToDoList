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
    let context = PersistenceService.context

    var selectedItemCategory: Category? {
        didSet {
            loadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
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
            item.parentCategory = self.selectedItemCategory
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
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        cell.accessoryType = item.done ? .checkmark : .none
        return cell
    }
}

// MARK:- TableView Delegate
extension ItemViewController {

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = itemArray[indexPath.row]
        item.done = !item.done
        saveData()
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK:- CRUD operation
extension ItemViewController {

    func saveData() {
        PersistenceService.saveContext()
    }

    func loadData(request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {

        let categoryName = selectedItemCategory!.name!
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", categoryName)
        if let searchPredicate = predicate {
            let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [searchPredicate, categoryPredicate])
            request.predicate = compoundPredicate
        } else {
            request.predicate = categoryPredicate
        }
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error occured while reteriving data \(error)")
        }
        tableView.reloadData()
    }
}

// MARK:- SearchBar Delegate
extension ItemViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let text  = searchBar.text
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", text!)
        loadData(predicate: predicate)
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }

}
