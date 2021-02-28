//
//  ToDoTableViewController.swift
//  Task-list
//
//  Created by Никита on 08/11/2018.
//  Copyright © 2018 Sinapsic. All rights reserved.
//

import UIKit
import CoreData
class ToDoTableViewController: UITableViewController {

    
    var resultsController: NSFetchedResultsController<Todo>!
    let coreDataStack = CoreDataStack()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("todoview controller initialized")
        let request: NSFetchRequest<Todo> = Todo.fetchRequest()
        let sortDescriptors = NSSortDescriptor(key: "date", ascending: true)//date
        request.sortDescriptors = [sortDescriptors]

        resultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: coreDataStack.managedContext, sectionNameKeyPath: nil, cacheName: nil)
        
        
        resultsController.delegate = self
        do {
            try resultsController.performFetch()
        } catch{
            print("Perform fetch error \(error)")
        }
        
        setStyle()
        
        
    }
    
    fileprivate func setStyle() {
        let nameobject = UserDefaults.standard.object(forKey: "color1") ?? "graystyle"
        
        if let style = nameobject as? String
        {
            if style == "bookstyle"
            {
                UIView.animate(withDuration: 1)
                {
                    
                    self.tableView.backgroundColor = UIColor (red: 238.0/255.0, green: 202.0/255.0, blue: 100.0/255.0, alpha: 1.0)
                    
                    self.navigationController?.navigationBar.barTintColor = UIColor (red: 238.0/255.0, green: 202.0/255.0, blue: 100.0/255.0, alpha: 1.0)
                }
            }
            if style == "bluestyle"
            {
                UIView.animate(withDuration: 1)
                {
                    
                    self.tableView.backgroundColor = UIColor (red: 35.0/255.0, green: 95.0/255.0, blue: 175.0/255.0, alpha: 1.0)
                    
                    self.navigationController?.navigationBar.barTintColor = UIColor (red: 35.0/255.0, green: 95.0/255.0, blue: 175.0/255.0, alpha: 1.0)
                }
            }
            if style == "graystyle"
            {
                UIView.animate(withDuration: 1)
                {
                    
                    self.tableView.backgroundColor =  UIColor (red: 120.0/255.0, green: 125.0/255.0, blue: 135.0/255.0, alpha: 1.0)
                    self.navigationController?.navigationBar.barTintColor = UIColor (red: 120.0/255.0, green: 125.0/255.0, blue: 135.0/255.0, alpha: 1.0)
                }
            }
        }
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return resultsController.sections?[section].numberOfObjects ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCell", for: indexPath)

        // Configure the cell...
        let todo = resultsController.object(at: indexPath)
        cell.textLabel?.text = todo.title
        cell.detailTextLabel?.text = todo.date?.getFormattedDate("", dateStyle: .medium, timeStyle: .none)
        cell.backgroundColor = self.tableView.backgroundColor
        
        if todo.priority == 1 //future plan
        {
            cell.textLabel?.textColor = UIColor.red
        }
        
        if todo.priority == 2 //importnat plan
        {
            cell.textLabel?.textColor = UIColor.green
        }
        
        if todo.priority == 0 //idea 
        {
            cell.textLabel?.textColor = UIColor.yellow
        }
        
        return cell
    }

    // MARK: - Navigation
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete"){ (action, view,
            completion) in
            let todo = self.resultsController.object(at: indexPath)
            self.resultsController.managedObjectContext.delete(todo)
            do {
                try self.resultsController.managedObjectContext.save()
                completion(true)
            } catch{
                print("delete error \(error)")
                completion(false)
            }
            
            
            
        }
        action.image = #imageLiteral(resourceName: "trash")
        action.backgroundColor = .red
        
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Check"){ (action, view,
            completion) in
            
            let todo = self.resultsController.object(at: indexPath)
            self.resultsController.managedObjectContext.delete(todo)
            do {
                try self.resultsController.managedObjectContext.save()
                completion(true)
            } catch{
                print("delete error \(error)")
                completion(false)
            }
            
            
        }
        action.image = #imageLiteral(resourceName: "check-1")
        action.backgroundColor = .green
        
        return UISwipeActionsConfiguration(actions: [action])
        
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowAddToDo", sender: tableView.cellForRow(at: indexPath))
    }
    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let _ = sender as? UIBarButtonItem, let vc = segue.destination as? AddToDoViewController{
            vc.managedContext = resultsController.managedObjectContext
            
        }
        
        if let cell = sender as? UITableViewCell, let vc=segue.destination as? AddToDoViewController{
            vc.managedContext = resultsController.managedObjectContext
            if let indexPath = tableView.indexPath(for: cell){
                let todo = resultsController.object(at: indexPath)
                vc.todo = todo
            }
        }
    }
    

}

extension ToDoTableViewController:NSFetchedResultsControllerDelegate
{
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let indexPath = newIndexPath{
                tableView.insertRows(at: [indexPath], with: .automatic)
            }
        case .delete:
            if let indexPath = indexPath{
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        case .update:
            if let indexPath = indexPath, let cell = tableView.cellForRow(at: indexPath){
                let todo = resultsController.object(at: indexPath)
                cell.textLabel?.text = todo.title
                cell.detailTextLabel?.text = todo.date?.getFormattedDate("", dateStyle: .medium, timeStyle: .none)
                
            }
            
        default:
            break
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("WILL APEAR")
        super.viewWillAppear(animated)
        self.setStyle()
        tableView.reloadData()
    }
}




