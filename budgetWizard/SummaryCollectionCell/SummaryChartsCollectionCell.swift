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
    static var budget: Budget?
    
    //MARK: Charts loaded from db
    func getExpenses(){
        if ((SummaryChartsCollectionCell.selectedBudgetTxtField) != nil) && !SummaryChartsCollectionCell.selectedBudgetTxtField!.isEmpty{
            let split = SummaryChartsCollectionCell.selectedBudgetTxtField?.split(separator: "|")
            let category = String(split![1].trimmingCharacters(in: .whitespaces))
            
            if (SummaryChartsCollectionCell.budget != nil){
                expenses.removeAll()
               expenses = PersistenceService.getExpensesFromCategory(budget: SummaryChartsCollectionCell.budget!, category: category)!               
            }
        }
    }
    
}
