//
//  BudgetViewController.swift
//  budgetWizard
//
//  Created by Kent McNamara on 2/06/19.
//  Copyright © 2019 Kent McNamara. All rights reserved.
//

import UIKit
import CoreData
import os.log

class BudgetViewController: UIViewController {
    
    //MARK: Properties
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var incomingCashFlow: UITextField!
    @IBOutlet weak var startDate: UITextField!
    @IBOutlet weak var endDate: UITextField!
    
    struct ActiveControl{
        static let nameTextFieldSelected = 1
        static let incomeCashFlowSelected = 2
        static let startDateSelected = 3
        static let endDateSelected = 4
    }
    
    var fieldsCompleted = Array(repeating: false, count: 4)
    
    //MARK: Private properties
    private var startDatePicker: UIDatePicker?
    private var endDatePicker: UIDatePicker?

    //MARK: View Loading
    override func viewDidLoad() {
        super.viewDidLoad()
        createStartDatePicker()
        createStartDatePickerToolBar()
        createEndDatePicker()
        createEndDatePickerToolBar()
        initGestureRecogniser()
        // Do any additional setup after loading the view.
        nameTextField.delegate = self
        incomingCashFlow.delegate = self
        startDate.delegate = self
        endDate.delegate = self
        updateSaveButton()
        
    }
    
