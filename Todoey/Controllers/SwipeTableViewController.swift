//
//  SwipeTableViewController.swift
//  Todoey
//
//  Created by Macbook Pro on 3/28/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import UIKit
import SwipeCellKit
class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {
  
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80.0
    }
    
    //MARK: TableView Datasource
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        // swipe :
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else {
            return nil
        }
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { (action, indexPath) in
            self.deleteCell(at: indexPath)
           
        }
        deleteAction.image = UIImage(named: "delete")
        
        return [deleteAction]
       }
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        options.transitionStyle = .border
        return options
    }
    func deleteCell(at indexPath: IndexPath){
    
    }
   

}

