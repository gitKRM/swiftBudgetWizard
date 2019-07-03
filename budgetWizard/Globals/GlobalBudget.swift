//
//  GlobalBudget.swift
//  budgetWizard
//
//  Created by Kent McNamara on 19/06/19.
//  Copyright © 2019 Kent McNamara. All rights reserved.
//

import Foundation
import CoreData
import os.log

class GlobalBudget {
    
    //static var budgets = [Budget]()

    static func getBudgets() -> [Budget]? {
        
        let fetchRequest: NSFetchRequest<Budget> = Budget.fetchRequest()
        
        do{
            let budget = try PersistenceService.context.fetch(fetchRequest)
            //self.budgets = budget
            return budget
        }catch{
            os_log("Error getting budget information from DB", log: OSLog.default, type: .error)
        }
        return nil
    }
    
}
