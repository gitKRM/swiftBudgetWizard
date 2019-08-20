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
    var budget: Budget?
    var payed: Bool?
    var isRecurring: Bool?
    var frequency: Int16?
    
    init?(expenseName: String, expenseAmount: NSDecimalNumber, expenseDate: NSDate?, expenseCategory: String, payed: Bool?, isRecurring: Bool?, frequency: Int16){
        
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
        if (isRecurring != nil){
            self.isRecurring = isRecurring
        }
        if (payed != nil){
            self.payed = payed
        }
        
        self.frequency = frequency
    }
    
    func setPayed(payed: Bool){
        self.payed = payed
    }
    
    func addBudget(budget: Budget){
        self.budget = budget
    }
    
}
