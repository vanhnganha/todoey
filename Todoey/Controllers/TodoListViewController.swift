//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework
class TodoListViewController: SwipeTableViewController{

    @IBOutlet weak var searchBar: UISearchBar!
    var todoItems: Results<Item>?
    let realm = try! Realm()
    var selectCategory: Category? {
    didSet{
        loadItems()
        }
    }
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
       
    }
    override func viewWillAppear(_ animated: Bool) {
        if let hexColor = selectCategory?.color {
            title = selectCategory!.name
            guard let navbar = navigationController?.navigationBar else
            {fatalError("navbar doesn't exist")}
            if let navbarColor = UIColor(hexString: hexColor) {
                navbar.barTintColor = navbarColor
                //navbar.backgroundColor = navbarColor
                navbar.tintColor = ContrastColorOf(navbarColor, returnFlat: true)
                navbar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: ContrastColorOf(navbarColor, returnFlat: true)]
                searchBar.barTintColor = UIColor(hexString: hexColor)!
            
            }
            
            
            }
            
        }
        
    
   
  // MARK: Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let item = todoItems?[indexPath.row]{
            cell.textLabel?.text = item.title
           
            if let color = UIColor(hexString: selectCategory!.color)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat (todoItems!.count)){
             cell.backgroundColor = color
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
                 cell.tintColor = ContrastColorOf(color, returnFlat: true)
            }
//
            cell.accessoryType = item.done ? .checkmark : .none
           
        }else {
            cell.textLabel?.text = "No item added"
        }
       

        return cell

    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    // MARK: Tableview Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if let item = todoItems?[indexPath.row] {
            do{
                try realm.write {
                    item.done = !item.done
                }
            }catch{
            print("error saving done status \(error)")
            }
        }
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

    //MARK: Adds new items
    
   
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        var textField = UITextField()
        let action = UIAlertAction(title: "New Item", style: .default) { (action) in
            // what will happens when the users click Add Item Button on UIAlert
            if let currentCategory = self.selectCategory{
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.done = false
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                }catch{
                    print("Error saving item \(error)")
                }
            }
            self.tableView.reloadData()
           
            print("Success!")
        }

        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        present( alert, animated: true, completion: nil)
    }
    //MARK: Model Manutupulation Methods
    
    func saveItems(item: Item){
       // save current state of context
      try? realm.write {
            realm.add(item)
        
        }
        tableView.reloadData()
    }
    
    func loadItems(){
        todoItems = selectCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
        }
    //MARK: delete swipe cell
    override func deleteCell(at indexPath: IndexPath) {
        do {
            try realm.write {
                realm.delete((todoItems?[indexPath.row])!)
            }
        }catch{
            print("error deleting items \(error)")
        }
    }
    
}
    //MARK: SearchBar Delegate
    extension TodoListViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
        }
       //  let request: NSFetchRequest<Item> = Item.fetchRequest()
        //
        //        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        //
        //
        //        let sortDecriptor = NSSortDescriptor(key: "title", ascending: true)
        //
        //        request.sortDescriptors = [sortDecriptor]
        //
        //        loadItems(with: request, predicate: predicate)

        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            if searchBar.text?.count == 0 {
                loadItems()

                DispatchQueue.main.async {
                    // turn back first status of searchBar (NO keyboard appear and No cursor)
                    searchBar.resignFirstResponder()
                }
            }
        }
    }
   

    
    

