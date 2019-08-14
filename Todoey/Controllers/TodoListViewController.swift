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
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    //let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        print(dataFilePath)
        
//        itemArray.append(Item(title: "Find Milk"))
//        
//        itemArray.append(Item(title: "Buy Eggos"))
//        
//        itemArray.append(Item(title: "Destroy Demon"))
        
        loadItems()
        
//        if let items = defaults.array(forKey: "TodoListArray") as? [Item]  {
//            self.itemArray = items
//        }
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
        
        self.saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textFiled = UITextField()
        let alert = UIAlertController(title: "Add new Todoey Item", message: "", preferredStyle: .alert)
    
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will hapen when the user clicks
            self.itemArray.append(Item(title: textFiled.text!))
            
            //self.defaults.set(self.itemArray, forKey: "TodoListArray")
            
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
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        }catch{
            print("Error encoding item array, \(error)")
        }
        self.tableView.reloadData() 
    }
    
    func loadItems(){
        if let data = try? Data(contentsOf: dataFilePath! ){
            let decoder = PropertyListDecoder ()
            do {
                itemArray = try decoder.decode([Item].self , from: data) 
            }catch{
                print("Error decoding  item array, \(error)")
            }
        }
    }
    

}

