//
//  PieChartView.swift
//  budgetWizard
//
//  Created by Kent McNamara on 28/07/19.
//  Copyright © 2019 Kent McNamara. All rights reserved.
//

import Foundation
import Charts

extension SummaryChartsCollectionCell{
    
    func initPieChart(){
        let legend = pieChart.legend
        legend.horizontalAlignment = .right
        legend.verticalAlignment = .top
        legend.orientation = .horizontal
        legend.xEntrySpace = 7
        legend.yEntrySpace = 0
        legend.yOffset = 0
        
        pieChart.setExtraOffsets(left: 10, top: 0, right: 10, bottom: 0)
        
        pieChart.entryLabelColor = .white
        pieChart.entryLabelFont = .systemFont(ofSize: 14, weight: .bold)
        
        pieChart.animate(xAxisDuration: 1.4, easingOption: .easeOutBack)
        
    }
    
    func updatePieChart(){
        if (pieChart != nil){
            getExpenses()
            initPieChart()
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
    }
    
    func updateChartData(pieChartDataEntries: [PieChartDataEntry]){
        
        let budgetName = SummaryChartsCollectionCell.budget?.budgetName
        
        let dataSet = PieChartDataSet(entries: pieChartDataEntries, label: [budgetName,"budget"].compactMap{ $0 }.joined(separator: " "))
        dataSet.valueColors = [UIColor.black]
        dataSet.valueFont = UIFont.systemFont(ofSize: 14)
        dataSet.valueLineColor = .white
        dataSet.sliceSpace = 2
        
        dataSet.xValuePosition = PieChartDataSet.ValuePosition.outsideSlice
        
        let chartData = PieChartData(dataSet: dataSet)
        let format = NumberFormatter()
        format.numberStyle = .currency
        let formatter = DefaultValueFormatter(formatter: format)
        chartData.setValueFormatter(formatter)
        
        dataSet.colors = UIColor.getColors().shuffled()
        
        pieChart.data = chartData
    }
    
    
    
}
