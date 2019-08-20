//
//  Expenses+CoreDataProperties.swift
//  
//
//  Created by Kent McNamara on 13/08/19.
//
//

import Foundation
import CoreData


extension Expenses {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Expenses> {
        return NSFetchRequest<Expenses>(entityName: "Expenses")
    }

    @NSManaged public var amount: NSDecimalNumber
    @NSManaged public var expenseCategory: String
    @NSManaged public var expenseDate: NSDate
    @NSManaged public var expenseName: String
    @NSManaged public var isRecurring: Bool
    @NSManaged public var payed: Bool
    @NSManaged public var frequency: Int16
    @NSManaged public var budget: Budget?

}
