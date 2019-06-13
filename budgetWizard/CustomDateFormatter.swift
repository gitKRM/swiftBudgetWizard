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
    
    static func getDatePropertyAsString(formatSpecifier: String, date: NSDate?)-> String{
        
        let formatter = DateFormatter()
        formatter.dateFormat = formatSpecifier
        return formatter.string(from: date! as Date)
    }
    
}
