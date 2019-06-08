//
//  Expenses+CoreDataProperties.swift
//  budgetWizard
//
//  Created by Kent McNamara on 8/06/19.
//  Copyright © 2019 Kent McNamara. All rights reserved.
//
//

import Foundation
import CoreData


extension Expenses {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Expenses> {
        return NSFetchRequest<Expenses>(entityName: "Expenses")
    }

    @NSManaged public var amount: NSDecimalNumber?
    @NSManaged public var expenseCategory: String?
    @NSManaged public var expenseDate: NSDate?
    @NSManaged public var expenseName: Bool
    @NSManaged public var isRecurring: Bool
    @NSManaged public var budgets: NSSet?

}

// MARK: Generated accessors for budgets
extension Expenses {

    @objc(addBudgetsObject:)
    @NSManaged public func addToBudgets(_ value: Budget)

    @objc(removeBudgetsObject:)
    @NSManaged public func removeFromBudgets(_ value: Budget)

    @objc(addBudgets:)
    @NSManaged public func addToBudgets(_ values: NSSet)

    @objc(removeBudgets:)
    @NSManaged public func removeFromBudgets(_ values: NSSet)

}
