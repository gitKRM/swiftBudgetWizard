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
    @IBOutlet weak var selectedBudgetTxtField: UITextField!
    var budgets = [Budget]()
    var budget: Budget?
    var expenses = [Expenses]()
    var pickerData: [[String]] = [[String]]()
    var selectedBudgetRow = 0
    var selectedCategoryRow = 0
    
    var budgetItems: [String] = []    
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        selectedBudgetTxtField.text = pickerData[0][budgetItems.count-1] + " | " + pickerData[1][0]
        updateGraph()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }

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

}

