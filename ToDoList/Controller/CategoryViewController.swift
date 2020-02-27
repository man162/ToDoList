//
//  CategoryViewController.swift
//  ToDoList
//
//  Created by Manpreet Singh on 2020-02-27.
//  Copyright © 2020 Manpreet Singh. All rights reserved.
//

import UIKit

class CategoryViewController: UITableViewController {

    var categoryArray = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func addButtonPressed(_ sender: Any) {
        showAlert()
    }

}

// MARK:- TableView Data Source
extension CategoryViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.categoryCellIdentifier, for: indexPath)
        cell.textLabel?.text = categoryArray[indexPath.row]
        return cell
    }
}

// MARK:- UIAlertViewController
extension CategoryViewController {

    func showAlert() {

        var textField = UITextField()
        let alert = UIAlertController(title: Constants.Alert.alertTitle , message: "", preferredStyle: .alert)
        let action = UIAlertAction(title:  Constants.Alert.actionTitle, style: .default) { (action) in
            self.categoryArray.append(textField.text!)
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
