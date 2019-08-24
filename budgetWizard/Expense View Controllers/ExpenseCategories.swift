//
//  ExpenseCategories.swift
//  budgetWizard
//
//  Created by Kent McNamara on 7/07/19.
//  Copyright © 2019 Kent McNamara. All rights reserved.
//

import Foundation

class ExpenseCategories{
    
    static var categories = ["Select Category","Credit Cards", "Food", "Future Bill", "Kids", "Insurance", "Loans", "Medical", "Mortgage", "Personal", "Pets", "Rates", "Rent", "Savings", "Sundry", "Utilities", "Vehicle"]
    
   
    static func GetCategories()-> [String]{
        var catArray = [String]()
        catArray = categories
        catArray.insert("All", at: 1)
        catArray.insert("Recurring", at: 2)
        return catArray
    }
}
