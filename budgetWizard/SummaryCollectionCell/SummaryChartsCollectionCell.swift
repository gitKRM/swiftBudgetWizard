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
    
    func setPieChart() {
        
        var dataEntries: [PieChartDataEntry] = []
        let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun"]
        let unitsSold = [20.0, 4.0, 6.0, 3.0, 12.0, 16.0]
        
        
        for i in 0..<months.count {
            let dataEntry = PieChartDataEntry(value: unitsSold[i], label: months[i], data: Double(i))
            dataEntries.append(dataEntry)
        }
        
        let pieChartDataSet = PieChartDataSet(entries: dataEntries, label: "Units Sold")
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        pieChart.data = pieChartData
        
        pieChartDataSet.colors = UIColor.getColors().shuffled()
        
    }
    
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
}
