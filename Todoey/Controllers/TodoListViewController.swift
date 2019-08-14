//
//  ViewController.swift
//  Todoey
//
//  Created by mac on 8/12/19.
//  Copyright © 2019 alaa. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController  {
    var itemArray = [Item]()
    
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        
        itemArray.append(Item(title: "Find Milk"))
        
        itemArray.append(Item(title: "Buy Eggos"))
        
        itemArray.append(Item(title: "Destroy Demon"))
        
        if let items = defaults.array(forKey: "TodoListArray") as? [Item]  {
            self.itemArray = items
        }
        // Do any additional setup  after loading the view.
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
        
        print(itemArray[indexPath.row])
        itemArray[indexPath.row].Check()
        
//        if (tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark ){
//            tableView.cellForRow(at: indexPath)?.accessoryType = .none
//        }else{
//            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//        }
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textFiled = UITextField()
        let alert = UIAlertController(title: "Add new Todoey Item", message: "", preferredStyle: .alert)
    
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will hapen when the user clicks
            self.itemArray.append(Item(title: textFiled.text!))
            self.defaults.set(self.itemArray, forKey: "TodoListArray")
            self.tableView.reloadData()
        }
        
        alert.addAction(action)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new Item"
            textFiled = alertTextField
        }
        
        present(alert, animated: true, completion: nil)
    }
    

}

