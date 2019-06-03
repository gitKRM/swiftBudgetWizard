//
//  ExpenseViewController.swift
//  budgetWizard
//
//  Created by Kent McNamara on 2/06/19.
//  Copyright © 2019 Kent McNamara. All rights reserved.
//

import UIKit

class ExpenseViewController: UIViewController{
    
    //MARK: Properties
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var expenseName: UITextField!
    @IBOutlet weak var amount: UITextField!
    let categories = ["Credit Cards", "Food", "Future Bill", "Future Goal", "Kids", "Insurance", "Loans", "Medical", "Mortgage", "Personal", "Pets", "Rates", "Rent", "Savings", "Sundry", "Utilities", "Vehicle"]
    var selectedCategory: String?
    
    //MARK: Private Properties
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createCategoryPickerView()
        createCategoryPickerToolBar()
        categoryTextField.delegate = self
        expenseName.delegate = self
        amount.delegate = self
        
        //--Gesture recogniser associated to full view, closes of any keyboards when tapped
        let gestureRecogniser = UITapGestureRecognizer(target: self, action: #selector(ExpenseViewController.viewTapped(gestureRecogniser:)))
        
        view.addGestureRecognizer(gestureRecogniser)
    }
    

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
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(ExpenseViewController.closeCategoryPicker))
        
        toolBar.setItems([doneButton], animated: true)
        toolBar.isUserInteractionEnabled = true
        categoryTextField.inputAccessoryView = toolBar
    }
    
    @objc func closeCategoryPicker(){
        view.endEditing(true)
    }
    
    
    // MARK: - Navigation
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    
    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: Gesture Recogniser view Tapped
    @objc func viewTapped(gestureRecogniser: UITapGestureRecognizer){
        view.endEditing(true)
    }

}

extension ExpenseViewController: UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    //MARK: Picker Functionss
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCategory = categories[row]
        categoryTextField.text = selectedCategory
    }
    
    
    //MARK: Text field functions
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        expenseName.resignFirstResponder()
        return true
    }
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        
//    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        navigationItem.title = expenseName.text
        if (textField == amount && !textField.text!.isEmpty){
            let newAmount:Double? = Double(textField.text!)
            
            let formatter = NumberFormatter()
            formatter.locale = Locale.autoupdatingCurrent
            formatter.numberStyle = .currency
            if let formattedAmount = formatter.string(from: newAmount! as NSNumber){
                textField.text = formattedAmount
            }
        }
    }
    
}
