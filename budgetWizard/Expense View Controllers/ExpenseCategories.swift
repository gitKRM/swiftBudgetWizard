//
//  ExpenseCategories.swift
//  budgetWizard
//
//  Created by Kent McNamara on 7/07/19.
//  Copyright © 2019 Kent McNamara. All rights reserved.
//

import Foundation

class ExpenseCategories{
    
    static var categories = ["Credit Cards", "Food", "Future Bill", "Future Goal", "Kids", "Insurance", "Loans", "Medical", "Mortgage", "Personal", "Pets", "Rates", "Rent", "Savings", "Sundry", "Utilities", "Vehicle"]
    
    static let categoryWeightsDict = ["All":["Credit Cards", "Food", "Future Bill",
                                 "Future Goal", "Kids", "Insurance", "Loans", "Medical","Mortgage", "Personal", "Pets", "Rates", "Rent","Savings", "Sundry", "Utilities", "Vehicle"],
                                   "Necessity":["Food","Insurance","Medical","Mortgage",
                                                "Rates","Rent","Utilities"],
                                  "Commitments":["Future Bill","Future Goal","Kids",
                                                 "Pets","Savings","Vehicle"],
                                  "Wants":["Credit Cards","Loans","Personal","Sundry"]]
    
    static let categoryWeights = ["All", "Necessity", "Commitments","Wants"]
   
    static func GetCategories()-> [String]{
        return categories
    }
    
    static func GetCategoryWeights()-> [String]{
        return categoryWeights
    }
    
    static func GetCategoriesFromTitle(){
        
    }
}
