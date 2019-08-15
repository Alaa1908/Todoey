//
//  ViewController.swift
//  Todoey
//
//  Created by mac on 8/12/19.
//  Copyright © 2019 alaa. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    var itemArray = [Item]()
    var selectedCategorie : Category? {
        didSet{
            loadItems()
        }
    }
//    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext


    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        
        self.saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textFiled = UITextField()
        let alert = UIAlertController(title: "Add new Todoey Item", message: "", preferredStyle: .alert)
    
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will hapen w hen the user clicks
            let newItem = Item(context: self.context)
            newItem.title = textFiled.text!
            newItem.done = false
            newItem.parentCategory =  self.selectedCategorie
            self.itemArray.append(newItem)
            
            
            self.saveItems()
        }
        
        alert.addAction(action)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new Item"
            textFiled = alertTextField
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    func saveItems() {
        do {
            try context.save()
        }catch{
            print("Error saving contexte, \(error)")
        }
        self.tableView.reloadData() 
    }

    func loadItems(with request : NSFetchRequest<Item> = Item.fetchRequest(), predicate : NSPredicate? = nil ){
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategorie!.name!)
        
        if let additionalPredicat = predicate{
            
            let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates:  [categoryPredicate, additionalPredicat])
            
            request.predicate = compoundPredicate
            
        }else{
            request.predicate = categoryPredicate
        }
        
        
        do {
            itemArray =   try context.fetch(request)
        }catch{
            print("Error fetching data from  contexte, \(error)")
        }
    }

}


//MARK: - search bar methods
extension TodoListViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors  =  [NSSortDescriptor(key: "title", ascending: true )]
        
        loadItems(with: request, predicate: predicate)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}

