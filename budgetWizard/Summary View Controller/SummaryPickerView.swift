//
//  SummaryPickerView.swift
//  budgetWizard
//
//  Created by Kent McNamara on 13/07/19.
//  Copyright © 2019 Kent McNamara. All rights reserved.
//

import Foundation
import UIKit

extension SummaryViewController: UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate{
    
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
    
    @objc func closePicker(){
        view.endEditing(true)
        returnFromFilter(indexPath: menuBar.originalMenuIndex!)
    }
    
    //MARK: PickerView Protocols
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
            SummaryChartsCollectionCell.budget = budgets[row]
            selectedBudgetTxtField.text = pickerData[component][row] + " | " + pickerData[1][selectedCategoryRow]
            selectedBudgetRow = row
        }else{
            selectedBudgetTxtField.text = pickerData[0][selectedBudgetRow] + " | " + pickerData[component][row]
            selectedCategoryRow = row
        }
        SummaryChartsCollectionCell.selectedBudgetTxtField = selectedBudgetTxtField.text
        
        switch SummaryViewController.cell?.reuseIdentifier {
        case "pieChart":
            SummaryViewController.cell!.updatePieChart()
            break
        case "barChart":
            SummaryViewController.cell!.updateBarChart()
            break;
        default:
            SummaryViewController.cell!.setLineChart()
        }
        
        
    }
}

