//
//  ExpenseTableViewController.swift
//  budgetWizard
//
//  Created by Kent McNamara on 18/06/19.
//  Copyright © 2019 Kent McNamara. All rights reserved.
//

import UIKit
import CoreData
import os.log

class ExpenseTableViewController: UITableViewController {

    //MARK: Proeprties
    var expenses = [Expenses]()
    var recurringExpenses = [RecurringExpense]()
    var expense: Expenses?
    var budget: Budget?
    let cellIdentifier = "ExpenseTableViewCell"
   
    override func viewDidLoad() {
        super.viewDidLoad()
        getExpenses()
    }
    
    //MARK: Get Expenses from DB
    func getExpenses(){
        recurringExpenses = PersistenceService.getRecurringExpenseAsArray()!
        expenses = PersistenceService.getExpenseAsArray(budget: budget)
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0){
            return recurringExpenses.count
        }else{
            return expenses.count
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ExpenseTableViewCell else{
            fatalError("Unidentified cell")
        }
        if (indexPath.section == 0){
            let recurringExpense = recurringExpenses[indexPath.row]
            
            cell.dayName.text = CustomDateFormatter.getDatePropertyAsString(formatSpecifier: "EEEE", date: recurringExpense.expenseDate)
            cell.dayNum.text = String(describing: CustomDateFormatter.getDayName(date: recurringExpense.expenseDate))
            cell.monthName.text = CustomDateFormatter.getDatePropertyAsString(formatSpecifier: "LLLL", date: recurringExpense.expenseDate)
            cell.ExpenseAmount.text = CustomNumberFormatter.getNumberFormattedAsCurrency(amount: recurringExpense.amount)
            cell.Name.text = recurringExpense.expenseName
            cell.recurringExpense.text = "Recurring"
            cell.setCellBackgroundColor(color1: UIColor(named: "NiceBlue")!, color2: UIColor(named: "MyBlue")!)
        }
        else{
            let expense = expenses[indexPath.row]
            
            cell.dayName.text = CustomDateFormatter.getDatePropertyAsString(formatSpecifier: "EEEE", date: expense.expenseDate)
            cell.dayNum.text = String(describing: CustomDateFormatter.getDayName(date: expense.expenseDate))
            cell.monthName.text = CustomDateFormatter.getDatePropertyAsString(formatSpecifier: "LLLL", date: expense.expenseDate)
            cell.ExpenseAmount.text = CustomNumberFormatter.getNumberFormattedAsCurrency(amount: expense.amount)
            cell.Name.text = expense.expenseName
            
            if (expense.expenseCategory != "Future Bill"){
                cell.setCellBackgroundColor(color1: UIColor(named: "NiceBlue")!, color2: UIColor(named: "MyBlue")!)
            }else{
                if (!expense.payed){
                    cell.setCellBackgroundColor(color1: UIColor(named: "Desert")!, color2: UIColor(named: "NiceBlue")!, color3: UIColor(named: "DarkLime")!)
                }else{
                    cell.setCellBackgroundColor(color1: UIColor(named: "MyGreen")!, color2: UIColor(named: "SkyBlue")!, color3: UIColor(named: "DarkLime")!)
                }
                
            }
            
        }
        return cell
    }
    

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if (indexPath.section == 0){
                let recurringExpense = recurringExpenses[indexPath.row]
                recurringExpenses.remove(at: indexPath.row)
                PersistenceService.delete(recurringExpense: recurringExpense)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }else{
                let expense = expenses[indexPath.row]
                expenses.remove(at: indexPath.row)
                PersistenceService.delete(expense: expense)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            
        } else if editingStyle == .insert {
            
        }    
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: .destructive, title: "Delete", handler: {(action, indexPath) in
            
            if (indexPath.section == 0){
                let recurringExpense = self.recurringExpenses[indexPath.row]
                self.recurringExpenses.remove(at: indexPath.row)
                PersistenceService.delete(recurringExpense: recurringExpense)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }else{
                let expense = self.expenses[indexPath.row]
                self.expenses.remove(at: indexPath.row)
                PersistenceService.delete(expense: expense)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            
        })
        
