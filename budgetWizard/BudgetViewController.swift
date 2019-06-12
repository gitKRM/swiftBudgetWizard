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
    @IBOutlet weak var addExpenseButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var incomingCashFlow: UITextField!
    @IBOutlet weak var startDate: UITextField!
    @IBOutlet weak var endDate: UITextField!
    var createdBudget: Budget?
    var selectedBudget: Budget? //--Edit existing budget
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
        loadExistingBudget()
    }
    
    //MARK: Load existing budget
    func loadExistingBudget(){
        if let selectedBudget = selectedBudget{
            nameTextField.text = selectedBudget.budgetName
            let numFormatter = NumberFormatter()
            numFormatter.generatesDecimalNumbers = true
            numFormatter.minimumFractionDigits = 2
            numFormatter.maximumFractionDigits = 2
            incomingCashFlow.text = numFormatter.string(from: selectedBudget.incomingCashFlow! as NSDecimalNumber)
            let startDateFormatter = DateFormatter()
            startDateFormatter.dateFormat = "dd/MM/yyyy"
            startDate.text = startDateFormatter.string(from: selectedBudget.startDate! as Date)
            let endDateFormatter = DateFormatter()
            endDateFormatter.dateFormat = "dd/MM/yyyy"
            endDate.text = endDateFormatter.string(from: selectedBudget.endDate! as Date)
            addExpenseButton.isEnabled = true
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
        //--dismiss if view is presented modally
        let isPresentingController = presentingViewController is UINavigationController
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
        
        switch(segue.identifier ?? ""){
        case "btnSave":
            if (validateForSave()){
               save()
                guard let expenseViewController = segue.destination as? ExpenseViewController else{
                    os_log("Error initialising expense view controller", log: OSLog.default, type: .error)
                    return
                }
                expenseViewController.budget = createdBudget
            }
            break
            
        case "btnAddExpense":
            
            break
            
        default:
            fatalError("Unidentified button")
        }
    }
    
    //MARK: Actions
    @IBAction func unwindToBudgetView(sender : UIStoryboardSegue){
       print("Unwind from Expense View Controller")
    }
    
    //MARK: Gesture Recogniser view Tapped
    @objc func viewTapped(gestureRecogniser: UITapGestureRecognizer){
        view.endEditing(true)
        
    }
    
    //--Swap the logic that directly presents view with a segue and use prepare(segue:)
    //MARK: Save Core Data
    func save(){
        //Save Data
        let budget = Budget(context: PersistenceService.context)
        budget.budgetName = nameTextField.text
        budget.incomingCashFlow = Decimal(string: incomingCashFlow.text!) as NSDecimalNumber?
        budget.startDate = startDatePicker?.date as NSDate?
        budget.endDate = endDatePicker?.date as NSDate?
        PersistenceService.saveContext()
        createdBudget = budget
    }
    //MARK: Validation
    func validateForSave()-> Bool{
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
            //fields have been completed, validate that they're correct
            updateSaveButton()
        }
        
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
        addExpenseButton.isEnabled = false
    }
    
}
