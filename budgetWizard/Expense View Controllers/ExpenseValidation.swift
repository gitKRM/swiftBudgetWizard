//
//  ExpenseValidation.swift
//  budgetWizard
//
//  Created by Kent McNamara on 13/07/19.
//  Copyright © 2019 Kent McNamara. All rights reserved.
//

import Foundation
import UIKit

extension ExpenseViewController{
    
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
}
