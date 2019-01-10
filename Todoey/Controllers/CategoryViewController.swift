//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Justin Cruice on 1/8/19.
//  Copyright © 2019 Justin Cruice. All rights reserved.
//

import UIKit
import CoreData


class CategoryViewController: UITableViewController {

    var categories = [Category]()
    
    let defaults = UserDefaults.standard
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadItems()
        // Do any additional setup after loading the view.
    }
    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        let item = categories[indexPath.row]
        
        cell.textLabel?.text = item.name
        
        return cell
    }

    //MARK:- Tableview Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //if more than one segue coming from view controller, perform an if statement to check segue identifier
        let destinationVC = segue.destination as! ToDoListViewController
        
        //grab category that corresponds to cell. wrap in if let incase index path is nil
        //when we wrote this, .selectedCategory did not exist, need to create this above viewdidload in the destination view controller
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories[indexPath.row]
            
        }
    }

    
    //MARK: - Data Manipulation Methods
    
    func saveCategories(){
        do{
            try context.save()
        }catch{
            print("error saving \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadItems(){
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        do{
            categories = try context.fetch(request)
        }catch{
            print("error loading data \(error)")
        }
        self.tableView.reloadData()
        
    }
    
    
    // MARK: - Add New Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //What Will happen once the user clicks the add item button on UIAlert
            
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            self.categories.append(newCategory)
            
            self.saveCategories()
            
        }
        
        alert.addAction(action)
        
        alert.addTextField { (alertTextField) in
            textField = alertTextField
            alertTextField.placeholder = "Create New Item"
            
        }
       
        
        present(alert, animated: true, completion: nil)
        
     
        
    }
    

    

    
    
    
    
    


        

}
