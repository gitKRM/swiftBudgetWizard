//
//  ProxyExpense.swift
//  budgetWizard
//
//  Created by Kent McNamara on 29/06/19.
//  Copyright © 2019 Kent McNamara. All rights reserved.
//

import Foundation

class ProxyExpense: NSObject{
    
    var expenseName: String
    var expenseAmount: NSDecimalNumber
    var expenseDate: NSDate
    var expenseCategory: String
    var isRecurring: Bool?
    var recurringFrequency: String?
    var budget: Budget?
    
    init?(expenseName: String, expenseAmount: NSDecimalNumber, expenseDate: NSDate?, expenseCategory: String, isRecurring: Bool, recurringFrequency: String){
        
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
        
        self.expenseName = expenseName
        self.expenseAmount = expenseAmount
        self.expenseDate = eDate
        self.expenseCategory = expenseCategory
        self.isRecurring = isRecurring
        self.recurringFrequency = recurringFrequency
    }
    
    func addBudget(budget: Budget){
        self.budget = budget
    }
    
}
