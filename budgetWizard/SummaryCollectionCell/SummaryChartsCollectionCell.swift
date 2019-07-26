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
        
        pieChart.legend.textColor = UIColor.white
        
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
    
    
    //***************** BAR CHART START ***********************************
    
    func setup(){
        barChart.chartDescription?.enabled = false
        barChart.dragEnabled = true
        barChart.setScaleEnabled(true)
        barChart.pinchZoomEnabled = false
        
        barChart.drawBarShadowEnabled = false
        barChart.drawValueAboveBarEnabled = false
        barChart.maxVisibleCount = 60
        
        let xAxis = barChart.xAxis
        xAxis.labelPosition = .bottom
        barChart.rightAxis.enabled = false
        xAxis.labelFont = .systemFont(ofSize: 12)
        xAxis.granularity = 1
        xAxis.labelCount = 7 //--max label count = 25
        
        let leftAxisFormatter = NumberFormatter()
        leftAxisFormatter.minimumFractionDigits = 0
        leftAxisFormatter.maximumFractionDigits = 1
        leftAxisFormatter.negativePrefix = " $"
        leftAxisFormatter.positivePrefix = " $"
        
        let leftAxis = barChart.leftAxis
        leftAxis.labelFont = .systemFont(ofSize: 12)
        leftAxis.labelCount = 7 //-- max count = 25
        leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: leftAxisFormatter)
        leftAxis.labelPosition = .outsideChart
        leftAxis.spaceTop = 0.15
        leftAxis.axisMinimum = 0
        
        let rightAxis = barChart.rightAxis
        rightAxis.labelFont = .systemFont(ofSize: 12)
        rightAxis.labelCount = 7
        rightAxis.valueFormatter = leftAxis.valueFormatter
        rightAxis.spaceTop = 0.15
        rightAxis.axisMinimum = 0
        
        let legend = barChart.legend
        legend.horizontalAlignment = .left
        legend.verticalAlignment = .center
        legend.orientation = .horizontal
        legend.drawInside = false
        legend.form = .circle
        legend.formSize = 9
        legend.font = .systemFont(ofSize: 11)
        legend.xEntrySpace = 4
        
    }
    
    func updateBarChart(){
        setup()
        getExpenses()
        
        let yVals = (0..<expenses.count).map { (i) -> BarChartDataEntry in
            
            return BarChartDataEntry(x: Double(i), y: Double(truncating: expenses[i].amount))
            
            }
        let dataSet = BarChartDataSet(entries: yVals, label: "Test Label")
        dataSet.colors = UIColor.getColors()
        dataSet.drawValuesEnabled = false
        
        let data = BarChartData(dataSet: dataSet)
        data.setValueFont(UIFont(name: "HelveticaNeue-Light", size: 10)!)
        data.barWidth = 0.9
        barChart.data = data
        
    }
    
    
    func setChart(dataPoints: [String], values: [Double]) {
    
        
        
    }
    
    //***************** BAR CHART END ***********************************
    
    
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
