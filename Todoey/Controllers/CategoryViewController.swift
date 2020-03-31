//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Macbook Pro on 3/17/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework
class CategoryViewController: SwipeTableViewController {

    

    var realm = try! Realm()
    var categories: Results<Category>?
    override func viewDidLoad() {
        super.viewDidLoad()
   
        loadCategories()
        tableView.separatorStyle = .none
        
    }
    override func viewWillAppear(_ animated: Bool) {
         navigationController?.navigationBar.barTintColor = UIColor(hexString: "1D9BF6")
    }
    //MARK: add new category
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
        var textField = UITextField()
        let action = UIAlertAction(title: "New Category", style: .default) { (action) in
            let newCategory = Category()
            newCategory.name = textField.text!
            newCategory.color = UIColor.randomFlat().hexValue()
            self.save(category: newCategory)
            print("Success!")
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new category"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    //MARK: tableView DataSource Methods

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No categories added yet"
        cell.backgroundColor = UIColor.init(hexString: categories?[indexPath.row].color ?? "64D2FF")
        return cell
    }
    
    //MARK: TableView Delegate Methods
        
        override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            performSegue(withIdentifier: "goToItems", sender: self)
            tableView.deselectRow(at: indexPath, animated: true)
        }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectCategory = categories?[indexPath.row]
        }
   
        
    }
    

    //MARK: Data Manipulation Methods
    func save(category: Category){
    do{
        try realm.write {
            realm.add(category)
        }
    }catch{
        print("Error saving category to data \(error)")
    }
    tableView.reloadData()
    }
func loadCategories(){
    categories = realm.objects(Category.self)
    tableView.reloadData()


    }
    //MARK: delete swipe
    override func deleteCell(at indexPath: IndexPath) {
        // when swipe and click the delete button
        if (self.categories?[indexPath.row]) != nil {
            do {
                try self.realm.write {
                    self.realm.delete((self.categories?[indexPath.row])!)
                }
                
            }catch{
                print("error deleting \(error)")
            }
        }
    }
}

