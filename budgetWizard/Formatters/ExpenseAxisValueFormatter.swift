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
    
    init(chart: BarLineChartViewBase, expenses: [Expenses]){
        self.chart = chart
        self.expenses = expenses
    }
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let index = Int(value)
        if (index >= 0 && index <= expenses.count-1){
            return expenses[index].expenseName
        }
        return ""
    }
}
