//
//  LineChartView.swift
//  budgetWizard
//
//  Created by Kent McNamara on 4/08/19.
//  Copyright © 2019 Kent McNamara. All rights reserved.
//

import Foundation
import Charts

extension SummaryChartsCollectionCell{
    
    func initLineChart(){
        getExpenses()
        lineChart.chartDescription?.enabled = false
        lineChart.dragEnabled = true
        lineChart.setScaleEnabled(true)
        lineChart.pinchZoomEnabled = false
        lineChart.doubleTapToZoomEnabled = false
        
        let xAxis = lineChart.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = .systemFont(ofSize: 10)
        xAxis.granularity = 1
        xAxis.labelCount = 7
        xAxis.valueFormatter = ExpenseAxisValueFormatter(chart: lineChart, expenses: expenses)
        
        // x-axis limit line
        let llXAxis = ChartLimitLine(limit: 10, label: "Index 10")
        llXAxis.lineWidth = 4
        llXAxis.lineDashLengths = [10, 10, 0]
        llXAxis.labelPosition = .bottomRight
        llXAxis.valueFont = .systemFont(ofSize: 10)
        
        lineChart.xAxis.gridLineDashLengths = [10, 10]
        lineChart.xAxis.gridLineDashPhase = 0
        
        let ll1 = ChartLimitLine(limit: 1000, label: "Upper Limit")
        ll1.lineWidth = 4
        ll1.lineDashLengths = [5, 5]
        ll1.labelPosition = .topRight
        ll1.valueFont = .systemFont(ofSize: 10)
        
        let ll2 = ChartLimitLine(limit: 50, label: "Lower Limit")
        ll2.lineWidth = 4
        ll2.lineDashLengths = [5,5]
        ll2.labelPosition = .bottomRight
        ll2.valueFont = .systemFont(ofSize: 10)
        
        let leftAxis = lineChart.leftAxis
        leftAxis.removeAllLimitLines()
        leftAxis.addLimitLine(ll1)
        leftAxis.addLimitLine(ll2)
        leftAxis.axisMaximum = 1200
        leftAxis.axisMinimum = 0
        leftAxis.gridLineDashLengths = [5, 5]
        leftAxis.drawLimitLinesBehindDataEnabled = true
        
        lineChart.rightAxis.enabled = false
        
        
        let marker = XYMarkerView(color: UIColor(white: 180/250, alpha: 1),
                                  font: .systemFont(ofSize: 12),
                                  textColor: .white,
                                  insets: UIEdgeInsets(top: 8, left: 8, bottom: 20, right: 8),
                                  xAxisValueFormatter: lineChart.xAxis.valueFormatter!)
        
        marker.chartView = lineChart
        marker.minimumSize = CGSize(width: 80, height: 40)
        lineChart.marker = marker
        
        lineChart.legend.form = .line
        
        lineChart.animate(xAxisDuration: 2.5)
    }
    
    func updateLineChart(){
        initLineChart()
        var index = -1
        
        var lineChartDataEntries = [ChartDataEntry]()
        
        expenses.forEach{e in
            index += 1
            let entry = ChartDataEntry(x: Double(index), y: Double(truncating: e.amount))
            lineChartDataEntries.append(entry)
        }
        
        let budgetName = SummaryChartsCollectionCell.budget?.budgetName
        let dataSet = LineChartDataSet(entries: lineChartDataEntries, label: [budgetName,"budget"].compactMap{ $0 }.joined(separator: " "))
        dataSet.drawIconsEnabled = false
        
        dataSet.lineDashLengths = [5, 2.5]
        dataSet.highlightLineDashLengths = [5, 2.5]
        dataSet.setColor(.black)
        dataSet.setCircleColor(.black)
        dataSet.lineWidth = 1
        dataSet.circleRadius = 3
        dataSet.drawCircleHoleEnabled = false
        dataSet.valueFont = .systemFont(ofSize: 9)
        dataSet.formLineDashLengths = [5, 2.5]
        dataSet.formLineWidth = 1
        dataSet.formSize = 15
        
        let gradientColors = [ChartColorTemplates.colorFromString("#A9F36A").cgColor,
                              ChartColorTemplates.colorFromString("#48FE00").cgColor]
        let gradient = CGGradient(colorsSpace: nil, colors: gradientColors as CFArray, locations: nil)!
        
        dataSet.fillAlpha = 0.6
        dataSet.fill = Fill(linearGradient: gradient, angle: 90)
        dataSet.drawFilledEnabled = true
        

        let data = LineChartData(dataSets: [dataSet])
        data.setDrawValues(false)
        
        lineChart.data = data
    }
    
}

