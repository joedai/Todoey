//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Joe Dai on 11/07/18.
//  Copyright © 2018 Joe Dai. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {

    var categoryArray = [Category]();
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }
    
    //MARK Table view source
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = categoryArray[indexPath.row].title
        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add new todoey category", message: "", preferredStyle: .alert)
        
        var textField = UITextField()
        
        let action = UIAlertAction(title: "Add new category", style: .default, handler: { (action) in
            let category = Category(context: self.context)
            category.title = textField.text!
            self.categoryArray.append(category)
            
            self.saveCategories()
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
    func saveCategories(){
        do{
            try self.context.save()
        }catch{
            print("Error while saving array \(error)")
        }
    }
    
    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()){
        do{
            categoryArray = try self.context.fetch(request)
        }catch{
            print("Error while loading array \(error)")
        }
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dest = segue.destination as! TodoListViewController
        dest.parentCategory = categoryArray[tableView.indexPathForSelectedRow!.row]
    }
}
