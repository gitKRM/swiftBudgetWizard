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
    
    //MARK: Edit
    static func edit(budget: Budget){
        let budgetToEdit = getItem(budget: budget)
        budgetToEdit.setValue(budget.budgetName, forKey: "budgetName")
        budgetToEdit.setValue(budget.incomingCashFlow, forKey: "incomingCashFlow")
        budgetToEdit.setValue(budget.startDate, forKey: "startDate")
        budgetToEdit.setValue(budget.endDate, forKey: "endDate")
        budgetToEdit.setValue(budget.expenses, forKey: "expenses")
        do
        {
            try context.save()
        }
        catch
        {
            fatalError("Error attempting to update budget \(String(describing: budget.budgetName))")
        }
    }
    
    //MARK: Delete
    static func deleteBudget(budget: Budget){
        let budgetToDelete = getItem(budget: budget)
        context.delete(budgetToDelete)
        do
        {
            try context.save()
        }
        catch
        {
            fatalError("Error attempting to save managed objects after removing budget: \(String(describing: budget.budgetName))")
        }
    }
    
    //MARK: Retrieve Object
    static func getItem(budget: Budget)-> NSManagedObject{
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Budget")
        fetchRequest.predicate = NSPredicate(format: "budgetName = %@", budget.budgetName!)
        do{
            let fetcheddBudget = try context.fetch(fetchRequest)
            let retrievedBudget = fetcheddBudget[0] as! NSManagedObject
            return retrievedBudget
            
        }catch{
            fatalError("Error attempting to retrieve budget: \(String(describing: budget.budgetName))")
        }
    }
}
