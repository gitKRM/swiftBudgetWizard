//
//  PersistenceService.swift
//  budgetWizard
//
//  Created by Kent McNamara on 8/06/19.
//  Copyright © 2019 Kent McNamara. All rights reserved.
//

import Foundation
import CoreData

class PersistenceService{
    
    // MARK: - Core Data stack
    private init(){}
    
    static var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    static var persistentContainer: NSPersistentContainer = {
   
        let container = NSPersistentContainer(name: "budgetWizard")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
         
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    static func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
           
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    static func save(budget: ProxyBudget)-> Budget{
        
        let createdBudget = Budget(context: PersistenceService.context)
        createdBudget.budgetName = budget.budgetName
        createdBudget.incomingCashFlow = budget.incomingCashFlow
        createdBudget.startDate = budget.startDate
        createdBudget.endDate = budget.endDate
        saveContext()
        return createdBudget
    }

}
