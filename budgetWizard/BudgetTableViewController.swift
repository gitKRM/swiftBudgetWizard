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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getBudgets()
    }
    
    //MARK: load from DB
    func getBudgets(){
        let fetchRequest: NSFetchRequest<Budget> = Budget.fetchRequest()
        
        do{
            let budget = try PersistenceService.context.fetch(fetchRequest)
            self.budgets = budget
        }catch{
            os_log("Error getting budget information from DB", log: OSLog.default, type: .error)
        }
        
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
        let dayDateFormatter = DateFormatter()
        dayDateFormatter.dateFormat = "EEEE"
        cell.dayName.text = dayDateFormatter.string(from: budget.startDate! as Date)
        //Get day number as int
        let calendar = Calendar.current
        let dayNum = calendar.component(.day, from: budget.startDate! as Date)
        cell.dayNum.text = String(describing: dayNum)
        //Get month name
        let monthDateFormatter = DateFormatter()
        monthDateFormatter.dateFormat = "LLLL"
        cell.monthName.text = monthDateFormatter.string(from: budget.startDate! as Date)
        
        let endDateFormatter = DateFormatter()
        endDateFormatter.dateFormat = "dd/MM/yyyy"
        cell.toDate.text = endDateFormatter.string(from: budget.endDate! as Date)
        return cell
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    

    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? ""){
            
        case "AddBudget": break
            
        case "ShowBudgetDetails":
            guard let budgetViewController = segue.destination as? BudgetViewController else{
                fatalError("Unexpected destination -- could not find \(segue.destination)")
            }
            guard let selectedBudgetCell = sender as? BudgetTableViewCell else{
                fatalError("Unexpected sender:")
            }
            guard let indexPath = tableView.indexPath(for: selectedBudgetCell) else{
                fatalError("Index out of range for selected table cell")
            }
            let selectedBudget = budgets[indexPath.row]
            budgetViewController.selectedBudget = selectedBudget
            break
            
        default:
            fatalError("Unexpected segue identifier: \(String(describing: segue.identifier))")
            break            
        }
    }
 

}
