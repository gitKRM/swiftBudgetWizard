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
    var expense: Expenses?
    var budget: Budget?
    let cellIdentifier = "ExpenseTableViewCell"
   
    override func viewDidLoad() {
        super.viewDidLoad()
        getExpenses()
    }
    
    //MARK: Get Expenses from DB
    func getExpenses(){
        expenses = PersistenceService.getExpenseAsArray(budget: budget)
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return expenses.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ExpenseTableViewCell else{
            fatalError("Unidentified cell")
        }
        
        let expense = expenses[indexPath.row]
        
        cell.dayName.text = CustomDateFormatter.getDatePropertyAsString(formatSpecifier: "EEEE", date: expense.expenseDate)
        cell.dayNum.text = String(describing: CustomDateFormatter.getDayName(date: expense.expenseDate))
        cell.monthName.text = CustomDateFormatter.getDatePropertyAsString(formatSpecifier: "LLLL", date: expense.expenseDate)
        cell.ExpenseAmount.text = CustomNumberFormatter.getNumberFormattedAsCurrency(amount: expense.amount)
        cell.Name.text = expense.expenseName
        cell.recurringExpense.text = expense.isRecurring ? "Recurring" : ""
        if (expense.expenseCategory != "Future Bill"){
            cell.setGradientBackground(colour1: UIColor(named: "NiceBlue")!, colour2: UIColor(named: "MyBlue")!)
        }else
        {
            if (!expense.payed){
                cell.setGradientBackground(colour1: UIColor(named: "Desert")!, colour2: UIColor(named: "NiceBlue")!, colour3: UIColor(named: "DarkLime")!)
            }
            else
            {
                cell.setGradientBackground(colour1: UIColor(named: "MyGreen")!, colour2: UIColor(named: "SkyBlue")!, colour3: UIColor(named: "DarkLime")!)
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
            let expense = expenses[indexPath.row]
            expenses.remove(at: indexPath.row)
            PersistenceService.delete(expense: expense)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        } else if editingStyle == .insert {
            
        }    
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: .destructive, title: "Delete", handler: {(action, indexPath) in
            
            let expense = self.expenses[indexPath.row]
            self.expenses.remove(at: indexPath.row)
            PersistenceService.delete(expense: expense)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        })
        
        let pay = UITableViewRowAction(style: .default, title: "Pay", handler: {(action, indexPath) in
            let expense = self.expenses[indexPath.row]
            if (expense.expenseCategory != "Future Bill" || expense.payed){
                return
            }
            
            let proxyExpense = ProxyExpense(expenseName: expense.expenseName, expenseAmount: expense.amount, expenseDate: expense.expenseDate, expenseCategory: expense.expenseCategory, payed: true, isRecurring: false, frequency: expense.frequency)
            
            proxyExpense!.addBudget(budget: self.budget!)
            
            let editedExpense = PersistenceService.edit(expense: proxyExpense!, existingExpense: self.expenses[indexPath.row])
            self.expenses[indexPath.row] = editedExpense
            tableView.reloadRows(at: [indexPath], with: .none)
      
        })
        
        pay.backgroundColor = UIColor.green
        return [pay,delete]
    }
    
    // MARK: - Navigation
    @IBAction func unwindToExpenseTableView(sender: UIStoryboardSegue){
    
        if let sourceViewController = sender.source as? ExpenseViewController, let
            proxyExpense = sourceViewController.createdExpense{
            
            //--Add budget to proxy expense
            proxyExpense.addBudget(budget: budget!)
            
            //--Editing
            if let selectedExpense = tableView.indexPathForSelectedRow{
                let expense = PersistenceService.edit(expense: proxyExpense, existingExpense: expenses[selectedExpense.row])
                expenses[selectedExpense.row] = expense
                tableView.reloadRows(at: [selectedExpense], with: .automatic)
            }
            else{
                //--Creating new
                let expense = PersistenceService.save(expense: proxyExpense)
                let indexPath = IndexPath(row: expenses.count, section: 0)
                expenses.append(expense)
                
                tableView.insertRows(at: [indexPath], with: .automatic)
                tableView.reloadRows(at: [indexPath], with: .automatic)
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
            let selectedExpense = expenses[indexPath.row]
            expenseViewController.selectedExpense = selectedExpense
            break
        default:
            fatalError("Unknown segue identifier \(String(describing: segue.identifier))")
                break
        }
        
    }
}
