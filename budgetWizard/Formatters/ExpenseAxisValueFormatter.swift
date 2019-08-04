//
//  ExpenseAxisValueFormatter.swift
//  budgetWizard
//
//  Created by Kent McNamara on 28/07/19.
//  Copyright © 2019 Kent McNamara. All rights reserved.
//

import Foundation
import Charts

class ExpenseAxisValueFormatter: NSObject, IAxisValueFormatter{
    
    weak var chart: BarLineChartViewBase?
    var expenses = [Expenses]()
    var recurringExpenses = [RecurringExpense]()
    
    init(chart: BarLineChartViewBase, expenses: [Expenses], recurringExpenses: [RecurringExpense]){
        self.chart = chart
        self.expenses = expenses
        self.recurringExpenses = recurringExpenses
    }
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let index = Int(value)
        if (index >= 0){
            if (expenses.count == 0){
                return recurringExpenses[index].expenseName
            }
            if (index >= expenses.count && recurringExpenses.count > 0){
                return recurringExpenses[index - expenses.count].expenseName
            }
            if (index <= expenses.count-1){
                return expenses[index].expenseName
            }
        }
        return ""
    }
}
