//
//  Budget+CoreDataProperties.swift
//  budgetWizard
//
//  Created by Kent McNamara on 25/06/19.
//  Copyright © 2019 Kent McNamara. All rights reserved.
//
//

import Foundation
import CoreData


extension Budget {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Budget> {
        return NSFetchRequest<Budget>(entityName: "Budget")
    }

    @NSManaged public var budgetName: String?
    @NSManaged public var endDate: NSDate?
    @NSManaged public var incomingCashFlow: NSDecimalNumber?
    @NSManaged public var startDate: NSDate?
    @NSManaged public var expenses: NSSet?

}

// MARK: Generated accessors for expenses
extension Budget {

    @objc(addExpensesObject:)
    @NSManaged public func addToExpenses(_ value: Expenses)

    @objc(removeExpensesObject:)
    @NSManaged public func removeFromExpenses(_ value: Expenses)

    @objc(addExpenses:)
    @NSManaged public func addToExpenses(_ values: NSSet)

    @objc(removeExpenses:)
    @NSManaged public func removeFromExpenses(_ values: NSSet)

}
