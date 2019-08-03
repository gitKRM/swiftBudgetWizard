//
//  ExpensePickerViews.swift
//  budgetWizard
//
//  Created by Kent McNamara on 13/07/19.
//  Copyright © 2019 Kent McNamara. All rights reserved.
//

import Foundation
import UIKit

extension ExpenseViewController: UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    //MARK: UIPickerView
    func createCategoryPickerView(){
        
        let categoryPicker = UIPickerView()
        categoryPicker.delegate = self
        categoryPicker.dataSource = self
        categoryTextField.inputView = categoryPicker
    }
    
    func createCategoryPickerToolBar(){
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(ExpenseViewController.closePicker))
        
        toolBar.setItems([doneButton], animated: true)
        toolBar.isUserInteractionEnabled = true
        categoryTextField.inputAccessoryView = toolBar
    }
    //MARK: Frequency Picker
    func createFrequencyPickerView(){
        let frequencyPicker = UIPickerView()
        frequencyPicker.delegate = self
        frequencyPicker.dataSource = self
        frequency.inputView = frequencyPicker
    }
    
    func createFrequencyPickerToolBar(){
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(ExpenseViewController.closePicker))
        toolBar.setItems([doneButton], animated: true)
        toolBar.isUserInteractionEnabled = true
        frequency.inputAccessoryView = toolBar
    }
    
    //MARK: Picker Functionss
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (frequency.isFirstResponder){
            return frequencies.count
        }else{
            return categories.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (frequency.isFirstResponder){
            return frequencies[row]
        }else{
            return categories[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (frequency.isFirstResponder){
            frequency.text = frequencies[row]
        }else{
            categoryTextField.text = categories[row]
        }
    }
    
    
    //MARK: Text field functions
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        expenseName.resignFirstResponder()
        return true
    }
 
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        navigationItem.title = expenseName.text
    }
    
    //MARK: Expense Date Picker
    func createExpenseDatePicker(){
        expenseDatePicker = UIDatePicker()
        expenseDatePicker?.datePickerMode = .date
        expenseDatePicker?.addTarget(self, action: #selector(ExpenseViewController.expenseDateChanged(expenseDatePicker:)), for: .valueChanged)
        expenseDate.inputView = expenseDatePicker
    }
    
    @objc func expenseDateChanged(expenseDatePicker: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        expenseDate.text = dateFormatter.string(from: expenseDatePicker.date)
    }
    
    func createExpenseDatePickerToolBar(){
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(ExpenseViewController.closePicker))
        toolBar.setItems([doneButton], animated: true)
        toolBar.isUserInteractionEnabled = true
        expenseDate.inputAccessoryView = toolBar
    }
    
    @objc func closePicker(){
        view.endEditing(true)
    }
    
}

