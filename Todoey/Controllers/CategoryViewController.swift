//
//  CategoryViewController.swift
//  Todoey
//
//  Created by mac on 8/15/19.
//  Copyright © 2019 alaa. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categoryArray = [Category]()

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        loadCategories()
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
 
    //MARK: - ADD New Categories

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textFiled = UITextField()
        let alert = UIAlertController(title: "Add new Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add ", style: .default) { (action) in
            //what will hapen w hen the user clicks
            let newCategory = Category(context: self.context)
            newCategory.name = textFiled.text!
            self.categoryArray.append(newCategory)
            
            //self.defaults.set(self.itemArray, forKey: "TodoListArray")
            
            self.saveCategories()
        }
        
        alert.addAction(action)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add a new Category"
            textFiled = alertTextField
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        let category = categoryArray[indexPath.row]
        
        cell.textLabel?.text = category.name
        
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "gotoItems", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gotoItems"{
            let destinationVC = segue.destination as! TodoListViewController
            if let indexPath = tableView.indexPathForSelectedRow {
                destinationVC.selectedCategorie = categoryArray[indexPath.row]
            }
        }
    }

    //MARK: - Data manipulation Methods
    
    func saveCategories() {
        
        do {
            try context.save()
        }catch{
            print("Error saving contexte, \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadCategories(with request : NSFetchRequest<Category> = Category.fetchRequest()){
        
        do {
            categoryArray =   try context.fetch(request)
        }catch{
            print("Error fetching data from  contexte, \(error)")
        }
    }
    
    
    
}
