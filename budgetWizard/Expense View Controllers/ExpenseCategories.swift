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
    
    static let categoryWeightsDict = ["All":["Credit Cards", "Food", "Future Bill",
                                 "Kids", "Insurance", "Loans", "Medical","Mortgage", "Personal", "Pets", "Rates", "Rent","Savings", "Sundry", "Utilities", "Vehicle"],
                                   "Necessity":["Food","Insurance","Medical","Mortgage",
                                                "Rates","Rent","Utilities"],
                                  "Commitments":["Kids","Pets","Savings","Vehicle"],
                                  "Future Bill":["Future Bill"],
                                  "Recurring":["Recurring"],
                                  "Wants":["Credit Cards","Loans","Personal","Sundry"]]
    
    static let categoryWeights = ["All","Commitments","Future Bill","Necessity","Recurring","Wants"]
   
    static func GetCategories()-> [String]{
        return categories
    }
    
    static func GetCategoryWeights()-> [String]{
        return categoryWeights
    }
    
    static func GetCategoriesFromTitle(){
        
    }
}
