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
    var budgets = [Budget]()
    @IBOutlet weak var selectedBudgetTxtField: UITextField!
    @IBOutlet weak var selectedCategoryTxtField: UITextField!
    
    var budgetItems: [String] = []
    var categoryItems: [String] = []
    var testData1 = PieChartDataEntry(value: 0)  
    var testData2 = PieChartDataEntry(value: 0)
    var testData3 = PieChartDataEntry(value: 0)
    var testData4 = PieChartDataEntry(value: 0)
    var pieChartDataEntries = [PieChartDataEntry]()
    var test = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func initDelegates(){
        selectedBudgetTxtField.delegate = self
        selectedCategoryTxtField.delegate = self
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
        SetupView()
        
//        pieChart.chartDescription?.text = "Chart Description"
//        pieChart.transparentCircleColor = UIColor.clear
//        pieChart.holeColor = UIColor(named: "MyBlue")
//        pieChart.usePercentValuesEnabled = true
//        pieChart.holeRadiusPercent = 0.1
//
//       // pieChart.centerAttributedText = NSAttributedString(string: "test")
//        testData1.value = 24.0
//        //testData1.label    = "Test data 1"
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
    
    func SetupView(){
        LoadPickerViews()
        createBudgetPickerView()
        createBudgetPickerToolBar()
        createCategoryPickerView()
        createCategoryPickerToolBar()
        selectedBudgetTxtField.text = budgetItems[budgetItems.count-1]
        selectedCategoryTxtField.text = categoryItems[0]
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

extension SummaryViewController: UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate{
    
    //MARK: Load Budgets
    func LoadPickerViews(){
        self.budgetItems.removeAll()
        self.budgets = GlobalBudget.getBudgets()!
        
        budgets.forEach{b in
            budgetItems.append(b.budgetName!)
        }
        
        categoryItems = ExpenseCategories.GetCategoryWeights()
    }
    
    //MARK: Picker View
    func createBudgetPickerView(){
        let budgetPicker = UIPickerView()
        budgetPicker.delegate = self
        budgetPicker.dataSource = self
        selectedBudgetTxtField.inputView = budgetPicker
    }
    
    func createBudgetPickerToolBar(){
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(SummaryViewController.closePicker))
        
        toolBar.setItems([doneButton], animated: true)
        toolBar.isUserInteractionEnabled = true
        selectedBudgetTxtField.inputAccessoryView = toolBar
    }
    
    func createCategoryPickerView(){
        let categoryPicker = UIPickerView()
        categoryPicker.delegate = self
        categoryPicker.dataSource = self
        selectedCategoryTxtField.inputView = categoryPicker
    }
    
    func createCategoryPickerToolBar(){
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(SummaryViewController.closePicker))
        toolBar.setItems([doneButton], animated: true)
        toolBar.isUserInteractionEnabled = true
        selectedCategoryTxtField.inputAccessoryView = toolBar
    }
    
    @objc func closePicker(){
        view.endEditing(true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (selectedBudgetTxtField.isFirstResponder){
            return budgetItems.count
        }else{
            return categoryItems.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (selectedBudgetTxtField.isFirstResponder){
            return budgetItems[row]
        }else{
            return categoryItems[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (selectedBudgetTxtField.isFirstResponder){
            selectedBudgetTxtField.text = budgetItems[row]
        }else{
            selectedCategoryTxtField.text = categoryItems[row]
        }
    }
}
