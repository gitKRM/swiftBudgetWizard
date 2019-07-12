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
    var pickerData: [[String]] = [[String]]()
    var selectedBudgetRow = 0
    var budgetItems: [String] = []
    @IBOutlet weak var selectedBudgetTxtField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func initDelegates(){
        selectedBudgetTxtField.delegate = self
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
        selectedBudgetTxtField.text = pickerData[0][budgetItems.count-1] + " | " + pickerData[1][0]
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
        budgetItems.removeAll()
        self.budgets = GlobalBudget.getBudgets()!
        
        budgets.forEach{b in
            budgetItems.append(b.budgetName!)
        }
        
        budget = budgets[budgets.count-1]
        //--New Picker Data for 2D array
        pickerData = [budgetItems,ExpenseCategories.GetCategoryWeights()]
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
    }
    
    func createCategoryPickerToolBar(){
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(SummaryViewController.closePicker))
        toolBar.setItems([doneButton], animated: true)
        toolBar.isUserInteractionEnabled = true
    }
    
    @objc func closePicker(){
        view.endEditing(true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0{
            return pickerData[0].count
        }else{
            return pickerData[1].count
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[component][row]
    }

    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (component == 0){
            budget = budgets[row]
            selectedBudgetTxtField.text = pickerData[component][row] + " | " + pickerData[1][0]
            selectedBudgetRow = row
        }else{
            selectedBudgetTxtField.text = pickerData[0][selectedBudgetRow] + " | " + pickerData[component][row]
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
