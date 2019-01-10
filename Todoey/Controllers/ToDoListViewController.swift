//
//  ViewController.swift
//  Todoey
//
//  Created by Justin Cruice on 1/3/19.
//  Copyright © 2019 Justin Cruice. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {
    
    
    var itemArray = [Item]()
    
    var selectedCategory : Category? {
        didSet{
         loadItems()
        }
    }
    
    let defaults = UserDefaults.standard
    
    
     let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
       // print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        

//        let newItem = Item()
//        newItem.title = "Find Mike"
//        itemArray.append(newItem)
//
//        let newItem2 = Item()
//        newItem2.title = "Buy Eggos"
//        itemArray.append(newItem2)
//
//        let newItem3 = Item()
//        newItem3.title = "Destroy Demogorgan"
//        itemArray.append(newItem3)
//
//        if let items = defaults.array(forKey: "ToDoListArray") as? [Item]{
//            itemArray = items
    
        // load items called in selectedCategory, to avoid crashing.
        //loadItems()
        // Do any additional setup after loading the view, typically from a nib.
    }

    
    //MARK - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none
//        code above is a ternary operator and replaces below code.
//        if item.done == true {
//            cell.accessoryType = .checkmark
//        } else {
//            cell.accessoryType = .none
//        }
        
        
        return cell
    }
    
    //MARK: - Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
      //  print (itemArray[indexPath.row])
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
     
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        saveItems()
        
//        above code replaces the below code, since bool only has two options this works
//        if itemArray[indexPath.row].done == false {
//            itemArray[indexPath.row].done = true
//        }else {
//            itemArray[indexPath.row].done = false
//        }
        
        // adds and removes checkmark when selected
      

        
        tableView.deselectRow(at: indexPath, animated: true)
        //above makes the highlight dissappear
    }
    
    //MARK: - Add New Items

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //What Will happen once the user clicks the add item button on UIAlert
            
            
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            self.itemArray.append(newItem)
            
            self.saveItems()
            
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
            
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
        
    }
        
    
    //MARK: - Model Manipulation Methods
    func saveItems() {
        
        do{
            try context.save()
        }catch {
          print("Error Saving Context \(error)")
        }
        
        self.tableView.reloadData()
        }
    
    //loads items
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate:NSPredicate? = nil) {
        //= Item.fectrequest gives us a default value
        // (with request: is has an internal and external parameter
       // let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)

        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        }else{
            request.predicate = categoryPredicate
        }
        
//        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, predicate])
//
//        request.predicate = compoundPredicate
        
        do {
            itemArray = try context.fetch(request)
        }catch {
            print("Error fetching data from context \(error)")
        }
        tableView.reloadData()
        
    }
    
    }

//MARK: - Search Bar Method

extension ToDoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        // original code before refactoring
        
//        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//
//        request.predicate = predicate
//
//        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
//
//        request.sortDescriptors = [sortDescriptor]
//
//        do {
//            itemArray = try context.fetch(request)
//        }catch {
//            print("Error fetching data from context \(error)")
//        }
//
//        tableView.reloadData()
//    }
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request, predicate: predicate)
        
    
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            //without below code, only reloads when you click an item
            DispatchQueue.main.async {
                
                searchBar.resignFirstResponder()
                
            }
            
            tableView.reloadData()
        }
        
    }
}




