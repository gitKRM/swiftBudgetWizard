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
    var budget: Budget?
    var expenses = [Expenses]()
    @IBOutlet weak var selectedBudgetTxtField: UITextField!
    @IBOutlet weak var selectedCategoryTxtField: UITextField!
    
    var budgetItems: [String] = []
    var categoryItems: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func initDelegates(){
        selectedBudgetTxtField.delegate = self
        selectedCategoryTxtField.delegate = self
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        SetupView()
    }
    
    func SetupView(){
        LoadBudgets()
        UIColor.loadColors()
        createBudgetPickerView()
        createBudgetPickerToolBar()
        createCategoryPickerView()
        createCategoryPickerToolBar()
        selectedBudgetTxtField.text = budgetItems[budgetItems.count-1]
        selectedCategoryTxtField.text = categoryItems[0]
        updateGraph()
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
    func LoadBudgets(){
        self.budgetItems.removeAll()
        self.budgets = GlobalBudget.getBudgets()!
        
        budgets.forEach{b in            
            budgetItems.append(b.budgetName!)
        }
        let index = budgets.count
        budget = budgets[index-1]
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
            budget = budgets[row]
            selectedBudgetTxtField.text = budgetItems[row]
        }else{
            selectedCategoryTxtField.text = categoryItems[row]
        }
        updateGraph()
    }
    
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
        
        dataSet.colors = UIColor.getColors()
    
        pieChart.data = chartData
    }
    
    func getExpenses(){
        if (budget != nil){
            expenses.removeAll()
            expenses = PersistenceService.getExpensesFromCategory(budget: budget!, category: selectedCategoryTxtField.text!)!
        }
    }
}

extension UIColor{
    private static var colorArray = [UIColor]()
    
    static func loadColors(){
        
        colorArray.append(UIColor(named: "DarkLime")!)
        colorArray.append(UIColor(named: "Desert")!)
        colorArray.append(UIColor(named: "Grass")!)
        colorArray.append(UIColor(named: "HotPink")!)
        colorArray.append(UIColor(named: "MyBlue")!)
        colorArray.append(UIColor(named: "MyGreen")!)
        colorArray.append(UIColor(named: "MyLightPurple")!)
        colorArray.append(UIColor(named: "MyLime")!)
        colorArray.append(UIColor(named: "MyPeach")!)
        colorArray.append(UIColor(named: "MyRed")!)
        colorArray.append(UIColor(named: "MyYellow")!)
        colorArray.append(UIColor(named: "NiceBlue")!)
        colorArray.append(UIColor(named: "PaleBlue")!)
        colorArray.append(UIColor(named: "PastalPink")!)
        colorArray.append(UIColor(named: "SkyBlue")!)
        colorArray.append(UIColor(named: "Violet")!)
    }
    
    static func getColors() -> [UIColor] {return colorArray}
}
