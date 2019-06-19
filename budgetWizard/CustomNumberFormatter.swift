//
//  CustomNumberFormatter.swift
//  budgetWizard
//
//  Created by Kent McNamara on 19/06/19.
//  Copyright © 2019 Kent McNamara. All rights reserved.
//

import Foundation

class CustomNumberFormatter{
    
    static func getFormattedNumberAsString(amount: Decimal)-> String?{
       
        let formatter = NumberFormatter()
        formatter.locale = Locale.autoupdatingCurrent
        formatter.numberStyle = .currency
        if let formattedAmount = formatter.string(from: NSNumber(nonretainedObject: amount)){
            return formattedAmount
        }
        return nil
    }
    
}
