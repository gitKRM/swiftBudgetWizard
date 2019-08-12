//
//  PersistenceService.swift
//  budgetWizard
//
//  Created by Kent McNamara on 8/06/19.
//  Copyright © 2019 Kent McNamara. All rights reserved.
//

import Foundation
import CoreData
import os.log

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
            do
            {
                try context.save()
            }
            catch
            {
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
    
    static func save(expense: ProxyExpense)-> Expenses{
        let createdExpense = Expenses(context: context)
        createdExpense.expenseName = expense.expenseName
        createdExpense.expenseCategory = expense.expenseCategory
        createdExpense.amount = expense.expenseAmount
        createdExpense.expenseDate = expense.expenseDate
        createdExpense.isRecurring = expense.isRecurring!
        createdExpense.budget = expense.budget
        saveContext()
        return createdExpense
    }
    
    //MARK: Edit
    static func edit(budget: ProxyBudget, existingBudget: Budget)-> Budget{
        let budgetToEdit = getItem(budget: existingBudget)
        budgetToEdit.setValue(budget.budgetName, forKey: "budgetName")
        budgetToEdit.setValue(budget.incomingCashFlow, forKey: "incomingCashFlow")
        budgetToEdit.setValue(budget.startDate, forKey: "startDate")
        budgetToEdit.setValue(budget.endDate, forKey: "endDate")
        budgetToEdit.setValue(existingBudget.expenses, forKey: "expenses")
       
        saveContext()
        return budgetToEdit as! Budget
       
    }
    
    static func edit(expense: ProxyExpense, existingExpense: Expenses)-> Expenses{
        let expenseToEdit = getItem(expense: existingExpense)
        expenseToEdit.setValue(expense.expenseName, forKey: "expenseName")
        expenseToEdit.setValue(expense.expenseCategory, forKey: "expenseCategory")
        expenseToEdit.setValue(expense.expenseAmount, forKey: "amount")
        expenseToEdit.setValue(expense.expenseDate, forKey: "expenseDate")
        expenseToEdit.setValue(expense.payed, forKey: "payed")
        expenseToEdit.setValue(expense.isRecurring, forKey: "isRecurring")
        expenseToEdit.setValue(expense.budget, forKey: "budget")
        
        saveContext()
        return expenseToEdit as! Expenses
    }
    
    //MARK: Delete
    static func delete(budget: Budget){
        let budgetToDelete = getItem(budget: budget)
        context.delete(budgetToDelete)
        saveContext()
    }
    
    static func delete(expense: Expenses){
        let expenseToDelete = getItem(expense: expense)
        context.delete(expenseToDelete)
        saveContext()
    }
    
    //MARK: Retrieve Object
    static func getItem(budget: Budget)-> NSManagedObject{
        let predicate = NSPredicate(format: "budgetName = %@", budget.budgetName!)
        let fetchRequest = getFetchRequest(entityName: "Budget", predicate: predicate)
        do
        {
            let fetcheddBudgets = try context.fetch(fetchRequest)
            let retrievedBudget = fetcheddBudgets[0] as! NSManagedObject
            return retrievedBudget
        }
        catch
        {
            fatalError("Error attempting to retrieve budget: \(String(describing: budget.budgetName))")
        }
    }
    
    static func getItem(name: String)-> Budget?{
        let predicate = NSPredicate(format: "budgetName = %@", name)
        let fetchRequest = getFetchRequest(entityName: "Budget", predicate: predicate)
        do{
            let fetchedBudgets = try context.fetch(fetchRequest)
            let retrievedBudget = fetchedBudgets[0] as! NSManagedObject
            return retrievedBudget as? Budget
        }
        catch{
            fatalError("Could not find budget with name \(name)")
        }
    }
    
    static func getItem(expense: Expenses)-> NSManagedObject{
        
        let predicate = NSPredicate(format: "expenseName = %@ AND amount = %@", expense.expenseName,expense.amount)
        let fetchRequest = getFetchRequest(entityName: "Expenses", predicate: predicate)
        
        do{
            let fetchedExpense = try context.fetch(fetchRequest)
            let retrievedExpense = fetchedExpense[0] as! NSManagedObject
            return retrievedExpense
        }
        catch{
            fatalError("Error attempting to retrieve expense: \(String(describing: expense.expenseName))")
        }
    }
    
    private static func getFetchRequest(entityName: String, predicate: NSPredicate)-> NSFetchRequest<NSFetchRequestResult>{
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        //fetchRequest.predicate = NSPredicate(format: "budgetName = %@", name)
        fetchRequest.predicate = predicate
        return fetchRequest
    }
    
    static func getBudgets() -> [Budget]? {
        
        let fetchRequest: NSFetchRequest<Budget> = Budget.fetchRequest()
        
        do{
            let budget = try PersistenceService.context.fetch(fetchRequest)            
            return budget
        }catch{
            os_log("Error getting budget information from DB", log: OSLog.default, type: .error)
        }
        return nil
    }
    
    static func getExpenseAsArray(budget: Budget?)->[Expenses] {
        var expenses = [Expenses]()
        if let existingExpenses = budget?.expenses{
            
            //let enumerator: NSEnumerator = budget!.expenses!.objectEnumerator()
            let enumerator: NSEnumerator = existingExpenses.objectEnumerator()
            while let value = enumerator.nextObject(){
                expenses.append(value as! Expenses)
            }
        }
        return expenses
    }
    
    static func getExpensesFromCategory(budget: Budget, category: String)-> [Expenses]?{     
        switch (category){
        case "All":
            return getExpenseAsArray(budget: budget)
        case "Future Bill":
            return filterExpenseOnCategory(budget: budget, category: "Future Bill")
        case "Recurring":
            return filterExpenseOnCategory(budget: budget, category: "Recurring")
        case "Necessity":
            return filterExpenseOnCategory(budget: budget, category: "Necessity")
        case "Commitments":
            return filterExpenseOnCategory(budget: budget, category: "Commitments")
        case "Wants":
            return filterExpenseOnCategory(budget: budget, category: "Wants")
        default:
            return nil
        }
    }
    
    private static func filterExpenseOnCategory(budget: Budget, category: String)-> [Expenses]{
        var expenses = [Expenses]()
        budget.expenses?.forEach{e in
            if let expense = e as? Expenses{
                if (ExpenseCategories.categoryWeightsDict[category]?.contains(expense.expenseCategory))!{
                    expenses.append(expense)
                }
            }
        }
        return expenses
    }
}
