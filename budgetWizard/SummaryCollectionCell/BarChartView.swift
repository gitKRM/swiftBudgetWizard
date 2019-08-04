//
//  BarChartView.swift
//  budgetWizard
//
//  Created by Kent McNamara on 28/07/19.
//  Copyright © 2019 Kent McNamara. All rights reserved.
//

import Foundation
import Charts

extension SummaryChartsCollectionCell{
    
    func initBartChart(){
        getExpenses()
        UIColor.loadColors()
        barChart.doubleTapToZoomEnabled = false
        let xAxis = barChart.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = .systemFont(ofSize: 10)
        xAxis.granularity = 1
        xAxis.labelCount = 7
        xAxis.valueFormatter = ExpenseAxisValueFormatter(chart: barChart, expenses: expenses, recurringExpenses: recurringExpenses)
        
        let leftAxisFormatter = NumberFormatter()
        leftAxisFormatter.minimumFractionDigits = 0
        leftAxisFormatter.maximumFractionDigits = 1
        leftAxisFormatter.negativePrefix = " $"
        leftAxisFormatter.positivePrefix = " $"
        
        let leftAxis = barChart.leftAxis
        leftAxis.labelFont = .systemFont(ofSize: 10)
        leftAxis.labelCount = 8
        leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: leftAxisFormatter)
        leftAxis.labelPosition = .outsideChart
        leftAxis.spaceTop = 0.15
        leftAxis.axisMinimum = 0 
        
        let rightAxis = barChart.rightAxis
        rightAxis.enabled = true
        rightAxis.labelFont = .systemFont(ofSize: 10)
        rightAxis.labelCount = 8
        rightAxis.valueFormatter = leftAxis.valueFormatter
        rightAxis.spaceTop = 0.15
        rightAxis.axisMinimum = 0
        
        let l = barChart.legend
        l.horizontalAlignment = .left
        l.verticalAlignment = .top
        l.textColor = .white
        l.orientation = .horizontal
        l.drawInside = false
        l.form = .circle
        l.formSize = 9
        l.font = UIFont(name: "HelveticaNeue-Light", size: 11)!
        l.xEntrySpace = 4
        
        let marker = XYMarkerView(color: UIColor(white: 180/250, alpha: 1),
                                  font: .systemFont(ofSize: 12),
                                  textColor: .white,
                                  insets: UIEdgeInsets(top: 8, left: 8, bottom: 20, right: 8),
                                  xAxisValueFormatter: barChart.xAxis.valueFormatter!)
        marker.chartView = barChart
        marker.minimumSize = CGSize(width: 80, height: 40)
        barChart.marker = marker
        
    }
    
    func updateBarChart(){
        initBartChart()
        var index = -1
        
        var barChartDataEntries = [BarChartDataEntry]()
        
        expenses.forEach{e in
            index += 1
            let entry = BarChartDataEntry(x: Double(index), y: Double(truncating: e.amount))
            barChartDataEntries.append(entry)
        }
        
        recurringExpenses.forEach { r in
            index += 1
            let entry = BarChartDataEntry(x: Double(index), y: Double(truncating: r.amount))
            barChartDataEntries.append(entry)
        }
        
        var dataSet: BarChartDataSet! = nil
        let budgetName = SummaryChartsCollectionCell.budget?.budgetName
        
        dataSet = BarChartDataSet(entries: barChartDataEntries, label: [budgetName,"budget"].compactMap{ $0 }.joined(separator: " "))
        dataSet.colors = UIColor.getColors()
        dataSet.drawValuesEnabled = false
        
        let data = BarChartData(dataSet: dataSet)
        data.setValueFont(UIFont(name: "HelveticaNeue-Light", size: 10)!)
        data.barWidth = 0.9
        barChart.data = data
        
        
    }
    
}
