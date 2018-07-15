//
//  SwipeableTableViewController.swift
//  Todoey
//
//  Created by Joe Dai on 15/07/18.
//  Copyright © 2018 Joe Dai. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeableTableViewController: UITableViewController, SwipeTableViewCellDelegate {
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! SwipeTableViewCell
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            self.deleteModel(at: indexPath)
            self.tableView.reloadData()
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete-icon")
        
        return [deleteAction]
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func deleteModel(at indexPath: IndexPath){
        
    }
}
