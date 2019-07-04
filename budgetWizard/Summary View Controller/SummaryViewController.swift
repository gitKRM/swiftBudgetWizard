//
//  SummaryViewController.swift
//  budgetWizard
//
//  Created by Kent McNamara on 1/07/19.
//  Copyright © 2019 Kent McNamara. All rights reserved.
//

import UIKit
import Charts

class SummaryViewController: UIViewController {

    //MARK:Properties
    @IBOutlet weak var pieChart: PieChartView!
    
    var testData1 = PieChartDataEntry(value: 0)
    var testData2 = PieChartDataEntry(value: 0)
    var testData3 = PieChartDataEntry(value: 0)
    var testData4 = PieChartDataEntry(value: 0)
    var pieChartDataEntries = [PieChartDataEntry]()
    var test = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        pieChart.chartDescription?.text = ""
//        pieChart.transparentCircleColor = UIColor.clear
//        pieChart.holeRadiusPercent = 0
//        testData1.value = 24.0
//        testData1.label    = "Test data 1"
//        testData2.value = 56.4
//        testData2.label = "Test Data 2"
//        testData3.value = 78.2
//        testData3.label = "Test Data 3"
//        testData4.value = 12.5
//        testData4.label = "Test Data 4"
//        pieChart.legend.textColor = UIColor.black
//
//        pieChartDataEntries = [testData1, testData2, testData3, testData4]
//
//        updateChartData()
    }
    
    func updateChartData(){
        
        let dataSet = PieChartDataSet(entries: pieChartDataEntries, label: "My Test Chart")
        let chartData = PieChartData(dataSet: dataSet)
        
        //let colours = [UIColor.red, UIColor.green, UIColor.yellow, UIColor.blue]
        let colours = [UIColor(named: "MyPeach"), UIColor(named: "MyLime"), UIColor(named: "MyRed"), UIColor(named: "MyBlue")]
        dataSet.colors = colours as! [NSUIColor]
        
        pieChart.data = chartData
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        pieChart.chartDescription?.text = ""
        pieChart.transparentCircleColor = UIColor.clear
        pieChart.holeRadiusPercent = 0
        testData1.value = 24.0
        testData1.label    = "Test data 1"
        testData2.value = 56.4
        testData2.label = "Test Data 2"
        testData3.value = 78.2
        testData3.label = "Test Data 3"
        testData4.value = 12.5
        testData4.label = "Test Data 4"
        pieChart.legend.textColor = UIColor.black
        
        pieChartDataEntries = [testData1, testData2, testData3, testData4]
        
        updateChartData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
