//
//  BudgetTableViewController.swift
//  budgetWizard
//
//  Created by Kent McNamara on 2/06/19.
//  Copyright © 2019 Kent McNamara. All rights reserved.
//

import UIKit
import CoreData
import os.log

class BudgetTableViewController: UITableViewController {

    //MARK: Properties
    var budgets = [Budget]()
    var budget: Budget?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = editButtonItem
        self.budgets = PersistenceService.getBudgets()!
    }
    

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return budgets.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "BudgetTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? BudgetTableViewCell else{
            fatalError("Could not downcast custom cell to BudgetViewTableCell")
        }
        
        //Get day namee
        let budget = budgets[indexPath.row]
        cell.budgetName.text = budget.budgetName
        cell.dayName.text = CustomDateFormatter.getDatePropertyAsString(formatSpecifier: "EEEE", date: budget.startDate)
        cell.dayNum.text = String(describing: CustomDateFormatter.getDayName(date: budget.startDate))
        //Get month name
        cell.monthName.text = CustomDateFormatter.getDatePropertyAsString(formatSpecifier: "LLLL", date: budget.endDate)
        
        cell.addEditExpense.tag = indexPath.row
        return cell
    }
    
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let budget = budgets[indexPath.row]
            budgets.remove(at: indexPath.row)
            PersistenceService.delete(budget: budget)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            //tableView.reloadRows(at: [indexPath], with: .automatic)
        } else if editingStyle == .insert {
          
        }    
    }
    

    // MARK: - Navigation
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? ""){
            
        case "AddBudget": break
            
        case "ShowBudgetDetails":
            guard let budgetViewController = segue.destination as? BudgetViewController else{
                fatalError("Unexpected destination -- could not find \(segue.destination)")
            }
            guard let selectedBudgetCell = sender as? BudgetTableViewCell else{
                fatalError("No cell selected:")
            }
            guard let indexPath = tableView.indexPath(for: selectedBudgetCell) else{
                fatalError("Index out of range for selected table cell")
            }
            let selectedBudget = budgets[indexPath.row]
            budgetViewController.selectedBudget = selectedBudget
            break
        case "AddEditExpense":
            guard let expenseTableViewController = segue.destination as? ExpenseTableViewController else{
                fatalError("Unrecognised destination \(segue.destination)")
            }
            guard let selectedBudgetButtonCell = sender as? UIButton else{
                fatalError("No cell selected")
            }
            
            let selectedBudget = budgets[selectedBudgetButtonCell.tag]
            expenseTableViewController.budget = selectedBudget
            break
        default:
            fatalError("Unexpected segue identifier: \(String(describing: segue.identifier))")
            break            
        }
    }
    
    @IBAction func unwindToBudgetTableView(sender: UIStoryboardSegue){
        if let sourceController = sender.source as? BudgetViewController, let
            proxyBudget = sourceController.createdBudget{
            
         //--Edit existing
            if let selectedBudget = tableView.indexPathForSelectedRow{
                let budget = PersistenceService.edit(budget: proxyBudget, existingBudget: budgets[selectedBudget.row])
                budgets[selectedBudget.row] = budget
                tableView.reloadRows(at: [selectedBudget], with: .none)
            }else {
                //Add new budget
                let budget = PersistenceService.save(budget: proxyBudget)
                //save recurring expenses against budget if any exist
                let expenses = PersistenceService.getRecurringExpenses()
                expenses.forEach { e in
                    let proxyExpense = ProxyExpense(expenseName: e.expenseName, expenseAmount: e.amount, expenseDate: CustomDateFormatter.addDayMonthToCurrentDate(expense: e) as NSDate, expenseCategory: e.expenseCategory, payed: e.payed, isRecurring: true, frequency: e.frequency)
                    proxyExpense!.addBudget(budget: budget)
                    _ = PersistenceService.save(expense: proxyExpense!)
                }
                let indexPath = IndexPath(row: budgets.count, section: 0)
                budgets.append(budget)
                tableView.insertRows(at: [indexPath], with: .automatic)
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
            
        }
        
    }

}
