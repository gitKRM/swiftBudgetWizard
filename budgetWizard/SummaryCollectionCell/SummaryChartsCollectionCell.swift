//
//  SummaryChartsCollectionCell.swift
//  budgetWizard
//
//  Created by Kent McNamara on 18/07/19.
//  Copyright © 2019 Kent McNamara. All rights reserved.
//

import Foundation
import Charts

class SummaryChartsCollectionCell: UICollectionViewCell {
    //MARK: Properties
    @IBOutlet weak var pieChart: PieChartView!
    @IBOutlet weak var barChart: BarChartView!
    @IBOutlet weak var lineChart: LineChartView!
    static var selectedBudgetTxtField: String?
    var expenseTotal = Decimal()
    var expenses = [Expenses]()
    var recurringExpenses = [RecurringExpense]()
    static var budget: Budget?
    
    
//    func setLineChart(){
//
//        var dataEntries: [ChartDataEntry] = []
//        let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun"]
//        let unitsSold = [20.0, 4.0, 6.0, 3.0, 12.0, 16.0]
//        
//        
//        for i in 0..<months.count {
//            let dataEntry = ChartDataEntry(x: Double(i), y: unitsSold[i])
//            dataEntries.append(dataEntry)
//        }
//
//        let lineChartDataSet = LineChartDataSet(entries: dataEntries, label: nil)
//        let lineChartData = LineChartData(dataSet: lineChartDataSet)
//        lineChart.data = lineChartData
//        
//        lineChartDataSet.colors = UIColor.getColors().shuffled()
//    }
    
    //MARK: Charts loaded from db
    
    func getExpenses(){
        if ((SummaryChartsCollectionCell.selectedBudgetTxtField) != nil) && !SummaryChartsCollectionCell.selectedBudgetTxtField!.isEmpty{
            let split = SummaryChartsCollectionCell.selectedBudgetTxtField?.split(separator: "|")
            let category = String(split![1].trimmingCharacters(in: .whitespaces))
            
            if (SummaryChartsCollectionCell.budget != nil){
                expenses.removeAll()
                recurringExpenses.removeAll()
                if (category == "Recurring" || category == "All"){
                    recurringExpenses = PersistenceService.getRecurringExpenseAsArray()!
                }
                if (category != "Recurring"){
                    expenses = PersistenceService.getExpensesFromCategory(budget: SummaryChartsCollectionCell.budget!, category: category)!
                }
                
            }
        }
    }
    
}
