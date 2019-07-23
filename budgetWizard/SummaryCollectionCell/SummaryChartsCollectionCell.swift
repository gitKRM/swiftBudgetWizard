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
    
    func setBarChart(){
        var dataEntries: [BarChartDataEntry] = []
        let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun"]
        let unitsSold = [20.0, 4.0, 6.0, 3.0, 12.0, 16.0]
        
        
        for i in 0..<months.count {
            let dataEntry = BarChartDataEntry(x: unitsSold[i], y: Double(i))
            dataEntries.append(dataEntry)
        }
        
        let barChartDataSet = BarChartDataSet(entries: dataEntries, label: "Units Sold")
        let barChartData = BarChartData(dataSet: barChartDataSet)
        barChart.data = barChartData
        
        barChartDataSet.colors = UIColor.getColors().shuffled()
    }
    
    func setLineChart(){

        var dataEntries: [ChartDataEntry] = []
        let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun"]
        let unitsSold = [20.0, 4.0, 6.0, 3.0, 12.0, 16.0]
        
        
        for i in 0..<months.count {
            let dataEntry = ChartDataEntry(x: Double(i), y: unitsSold[i])
            dataEntries.append(dataEntry)
        }

        let lineChartDataSet = LineChartDataSet(entries: dataEntries, label: nil)
        let lineChartData = LineChartData(dataSet: lineChartDataSet)
        lineChart.data = lineChartData
        
        lineChartDataSet.colors = UIColor.getColors().shuffled()
    }
    
    //MARK: Charts loaded from db
    func updatePieChart(){
        getExpenses()
        
        var pieChartDataEntries = [PieChartDataEntry]()
        expenseTotal = 0
        expenses.forEach{e in
            let entry = PieChartDataEntry(value: e.amount as! Double)
            entry.label = e.expenseName
            expenseTotal += e.amount as Decimal
            pieChartDataEntries.append(entry)
        }
        
        pieChart.transparentCircleColor = UIColor.clear
        //pieChart.usePercentValuesEnabled = true
        pieChart.holeRadiusPercent = 0.4
        
        let attribute = [ NSAttributedString.Key.font: UIFont(name: "Chalkduster", size: 18.0)! ]
        
        pieChart.centerAttributedText = NSAttributedString(string: CustomNumberFormatter.getNumberFormattedAsCurrency(closure: CustomNumberFormatter.convertDecimalToNSDecimal(decimal:), decimal: expenseTotal)!, attributes: attribute)
        
        pieChart.legend.textColor = UIColor.black
        
        updateChartData(pieChartDataEntries: pieChartDataEntries)
        
    }
    
    func updateChartData(pieChartDataEntries: [PieChartDataEntry]){
        
        let dataSet = PieChartDataSet(entries: pieChartDataEntries, label: nil)
        dataSet.valueColors = [UIColor.black]
        dataSet.valueFont = UIFont.systemFont(ofSize: 17)
        
        dataSet.xValuePosition = PieChartDataSet.ValuePosition.outsideSlice
        
        let chartData = PieChartData(dataSet: dataSet)
        let format = NumberFormatter()
        format.numberStyle = .currency
        let formatter = DefaultValueFormatter(formatter: format)
        chartData.setValueFormatter(formatter)
        
        dataSet.colors = UIColor.getColors().shuffled()
        
        pieChart.data = chartData
    }
    
    func updateBarChart(){
        getExpenses()
        
        var barChartDataEntries = [BarChartDataEntry]()
        expenseTotal = 0
        
        for i in 0..<expenses.count {
            let dataEntry = BarChartDataEntry(x: Double(truncating: expenses[i].amount), y: Double(i))
            barChartDataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(entries: barChartDataEntries, label: "Expenditure")
        let chartData = BarChartData(dataSet: chartDataSet)
        barChart.data = chartData
        
        
//        var dataEntries: [BarChartDataEntry] = []
//        let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun"]
//        let unitsSold = [20.0, 4.0, 6.0, 3.0, 12.0, 16.0]
//
//
//        for i in 0..<months.count {
//            let dataEntry = BarChartDataEntry(x: unitsSold[i], y: Double(i))
//            dataEntries.append(dataEntry)
//        }
//
//        let barChartDataSet = BarChartDataSet(entries: dataEntries, label: "Units Sold")
//        let barChartData = BarChartData(dataSet: barChartDataSet)
//        barChart.data = barChartData
//
//        barChartDataSet.colors = UIColor.getColors().shuffled()
        
        
        
        
    }
    
    func getExpenses(){
        if !SummaryChartsCollectionCell.selectedBudgetTxtField!.isEmpty{
            let split = SummaryChartsCollectionCell.selectedBudgetTxtField?.split(separator: "|")
            let category = String(split![1].trimmingCharacters(in: .whitespaces))
            
            if (SummaryChartsCollectionCell.budget != nil){
                expenses.removeAll()
                expenses = PersistenceService.getExpensesFromCategory(budget: SummaryChartsCollectionCell.budget!, category: category)!
            }
        }
    }
    
    
    
}