    //MARK: Init Gesture Recogniser
    func initGestureRecogniser(){
        //--Gesture recogniser associated to full view, closes of any keyboards when tapped
        let gestureRecogniser = UITapGestureRecognizer(target: self, action: #selector(BudgetViewController.viewTapped(gestureRecogniser:)))
        
        view.addGestureRecognizer(gestureRecogniser)
    }
    
    // MARK: - Navigation
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    
    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: Gesture Recogniser view Tapped
    @objc func viewTapped(gestureRecogniser: UITapGestureRecognizer){
        view.endEditing(true)
        
    }
    
    //--Swap the logic that directly presents view with a segue and use prepare(segue:)
    //MARK: Save Core Data
    @IBAction func saveBudget(_ sender: UIBarButtonItem) {
        let validate = validateForSave()
        if (!validate.isEmpty){
            let alert = UIAlertController(title: "Validation Error", message: validate, preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            return
        }
        let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
        guard let context = appDelegate?.persistentContainer.viewContext else {
            os_log("Did not successfully initialise context", log: OSLog.default, type: .error)
            let alert = UIAlertController(title: "Conext Error", message: "Error attempting to retrieve Database for Saving Data\nA log has been created for this error.", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            return
        }
        //Create entiry
        guard let entity = NSEntityDescription.entity(forEntityName: "Budgets", in: context)else{
            os_log("Could not find Budgets Entity", log: OSLog.default, type: .error)
            let alert = UIAlertController(title: "Table Error", message: "There was an error retrieving the database table for saving your budget.\nA log has been created for this error.", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            return
        }
        let newBudget = NSManagedObject(entity: entity, insertInto: context)
        //Add data to newBudget
        newBudget.setValue(nameTextField.text, forKey: "budgetName")
        let amount: Decimal? = Decimal(string: incomingCashFlow.text!)
        newBudget.setValue(amount, forKey: "incomingCashFlow")
        newBudget.setValue(startDatePicker?.date, forKey: "startDate")
        newBudget.setValue(endDatePicker?.date, forKey: "endDate")
        //Save Data
        do{
            try context.save()
            //Navigate to Expense View
            let expenseController = ExpenseViewController()
            present(expenseController, animated: true, completion: nil)
        }catch{
            os_log("Error saving budget to context", log: OSLog.default, type: .error)
            let alert = UIAlertController(title: "Save Error", message: "There was an error saving data to the database.\nAn error log has been created.", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func validateForSave()-> String{
        var errorMsg = ""
        
        let amount: Decimal? = Decimal(string: incomingCashFlow.text!)
        if (amount == nil){
            errorMsg += "\nIncoming Cash Flow Must Be Entered"
        }
        let startDateFormatter = DateFormatter()
            startDateFormatter.dateFormat = "dd/MM/yyyy"
        let validStartDate = startDateFormatter.date(from: startDate.text!)
        if (validStartDate == nil){
            errorMsg += "\nInvalid Start Date"
        }
        let endDateFormatter = DateFormatter()
            endDateFormatter.dateFormat = "dd/MM/yyyy"
        let validEndDate = endDateFormatter.date(from: endDate.text!)
        if (validEndDate == nil){
            errorMsg += "\nInvalid End Date"
        }
        if (validStartDate != nil && validEndDate != nil){
            if (validEndDate! < validStartDate!){
                errorMsg += "\nInvalid End Date"
            }
        }
        
        return errorMsg
    }
}

extension BudgetViewController: UITextFieldDelegate{
    
    //MARK UITextfieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameTextField.resignFirstResponder()
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        saveButton.isEnabled = false
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        navigationItem.title = nameTextField.text
//        if (textField == incomingCashFlow && !textField.text!.isEmpty){
//            let amount:Double? = Double(textField.text!)
//
//            let formatter = NumberFormatter()
//            formatter.locale = Locale.autoupdatingCurrent
//            formatter.numberStyle = .currency
//            if let formattedAmount = formatter.string(from: amount! as NSNumber){
//                textField.text = formattedAmount
//            }
//        }
        switch textField.tag {
            case ActiveControl.nameTextFieldSelected:
                fieldsCompleted[0] = !nameTextField.text!.isEmpty
                break
            case ActiveControl.incomeCashFlowSelected:
                fieldsCompleted[1] = !incomingCashFlow.text!.isEmpty
                break
            case ActiveControl.startDateSelected:
                fieldsCompleted[2] = !startDate.text!.isEmpty
                break
            case ActiveControl.endDateSelected:
                fieldsCompleted[3] = !endDate.text!.isEmpty
                break
            default:
                fieldsCompleted[5] = true
                break
        }
        var index: Int = 0
        for i in fieldsCompleted{
            if (i){
                index += 1
            }
            
        }
        //check against amount & datees -- amount of 0 will still have a string value
        if (index == 4){
            //validate fields have been completed, validate that they're correct
            
        }
        updateSaveButton()
    }

    //MARK: UIDatePickerView
    func createStartDatePicker(){
        startDatePicker = UIDatePicker()
        startDatePicker?.datePickerMode = .date
        startDatePicker?.addTarget(self, action: #selector(BudgetViewController.startDateChanged(startDatePicker:)), for: .valueChanged)
        startDate.inputView = startDatePicker
    }

    func createStartDatePickerToolBar(){
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(closePicker))

        toolBar.setItems([doneButton], animated: true)
        toolBar.isUserInteractionEnabled = true
        startDate.inputAccessoryView = toolBar
    }

    func createEndDatePicker(){
        endDatePicker = UIDatePicker()
        endDatePicker?.datePickerMode = .date
        endDatePicker?.addTarget(self, action: #selector(BudgetViewController.endDateChanged(endDatePicker:)), for: .valueChanged)
        endDate.inputView = endDatePicker
    }

    func createEndDatePickerToolBar(){
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(closePicker))

        toolBar.setItems([doneButton], animated: true)
        toolBar.isUserInteractionEnabled = true
        endDate.inputAccessoryView = toolBar
    }

    @objc func startDateChanged(startDatePicker: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        startDate.text = dateFormatter.string(from: startDatePicker.date)
    }

    @objc func endDateChanged(endDatePicker: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        endDate.text = dateFormatter.string(from: endDatePicker.date)
    }


    @objc func closePicker(){
        view.endEditing(true)
    }
    
    //MARK: Private functions
    private func updateSaveButton(){
        let text = nameTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
    
}
