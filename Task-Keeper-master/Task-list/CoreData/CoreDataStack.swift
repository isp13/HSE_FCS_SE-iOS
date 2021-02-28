//
//  CoreDataStack.swift
//  Task-list
//
//  Created by Никита on 10/11/2018.
//  Copyright © 2018 Sinapsic. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack{
    var container: NSPersistentContainer{
        let container = NSPersistentContainer(name: "Todos")
        container.loadPersistentStores { (description, error) in
            guard error == nil else {
                print("Error \(error!)")
                return
            }
        }
        
        return container
    }
    var managedContext: NSManagedObjectContext{
        return container.viewContext
    }
}
