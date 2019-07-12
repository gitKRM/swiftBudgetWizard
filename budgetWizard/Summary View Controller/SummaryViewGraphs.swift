//
//  SummaryViewControllerGraphs.swift
//  budgetWizard
//
//  Created by Kent McNamara on 13/07/19.
//  Copyright © 2019 Kent McNamara. All rights reserved.
//

import Foundation
import Charts

extension SummaryViewController{
    
    func updateGraph(){
        getExpenses()
        
        var pieChartDataEntries = [PieChartDataEntry]()
        
        expenses.forEach{e in
            let entry = PieChartDataEntry(value: e.amount as! Double)
            entry.label = e.expenseName
            
            pieChartDataEntries.append(entry)
        }
        
        pieChart.chartDescription?.text = budget?.budgetName
        pieChart.transparentCircleColor = UIColor.clear
        //pieChart.usePercentValuesEnabled = true
        pieChart.holeRadiusPercent = 0.5
        // pieChart.centerAttributedText = NSAttributedString(string: "test")
        
        pieChart.legend.textColor = UIColor.black
        
        updateChartData(pieChartDataEntries: pieChartDataEntries)
        
    }
    
    func updateChartData(pieChartDataEntries: [PieChartDataEntry]){
        
        let dataSet = PieChartDataSet(entries: pieChartDataEntries, label: nil)
        dataSet.valueColors = [UIColor.black]
        dataSet.valueFont = UIFont.systemFont(ofSize: 12)
        
        let chartData = PieChartData(dataSet: dataSet)
   
        dataSet.colors = UIColor.getColors()
        
        pieChart.data = chartData
    }
    
    func getExpenses(){
        if !selectedBudgetTxtField.text!.isEmpty{
            let split = selectedBudgetTxtField.text?.split(separator: "|")
            let category = String(split![1].trimmingCharacters(in: .whitespaces))
            
            if (budget != nil){
                expenses.removeAll()
                expenses = PersistenceService.getExpensesFromCategory(budget: budget!, category: category)!
            }
        }
    }
    
}


//let colours = [UIColor.red, UIColor.green, UIColor.yellow, UIColor.blue]
//        let colours = [UIColor(named: "MyPeach"), UIColor(named: "MyLime"), UIColor(named: "MyRed"), UIColor(named: "MyBlue")]

//dataSet.colors = colors as! [NSUIColor]

//        var colors: [UIColor] = []
//
//        for _ in 0..<pieChartDataEntries.count {
//            let red = Double(arc4random_uniform(256))
//            let green = Double(arc4random_uniform(256))
//            let blue = Double(arc4random_uniform(256))
//
//            let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
//            colors.append(color)
//        }
//
//        dataSet.colors = colors

