//
//  CustomNumberFormatter.swift
//  budgetWizard
//
//  Created by Kent McNamara on 19/06/19.
//  Copyright © 2019 Kent McNamara. All rights reserved.
//

import Foundation

class CustomNumberFormatter{
    
    static func getNumberFormattedAsCurrency(amount: NSNumber)-> String?{
       
        let formatter = NumberFormatter()
        formatter.locale = Locale.autoupdatingCurrent
        formatter.numberStyle = .currency
        if let formattedAmount = formatter.string(from: amount){
            return formattedAmount
        }
        return nil
    }
    
    static func getNumberFormattedAsCurrency(closure: (Decimal) -> NSNumber, decimal: Decimal)-> String?{
        
        let formatter = NumberFormatter()
        formatter.locale = Locale.autoupdatingCurrent
        formatter.numberStyle = .currency
        if let formattedAmount = formatter.string(from: closure(decimal)){
            return formattedAmount
        }
        return nil
    }
    
    static func convertDecimalToNSDecimal(decimal: Decimal) -> NSNumber{
        if (decimal.isNaN){
            return NSNumber(0)
        }
        return NSDecimalNumber(decimal: decimal)
    }

    static func getNumberAsString(number: NSDecimalNumber)-> String?{
        let numFormatter = NumberFormatter()
        numFormatter.generatesDecimalNumbers = true
        numFormatter.minimumFractionDigits = 2
        numFormatter.maximumFractionDigits = 2
        return numFormatter.string(from: number)
    }
    
}
