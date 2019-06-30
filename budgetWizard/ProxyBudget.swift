//
//  ProxyBudget.swift
//  budgetWizard
//
//  Created by Kent McNamara on 27/06/19.
//  Copyright © 2019 Kent McNamara. All rights reserved.
//

import Foundation

class ProxyBudget : NSObject {
    
    var budgetName: String
    var startDate: NSDate
    var endDate: NSDate
    var incomingCashFlow: NSDecimalNumber
    var expenses: [Expenses]?
    var expenseSet: NSSet?
    
    init?(budgetName: String, incomingCashFlow: NSDecimalNumber, startDate: NSDate?, endDate: NSDate?){
        guard !budgetName.isEmpty else{
            return nil
        }
        
        guard incomingCashFlow != 0 else{
            return nil
        }
        
        guard let sDate = startDate else{
            return nil
        }
        
        guard let eDate = endDate else{
            return nil
        }
        
        self.budgetName = budgetName
        self.incomingCashFlow = incomingCashFlow
        self.startDate = sDate
        self.endDate = eDate
    }
    
    func AddExpense(expense: Expenses){
        self.expenses?.append(expense)
    }
    
    func populateSet(){
        expenseSet?.addingObjects(from: expenses!)
    }
    
    
}
