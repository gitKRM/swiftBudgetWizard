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
    @IBOutlet weak var expenseDate: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var recurringExpenseSwitch: UISwitch!
    @IBOutlet weak var frequency: UITextField!
    let categories = ExpenseCategories.GetCategories()
    let frequencies = ["Weekly", "Forntightly", "Monthly"]
    var createdExpense: ProxyExpense?
    var selectedExpense: Expenses?
    
    var expenseDatePicker: UIDatePicker?
    
    //MARK: View loading
    override func viewDidLoad() {
        super.viewDidLoad()
        initDelegates()
        initPickers()
        loadExistingExpense()
        initGestureRecogniser()
    }
    
    //MARK: Set Delegates
    func initDelegates(){
        categoryTextField.delegate = self
        expenseName.delegate = self
        amount.delegate = self
        frequency.delegate = self
    }
    
    func loadExistingExpense(){
        if let selectedExpense = selectedExpense{
            categoryTextField.text = selectedExpense.expenseCategory
            expenseName.text = selectedExpense.expenseName
            expenseDate.text = CustomDateFormatter.getDatePropertyAsString(formatSpecifier: "dd/MMM/yyyy", date: selectedExpense.expenseDate)
            amount.text = CustomNumberFormatter.getNumberAsString(number: selectedExpense.amount as NSDecimalNumber)
            recurringExpenseSwitch.isOn = selectedExpense.isRecurring
            frequency.text = selectedExpense.recurringFrequency
        }
    }
    
    //MARK: Set Gesture recogniser
    func initGestureRecogniser(){
        //--Gesture recogniser associated to full view, closes of any keyboards when tapped
        let gestureRecogniser = UITapGestureRecognizer(target: self, action: #selector(ExpenseViewController.viewTapped(gestureRecogniser:)))
        
        view.addGestureRecognizer(gestureRecogniser)
    }
    
    //MARK: Init Pickers
    func initPickers(){
        createCategoryPickerView()
        createCategoryPickerToolBar()
        createFrequencyPickerView()
        createFrequencyPickerToolBar()
        createExpenseDatePicker()
        createExpenseDatePickerToolBar()
    }

    // MARK: - Navigation
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        //--dismiss if view is presented modally
        let isPresentingController = presentingViewController is UITabBarController
        if isPresentingController{
            dismiss(animated: true, completion: nil)
        }
            //--Pop if view has been pushed on the stack
        else if let owningNavController = navigationController{
            owningNavController.popViewController(animated: true)
        }
    }
    
    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard let button = sender as? UIBarButtonItem, button === saveButton else{
            fatalError("Unrecognised button received")
        }
        
        createdExpense = ProxyExpense(expenseName: expenseName.text!, expenseAmount: (Decimal(string: amount.text!) as NSDecimalNumber?)!, expenseDate: expenseDatePicker?.date as NSDate?, expenseCategory: categoryTextField.text!, isRecurring: recurringExpenseSwitch.isOn, recurringFrequency: frequency.text!)
        
    }
    //-- Only allow for segue to continue if validation passes
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
    
    //MARK: Switch Toggled
    @IBAction func switchToggled(_ sender: UISwitch) {
        if (sender.isOn){
            frequency.isEnabled = true
        }else{
            frequency.text = ""
            frequency.isEnabled = false
        }
    }
}

