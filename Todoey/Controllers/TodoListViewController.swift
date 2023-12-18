//
//  TodoListViewController.swift
//  Todoey
//
//  Created by Meddy  on 12/11/2023.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    let defaults = UserDefaults.standard
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory,
        in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    



    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationController?.navigationBar.barTintColor = UIColor.systemBlue  // Change to your desired color
        
        
        
        
        print(dataFilePath)
        let newItem = Item()
        newItem.title = "Hit The Gym"
        itemArray.append(newItem)
        
        let newItem2 = Item()
        newItem2.title = "Meal Prep"
        itemArray.append(newItem2)
        
        let newItem3 = Item()
        newItem3.title = "Sleep"
        itemArray.append(newItem3)
        
        loadItems()
        

    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = itemArray[indexPath.row]

        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        cell.textLabel?.text = item.title

        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    //MARk - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(indexPath.row)
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done


        
        self.saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    //MARK - Add New Items

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var  textField = UITextField()
        let alert = UIAlertController(title: "Add New Todoey item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { [self] (action) in
            //when item is added
            
            let newItem = Item()
            newItem.title = textField.text!
            self.itemArray.append(newItem)
            
            
            saveItems()
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New item"
            textField = alertTextField
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    //MARk - Model Methods
    func saveItems(){
        let encoder = PropertyListEncoder()

        do{
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)

        }
        catch{
            print("Error encoding item array,\(error)")
        }
        self.tableView.reloadData()
        
    }
    
    func loadItems(){
        if let data = try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            do {
                itemArray = try decoder.decode([Item].self, from: data)
            }catch {
                print("Error decoding item array,\(error)")

            }
        
            
        }
        
        
    }
    
}

