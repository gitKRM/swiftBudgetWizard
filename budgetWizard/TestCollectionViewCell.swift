//
//  TestCollectionViewCell.swift
//  budgetWizard
//
//  Created by Kent McNamara on 15/07/19.
//  Copyright © 2019 Kent McNamara. All rights reserved.
//

import UIKit
import Charts

class TestCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var pieChart: PieChartView!
    @IBOutlet weak var myLabel: UILabel!
    
    func setChart() {
        
        var dataEntries: [PieChartDataEntry] = []
        let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun"]
        let unitsSold = [20.0, 4.0, 6.0, 3.0, 12.0, 16.0]
        
        
        for i in 0..<months.count {
            let dataEntry = PieChartDataEntry(value: unitsSold[i], data: Double(i))
            dataEntries.append(dataEntry)
        }
        
        let pieChartDataSet = PieChartDataSet(entries: dataEntries, label: "Units Sold")
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        pieChart.data = pieChartData
        
        var colors: [UIColor] = []
        
        for _ in 0..<months.count {
            let red = Double(arc4random_uniform(256))
            let green = Double(arc4random_uniform(256))
            let blue = Double(arc4random_uniform(256))
            
            let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
            colors.append(color)
        }
        
        pieChartDataSet.colors = colors
        
    }
}
