//
//  CustomDateFormatter.swift
//  budgetWizard
//
//  Created by Kent McNamara on 13/06/19.
//  Copyright © 2019 Kent McNamara. All rights reserved.
//

import Foundation

class CustomDateFormatter{
    
    static func getDatePropertyFromString(formatSpecifier: String, date: String!)-> Date?{
        let formatter = DateFormatter()
        formatter.dateFormat = formatSpecifier
        return formatter.date(from:date)
    }
    
    static func getDatePropertyAsString(formatSpecifier: String, date: NSDate?)-> String?{
        
        guard let passedInDate = date else{
            return nil
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = formatSpecifier
        return formatter.string(from: passedInDate as Date)
    }
    
    //Name of day
    static func getDayName(date: NSDate?)-> Int{
        guard let passedIndate = date else{
            return 0
        }
        let calendar = Calendar.current
        return calendar.component(.day, from: passedIndate as Date)
    }
    
    static func addDayMonthToCurrentDate(expense: Expenses)-> Date{
        let comp = getDateComponent(expense: expense)
        return Calendar.current.date(byAdding: comp, to: expense.expenseDate as Date)!
    }
    
    static func getDateComponent(expense: Expenses)-> DateComponents{
        var comp = DateComponents()
        switch(expense.expenseCategory){
        case "Weekly":
            comp.day = 7
            break
        case "Fortnightly":
            comp.day = 14
            break
        case "Monthly":
            comp.month = 1
            break
        default:
            comp.day = 0
            break
        }        
        return comp
    }
}
