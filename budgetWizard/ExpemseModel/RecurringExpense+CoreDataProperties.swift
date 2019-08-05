//
//  RecurringExpense+CoreDataProperties.swift
//  
//
//  Created by Kent McNamara on 5/08/19.
//
//

import Foundation
import CoreData


extension RecurringExpense {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RecurringExpense> {
        return NSFetchRequest<RecurringExpense>(entityName: "RecurringExpense")
    }

    @NSManaged public var amount: NSDecimalNumber
    @NSManaged public var expenseCategory: String
    @NSManaged public var expenseDate: NSDate
    @NSManaged public var expenseFrequency: Int16
    @NSManaged public var expenseName: String

}
