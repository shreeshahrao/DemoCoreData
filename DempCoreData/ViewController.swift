//
//  ViewController.swift
//  DempCoreData
//
//  Created by Shreesha on 23/11/21.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var items:[Person]?
    @IBOutlet weak var itemTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        itemTableView.dataSource = self
        itemTableView.delegate = self
        fetchPeople()
    }
    
    func fetchPeople() {
        do {
            let request = Person.fetchRequest() as NSFetchRequest<Person>
            
            
            let pred = NSPredicate(format: "name CONTAINS 'S'") //%@ Dynamic
            request.predicate = pred
            
            self.items = try context.fetch(request)
            
            DispatchQueue.main.async {
                self.itemTableView.reloadData()
            }
        }
        catch {
            print(error)
        }
        
    }
    
    @IBAction func addItemButton(_ sender: UIBarButtonItem) {
        
        var itemText = UITextField()
                let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
                
                let action  = UIAlertAction(title: "Add", style: .default) {
                    (action) in
                    let newPerson = Person(context: self.context)
                    
                    //Create a Person Object
                    newPerson.name = itemText.text
                    newPerson.age = 20
                    newPerson.gender = "Male"
                    
                    // Save data
                    do {
                        try self.context.save()
                        
                    }
                    catch {
                        print("Error While Saving Data")
                    }
                    //Refresh the table View
                    self.fetchPeople()
                }
                
                alert.addTextField { (alertTextField) in
                    alertTextField.placeholder = "Add New Item"
                    itemText = alertTextField
                }
                
                alert.addAction(action)
                present(alert, animated: true, completion: nil)
                
                
            }
 
    }
    


extension ViewController: UITableViewDataSource , UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DempTableViewCell
        
        let person = self.items![indexPath.row]
        
        cell.itemLabel.text = person.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
            
            // Which person to remove
            let personToRemove = self.items![indexPath.row]
        
            // Remove the Person
            self.context.delete(personToRemove)
            
            //Save the data
            do {
            try self.context.save()
            }
            catch{
                print("Error While Deleting Data")
            }
            
            // Redetch the data
            self.fetchPeople()
            
        }
            return UISwipeActionsConfiguration(actions: [action])
            
        }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let person = self.items![indexPath.row]
        
        let alert = UIAlertController(title: "Edit Person", message: "Edit Name", preferredStyle: .alert)
        alert.addTextField() // Add Text Field
        
        let textField = alert.textFields![0]
        textField.text = person.name
        
        // Configure Button Handler
        let saveButton = UIAlertAction(title: "Save", style: .default) { (action) in
            // Get the TextField for the alert
            let textField = alert.textFields![0]
            
            // Edit name propert of person object
            person.name = textField.text
            
            // Save the data
            do {
                try self.context.save()
                
            }
            catch{
                print("Error while Updating the data")
            }
            // refetch the data
            self.fetchPeople()
        }
        alert.addAction(saveButton)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    }
    
    


