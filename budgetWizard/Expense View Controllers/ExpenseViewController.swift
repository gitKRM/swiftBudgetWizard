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
    
    //MARK: Private Properties
    private var expenseDatePicker: UIDatePicker?
    
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
            amount.text = CustomNumberFormatter.getNumberAsString(number: selectedExpense.amount! as NSDecimalNumber)
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
    
    //MARK: Validation
    func validateForSave()-> Bool{
        var errorMsg = ""
        if (categoryTextField.text!.isEmpty){
            errorMsg = "Expense Category Must Be Selected\n\n"
        }
        if (expenseName.text!.isEmpty){
            if (errorMsg.isEmpty){
                errorMsg = "Expense Name Must Be Entered\n\n"
            }else{
                errorMsg = errorMsg + "Expense Name Must Be Entered\n\n"
            }
        }
        let expenseAmount: Decimal? = Decimal(string: amount.text!)
        if (expenseAmount == nil){
            if (errorMsg.isEmpty){
                errorMsg = "Expense Amount Must Be Entered\n\n"
            }else{
                errorMsg = errorMsg + "Expense Amount Must Be Entered\n\n"
            }
        }
        let validExpenseDate = CustomDateFormatter.getDatePropertyFromString(formatSpecifier: "dd/MM/yyyy", date: expenseDate.text)
        if (validExpenseDate == nil){
            errorMsg += "\nInvalid Start Date"
        }
        
        if (!errorMsg.isEmpty){
            let alert = UIAlertController(title: "Validation Error", message: errorMsg, preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alert.addAction(alertAction)
            self.present(alert, animated: true, completion: nil)
        }
        return errorMsg.isEmpty
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
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        
//    }
    
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
