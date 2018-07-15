//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Joe Dai on 11/07/18.
//  Copyright © 2018 Joe Dai. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit

class CategoryTableViewController: SwipeableTableViewController {
    

    var categories: Results<Category>?
    
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
        tableView.rowHeight = 80
    }
    
    //MARK Table view source
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = categories![indexPath.row].name
        
        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add new todoey category", message: "", preferredStyle: .alert)
        
        var textField = UITextField()
        
        let action = UIAlertAction(title: "Add new category", style: .default, handler: { (action) in
            let newCategory = Category()
            newCategory.name = textField.text!
            
            self.saveCategory(newCategory)
            self.tableView.reloadData()
        })
        
        alert.addAction(action)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Category Name"
            textField = alertTextField
        }
        present(alert, animated: true, completion: nil)
    }
    
    //MARK DB interactions
    func saveCategory(_ category: Category){
        do{
            try realm.write {
                realm.add(category)
            }
        }catch{
            print("error writing category \(error)")
        }

    }
    
    override func deleteModel(at indexPath: IndexPath) {
        do{
            try realm.write {
                realm.delete(categories![indexPath.row])
            }
        }catch{
            print("error deleting category \(error)")
        }
    }
    
    func loadCategories(){
        categories = realm.objects(Category.self)
        
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dest = segue.destination as! TodoListViewController
        dest.parentCategory = categories![tableView.indexPathForSelectedRow!.row]
    }
}

