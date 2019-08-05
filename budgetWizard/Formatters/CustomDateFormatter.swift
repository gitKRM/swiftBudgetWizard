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
    
    static func addDayMonthToCurrentDate(originalDate: Date, day: Int, month: Int)-> Date{
        var comp = DateComponents()
        comp.day = day
        comp.month = month
        return Calendar.current.date(byAdding: comp, to: originalDate)!
    }
    
}
