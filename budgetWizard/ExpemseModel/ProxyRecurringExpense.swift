//
//  ProxyRecurringExpense.swift
//  budgetWizard
//
//  Created by Kent McNamara on 3/08/19.
//  Copyright © 2019 Kent McNamara. All rights reserved.
//

import Foundation

class ProxyRecurringExpense : NSObject{
    
    var expenseName: String
    var expenseAmount: NSDecimalNumber
    var expenseDate: NSDate
    var expenseCategory: String
    var expenseFrequency: Int16
    
    init?(expenseName: String, expenseAmount: NSDecimalNumber, expenseDate: NSDate?, expenseCategory: String, expenseFrequency: Int16){
        
        guard !expenseName.isEmpty else{
            return nil
        }
        
        guard expenseAmount != 0 else{
            return nil
        }
        
        guard let eDate = expenseDate else{
            return nil
        }
        
        guard !expenseCategory.isEmpty else{
            return nil
        }
        
        guard expenseFrequency > 0 else{
            return nil
        }
        
        self.expenseName = expenseName
        self.expenseAmount = expenseAmount
        self.expenseDate = eDate
        self.expenseCategory = expenseCategory
        self.expenseFrequency = expenseFrequency
    }
    
}
