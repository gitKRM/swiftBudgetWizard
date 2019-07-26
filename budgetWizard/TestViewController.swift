//
//  TestViewController.swift
//  budgetWizard
//
//  Created by Kent McNamara on 25/07/19.
//  Copyright © 2019 Kent McNamara. All rights reserved.
//

import UIKit
import Charts

class TestViewController: UIViewController {
    
    
    @IBOutlet weak var pieChart: PieChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIColor.loadColors()
        updatePieChart()
    }
    

    func updatePieChart(){
        let expenses = [23.0, 21.4,56.3,78.9]
        
        var pieChartDataEntries = [PieChartDataEntry]()
    
        expenses.forEach{e in
            let entry = PieChartDataEntry(value: e )
            entry.label = "test\(e)"
            pieChartDataEntries.append(entry)
        }
        
        pieChart.transparentCircleColor = UIColor.clear
        //pieChart.usePercentValuesEnabled = true
        pieChart.holeRadiusPercent = 0.4
        
        _ = [ NSAttributedString.Key.font: UIFont(name: "Chalkduster", size: 18.0)! ]
        
        pieChart.centerAttributedText = NSAttributedString(string: "Test Chart")
        
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

}
