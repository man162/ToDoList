//
//  CategoryViewController.swift
//  ToDoList
//
//  Created by Manpreet Singh on 2020-02-27.
//  Copyright © 2020 Manpreet Singh. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    var categoryArray = [Category]()
    let context = PersistenceService.context

    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }

    @IBAction func addButtonPressed(_ sender: Any) {
        showAlert()
    }

}

// MARK:- UIAlertViewController
extension CategoryViewController {

    func showAlert() {

        var textField = UITextField()
        let alert = UIAlertController(title: Constants.Alert.alertTitle , message: "", preferredStyle: .alert)
        let action = UIAlertAction(title:  Constants.Alert.actionTitle, style: .default) { (action) in
            let category = Category(context: self.context)
            category.name = textField.text!
            self.categoryArray.append(category)
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
extension CategoryViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.categoryCellIdentifier, for: indexPath)
        cell.textLabel?.text = categoryArray[indexPath.row].name
        return cell
    }
}

// MARK:- TableView Delegate
extension CategoryViewController {

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: Constants.categoryToItemSegue, sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? ItemViewController {
            if let indexPath = tableView.indexPathForSelectedRow {
                destinationVC.selectedItemCategory = categoryArray[indexPath.row]
            }
        }
    }
}

// MARK:- CRUD operation
extension CategoryViewController {

    func saveData() {
        PersistenceService.saveContext()
    }

    func loadData() {
        let request: NSFetchRequest<Category> =  Category.fetchRequest()
        do {
         categoryArray = try context.fetch(request)
        } catch {
            print("Error occured while reteriving data \(error)")
        }
    }
}

