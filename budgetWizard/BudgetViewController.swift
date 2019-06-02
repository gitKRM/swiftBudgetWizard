//
//  BudgetViewController.swift
//  budgetWizard
//
//  Created by Kent McNamara on 2/06/19.
//  Copyright © 2019 Kent McNamara. All rights reserved.
//

import UIKit

class BudgetViewController: UIViewController, UITextFieldDelegate {
    
    //MARK: Properties
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var incomingCashFlow: UITextField!
    @IBOutlet weak var startDate: UITextField!
    @IBOutlet weak var endDate: UITextField!
    
    
    
    //MARK: Private properties
    private var startDatePicker: UIDatePicker?
    private var endDatePicker: UIDatePicker?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //initialise date pickers for start / end date in code -- this hides the date picker once a date is selected
        startDatePicker = UIDatePicker()
        startDatePicker?.datePickerMode = .date
        startDatePicker?.addTarget(self, action: #selector(BudgetViewController.startDateChanged(startDatePicker:)), for: .valueChanged)
        startDate.inputView = startDatePicker
        
        endDatePicker = UIDatePicker()
        endDatePicker?.datePickerMode = .date
        endDatePicker?.addTarget(self, action: #selector(BudgetViewController.endDateChanged(endDatePicker:)), for: .valueChanged)
        endDate.inputView = endDatePicker
        
        let gestureRecogniser = UITapGestureRecognizer(target: self, action: #selector(BudgetViewController.viewTapped(gestureRecogniser:)))
        
        view.addGestureRecognizer(gestureRecogniser)
        
        // Do any additional setup after loading the view.
        nameTextField.delegate = self
        incomingCashFlow.delegate = self
        updateSaveButton()
    }
    
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
        if (textField == incomingCashFlow){
            let formatter = NumberFormatter()
            formatter.locale = Locale.autoupdatingCurrent
            formatter.numberStyle = .currency
            
            
        }
        updateSaveButton()
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
    
    //MARK: Private functions
    private func updateSaveButton(){
        let text = nameTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
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
    
    @objc func viewTapped(gestureRecogniser: UITapGestureRecognizer){
        view.endEditing(true)
    }

}
