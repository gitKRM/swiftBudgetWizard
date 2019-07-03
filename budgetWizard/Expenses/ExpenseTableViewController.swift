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
   
    override func viewDidLoad() {
        super.viewDidLoad()
        getExpenses()

    }
    
    //MARK: Get Expenses from DB
    func getExpenses(){
        
        if let existingExpenses = budget?.expenses{
            navigationItem.title = budget?.budgetName
            //let enumerator: NSEnumerator = budget!.expenses!.objectEnumerator()
            let enumerator: NSEnumerator = existingExpenses.objectEnumerator()
            while let value = enumerator.nextObject(){
                expenses.append(value as! Expenses)
            }
        }        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return expenses.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "ExpenseTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ExpenseTableViewCell else{
            fatalError("Unidentified cell")
        }

        let expense = expenses[indexPath.row]
        
        cell.dayName.text = CustomDateFormatter.getDatePropertyAsString(formatSpecifier: "EEEE", date: expense.expenseDate)
        cell.dayNum.text = String(describing: CustomDateFormatter.getDayName(date: expense.expenseDate))
        cell.monthName.text = CustomDateFormatter.getDatePropertyAsString(formatSpecifier: "LLLL", date: expense.expenseDate)
        cell.ExpenseAmount.text = CustomNumberFormatter.getNumberFormattedAsCurrency(amount: expense.amount!)
        cell.Name.text = expense.expenseName
        
        return cell
    }
    

    
    // Override to support conditional editing of the table view.
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
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
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
                tableView.reloadRows(at: [selectedExpense], with: .none)
            }
            else{
                //--Creating new
                let expense = PersistenceService.save(expense: proxyExpense)
                let indexPath = IndexPath(row: expenses.count, section: 0)
                expenses.append(expense)
                tableView.insertRows(at: [indexPath], with: .automatic)
            }
        
        }
        
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
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
