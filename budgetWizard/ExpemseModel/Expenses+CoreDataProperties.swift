//
//  Expenses+CoreDataProperties.swift
//  budgetWizard
//
//  Created by Kent McNamara on 25/06/19.
//  Copyright © 2019 Kent McNamara. All rights reserved.
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
    @NSManaged public var recurringFrequency: String?
    @NSManaged public var budget: Budget?

}
