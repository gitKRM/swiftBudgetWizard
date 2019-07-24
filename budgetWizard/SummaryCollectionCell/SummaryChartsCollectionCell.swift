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
//        getExpenses()
//
//        var barChartDataEntries = [BarChartDataEntry]()
//        expenseTotal = 0
//
//        for i in 0..<expenses.count {
//            let dataEntry = BarChartDataEntry(x: Double(i), y: Double(truncating: expenses[i].amount), data: expenses[i].expenseName)
//            barChartDataEntries.append(dataEntry)
//        }
//
//        let chartDataSet = BarChartDataSet(entries: barChartDataEntries, label: nil)
//        let chartData = BarChartData(dataSet: chartDataSet)
//        barChart.data = chartData
        
        
        var months: [String]!
        
        
        months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
        let unitsSold = [20.0, 4.0, 6.0, 3.0, 12.0, 16.0, 4.0, 18.0, 2.0, 4.0, 5.0, 4.0]
        
        setChart(dataPoints: months, values: unitsSold)
        
        
    }
    
    
    func setChart(dataPoints: [String], values: [Double]) {
    
        barChart.noDataText = "Chart No DataText"
        
        barChart.chartDescription?.enabled = true
        barChart.dragEnabled = false
        barChart.setScaleEnabled(true)
        barChart.pinchZoomEnabled = false
        barChart.drawBarShadowEnabled = false
        barChart.drawValueAboveBarEnabled = true
        barChart.maxVisibleCount = 60
        barChart.setVisibleXRangeMaximum(20)
        barChart.extraRightOffset=CGFloat(24)
        barChart.isUserInteractionEnabled = false
        barChart.legend.enabled=true
        barChart.fitBars = true
        
        let xAxis = barChart.xAxis
        xAxis.labelPosition = .top
        //xAxis.labelFont =  UIFont(name: "Lato-Regular", size: 11)!
        xAxis.drawAxisLineEnabled = true
        xAxis.drawGridLinesEnabled = true
        xAxis.granularity = 1
        xAxis.enabled=true
        xAxis.forceLabelsEnabled = true
        
        //
        let leftAxis = barChart.leftAxis
        //leftAxis.labelFont =  UIFont(name: "Lato-Regular", size: 10)!
        leftAxis.drawAxisLineEnabled = true
        leftAxis.drawGridLinesEnabled = true
        leftAxis.axisMinimum = 0
        leftAxis.enabled=true
        
        
        let rightAxis = barChart.rightAxis
        //rightAxis.labelFont =  UIFont(name: "Lato-Regular", size: 10)!
        rightAxis.drawAxisLineEnabled = true
        rightAxis.drawGridLinesEnabled = true
        rightAxis.axisMinimum = 0
        rightAxis.enabled = true
        
        setChartDataWithValues(values: values, labels: dataPoints)
        
    }
    
    func setChartDataWithValues(values:[Double], labels:[String]) {
        
        let yVals = (0..<values.count).map { (i) -> BarChartDataEntry in
            
            let val = values[i]
            
            return BarChartDataEntry(x: Double(i), y: val, data: labels[i])
        }
        
        let barChartDataSet = BarChartDataSet(entries: yVals, label: "MF")
        
        barChartDataSet.colors = UIColor.getColors()
        
        
        let data = BarChartData(dataSet: barChartDataSet)
        //data.setValueFont(UIFont(name:"Lato-Regular", size:10)!)
        data.setDrawValues(true)
        
        let xAxis = barChart?.xAxis
        xAxis?.setLabelCount(values.count, force: false)
        xAxis?.valueFormatter=IndexAxisValueFormatter(values: labels )
        
        barChart?.data = data
        
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