        let pay = UITableViewRowAction(style: .default, title: "Pay", handler: {(action, indexPath) in
            var expense = self.expenses[indexPath.row]
            if (expense.expenseCategory != "Future Bill"){
                return
            }
            
            
            let proxyExpense = ProxyExpense(expenseName: expense.expenseName, expenseAmount: expense.amount, expenseDate: expense.expenseDate, expenseCategory: expense.expenseCategory, payed: true, isRecurring: false)
            
            expense = PersistenceService.edit(expense: proxyExpense!, existingExpense: self.expenses[indexPath.row])
            self.expenses[indexPath.row] = expense
            tableView.reloadRows(at: [indexPath], with: .none)
            
            
            //expense = PersistenceService.edit(expense: proxyExpense!, existingExpense: expense)
            //tableView.reloadData()
        })
        
        pay.backgroundColor = UIColor.green
        return [pay,delete]
    }
    
    @objc func updateSelectedExpensePayed(){
        
    }

    // MARK: - Navigation
    
    @IBAction func unwindToExpenseTableView(sender: UIStoryboardSegue){
        
        if let sourceViewController = sender.source as? ExpenseViewController, let
            proxyRecurringExpense = sourceViewController.createdRecurringExpense{
            
            if let selectedExpense = tableView.indexPathForSelectedRow{
                let recurringExpense = PersistenceService.edit(recurringExpense: proxyRecurringExpense, existingRecurringExpense: recurringExpenses[selectedExpense.row])
                recurringExpenses[selectedExpense.row] = recurringExpense
                tableView.reloadRows(at: [selectedExpense], with: .none)
            }else{
                let expense = PersistenceService.save(recurringExpense: proxyRecurringExpense)
                let indexPath = IndexPath(row: recurringExpenses.count, section: 0)
                recurringExpenses.append(expense)
                tableView.insertRows(at: [indexPath], with: .automatic)
            }
        }
    
        if let sourceViewController = sender.source as? ExpenseViewController, let
            proxyExpense = sourceViewController.createdExpense{
            
            //--Add budget to proxy expense
            proxyExpense.addBudget(budget: budget!)
            
            //--Editing
            if let selectedExpense = tableView.indexPathForSelectedRow{
                let expense = PersistenceService.edit(expense: proxyExpense, existingExpense: expenses[selectedExpense.row])
                expenses[selectedExpense.row] = expense
                tableView.reloadRows(at: [selectedExpense], with: .none)
            }
            else{
                //--Creating new
                let expense = PersistenceService.save(expense: proxyExpense)
                let indexPath = IndexPath(row: expenses.count, section: 1)
                expenses.append(expense)
                tableView.insertRows(at: [indexPath], with: .automatic)
            }
            
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? ""){
        case "btnAddExpense": break
           
        case "EditExpense":
            guard let expenseViewController = segue.destination as? ExpenseViewController else{
                fatalError("Unrecognised destination: \(segue.destination)")
            }
            guard let selectedExpenseCell = sender as? ExpenseTableViewCell else{
                fatalError("Unexpected table cell selected in expense table")
            }
            guard let indexPath = tableView.indexPath(for: selectedExpenseCell) else{
                fatalError("Could not determine index path for selected cell")
            }
            if (indexPath.section == 0){
                let selectedRecurringExpense = recurringExpenses[indexPath.row]
                expenseViewController.selectedRecurringExpense = selectedRecurringExpense
            }else{
                let selectedExpense = expenses[indexPath.row]
                expenseViewController.selectedExpense = selectedExpense
            }
            break
            
        default:
            fatalError("Unknown segue identifier \(String(describing: segue.identifier))")
                break
        }
        
    }
}
