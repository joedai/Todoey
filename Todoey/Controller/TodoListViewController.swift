//
//  ViewController.swift
//  Todoey
//
//  Created by Joe Dai on 4/8/18.
//  Copyright © 2018 Joe Dai. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    var parentCategory: Category?{
        didSet{
            loadItems();
        }
    }
    var itemArry = [Item]()
    let filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Item.plist")
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        print(filePath!)
    }
    
    //MARK: - Table view source
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = itemArry[indexPath.row].title
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArry.count
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let item = itemArry[indexPath.row]
        item.done = !item.done
        
        let cell = tableView.cellForRow(at: indexPath)
        
        cell?.accessoryType = cell?.accessoryType == .checkmark ? .none : .checkmark
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        saveItems()
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add new todoey item", message: "", preferredStyle: .alert)
        
        var textField = UITextField()
        
        let action = UIAlertAction(title: "Add new item", style: .default, handler: { (action) in
            
            let item = Item(context: self.context)
            item.title = textField.text!
            item.parentCategory = self.parentCategory
            
            self.itemArry.append(item)

            self.saveItems()
            
            self.tableView.reloadData()
        })
            
        alert.addAction(action)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Item Name"
            textField = alertTextField
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    func saveItems(){
        do{
            try self.context.save()
        }catch{
            print("Error while saving array \(error)")
        }
    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate : NSPredicate? = nil){
        let categoryPredicate = NSPredicate(format: "parentCategory.title MATCHES %@", parentCategory!.title!)
        
        if let additionalPredicate = predicate{
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [additionalPredicate,categoryPredicate])
        }else{
            request.predicate = categoryPredicate
        }
        
        do{
            itemArry = try self.context.fetch(request)
            print(itemArry)
        }catch{
            print("Error while loading array \(error)")
        }
        tableView.reloadData()
    }
    
}

extension TodoListViewController: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor.init(key: "title", ascending: true)]
        request.predicate = NSPredicate.init(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        loadItems(with: request)
    }
    
}
