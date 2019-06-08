//
//  Budget.swift
//  budgetWizard
//
//  Created by Kent McNamara on 8/06/19.
//  Copyright © 2019 Kent McNamara. All rights reserved.
//

import Foundation

class Budget : NSObject{
    var budgetName: String
    var incomgingCashFlow: Decimal
    var fromDate: Date
    var toDate: Date
    
    init?(budgetName: String, incomingCashFlow: Decimal, fromDate: String, toDate: String){
        guard !budgetName.isEmpty else{
            return nil
        }
        
        guard incomingCashFlow > 0 else{
            return nil
        }
        
        let startDateFormatter = DateFormatter()
        startDateFormatter.dateFormat = "dd/MM/yyyy"
        guard let startDate = startDateFormatter.date(from: fromDate) else{
            return nil
        }
        
        let endDateFormatter = DateFormatter()
        endDateFormatter.dateFormat = "dd/MM/yyyy"
        guard let endDate = endDateFormatter.date(from: toDate) else{
            return nil
        }
        
        self.budgetName = budgetName
        self.incomgingCashFlow = incomingCashFlow
        self.fromDate = startDate
        self.toDate = endDate
    }
}
