//
//  ViewController.swift
//  Todoey
//
//  Created by Joe Dai on 4/8/18.
//  Copyright © 2018 Joe Dai. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

class TodoListViewController: SwipeableTableViewController {
    
    let realm = try! Realm()
    var parentCategory: Category?{
        didSet{
            loadItems();
        }
    }
    var items : Results<Item>?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80
    }
    
    //MARK: - Table view source
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = items?[indexPath.row].title ?? "No item created"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 1
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let item = items![indexPath.row]
        do{
            try realm.write {
                item.done = !item.done
            }
        }catch{
            print("error while updating item \(error)")
        }
        
        
        let cell = tableView.cellForRow(at: indexPath)
        
        cell?.accessoryType = cell?.accessoryType == .checkmark ? .none : .checkmark
        
        tableView.deselectRow(at: indexPath, animated: true)
        
//        saveItems()
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add new todoey item", message: "", preferredStyle: .alert)
        
        var textField = UITextField()
        
        let action = UIAlertAction(title: "Add new item", style: .default, handler: { (action) in
            
            let item = Item()
            item.title = textField.text!
            
            do{
                try self.realm.write {
                    self.parentCategory!.items.append(item)
                }
            }catch{
                print("Error while saving item \(error)")
            }
            
            self.tableView.reloadData()
        })
            
        alert.addAction(action)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Item Name"
            textField = alertTextField
        }
        
        present(alert, animated: true, completion: nil)
    }

    
    func loadItems(){
        items = parentCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    }
    
    override func deleteModel(at indexPath: IndexPath) {
        do{
            try realm.write {
                realm.delete(items![indexPath.row])
            }
        }catch{
            print("error writing item \(error)")
        }
    }
    
}

extension TodoListViewController: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        items = realm.objects(Item.self).filter("title CONTAINS[cd] %@", searchBar.text!)
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if(searchText.isEmpty){
            loadItems()
        }
    }
    
}
