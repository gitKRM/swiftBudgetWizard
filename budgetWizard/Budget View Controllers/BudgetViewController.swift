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
    var createdBudget: ProxyBudget?
    var selectedBudget: Budget? //--Edit existing budget
    struct ActiveControl{
        static let nameTextFieldSelected = 1
        static let incomeCashFlowSelected = 2
        static let startDateSelected = 3
        static let endDateSelected = 4
    }
    
    @IBOutlet weak var titleLabel: UILabel!
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
        loadExistingBudget()
    }
    
    //MARK: Load existing budget
    func loadExistingBudget(){
        if let selectedBudget = selectedBudget{
            nameTextField.text = selectedBudget.budgetName
            incomingCashFlow.text = CustomNumberFormatter.getNumberAsString(number: selectedBudget.incomingCashFlow! as NSDecimalNumber)
            startDate.text = CustomDateFormatter.getDatePropertyAsString(formatSpecifier: "dd/MM/yyyy", date: selectedBudget.startDate)
            endDate.text = CustomDateFormatter.getDatePropertyAsString(formatSpecifier: "dd/MM/yyyy", date: selectedBudget.endDate)
            
            saveButton.isEnabled = true
            titleLabel.text = "Edit \(selectedBudget.budgetName!)"
        }else{
            titleLabel.text = "Create New Budget"
        }
        
    }
    
    //MARK: Init Gesture Recogniser
    func initGestureRecogniser(){
        //--Gesture recogniser associated to full view, closes of any keyboards when tapped
        let gestureRecogniser = UITapGestureRecognizer(target: self, action: #selector(BudgetViewController.viewTapped(gestureRecogniser:)))
        view.addGestureRecognizer(gestureRecogniser)
    }
    
    // MARK: - Navigation
    @IBAction func cancel(_ sender: UIBarButtonItem) {
//        //--dismiss if view is presented modally
        let isPresentingController = presentingViewController is UITabBarController
        if isPresentingController{
            dismiss(animated: true, completion: nil)
        }
            //--Pop if view has been pushed on the stack
        else if let owningNavController = navigationController{
            owningNavController.popViewController(animated: true)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard let button = sender as? UIBarButtonItem, button === saveButton else{
            fatalError("Button not recognised -- Was Expecting Save Button")
        }
        
        createdBudget = ProxyBudget(budgetName: nameTextField.text!, incomingCashFlow: Decimal(string: incomingCashFlow.text!)! as NSDecimalNumber, startDate: startDatePicker?.date as NSDate?, endDate: endDatePicker?.date as NSDate?)
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if (validateForSave()){
            return true
        }
        return false
    }
    
    //MARK: Gesture Recogniser view Tapped
    @objc func viewTapped(gestureRecogniser: UITapGestureRecognizer){
        view.endEditing(true)
        
    }
    
    //MARK: Validation
    func validateForSave()-> Bool{
        var errorMsg = ""
        
        let amount: Decimal? = Decimal(string: incomingCashFlow.text!)
        if (amount == nil){
            errorMsg += "\nIncoming Cash Flow Must Be Entered"
        }

        let validStartDate = CustomDateFormatter.getDatePropertyFromString(formatSpecifier: "dd/MM/yyyy", date: startDate.text)
        if (validStartDate == nil){
            errorMsg += "\nInvalid Start Date"
        }

        let validEndDate = CustomDateFormatter.getDatePropertyFromString(formatSpecifier: "dd/MM/yyyy", date: endDate.text)
        if (validEndDate == nil){
            errorMsg += "\nInvalid End Date"
        }
        if (validStartDate != nil && validEndDate != nil){
            if (validEndDate! < validStartDate!){
                errorMsg += "\nInvalid End Date"
            }
        }
        if (!errorMsg.isEmpty){
            let alert = UIAlertController(title: "Validation Error", message: errorMsg, preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
        return errorMsg.isEmpty
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
        saveButton.isEnabled = true
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
        startDate.text = CustomDateFormatter.getDatePropertyAsString(formatSpecifier: "dd/MM/yyyy", date: startDatePicker.date as NSDate)
    }

    @objc func endDateChanged(endDatePicker: UIDatePicker){
        endDate.text = CustomDateFormatter.getDatePropertyAsString(formatSpecifier: "dd/MM/yyyy", date: endDatePicker.date as NSDate)
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
