//
//  ExpenseTableViewCell.swift
//  budgetWizard
//
//  Created by Kent McNamara on 19/06/19.
//  Copyright © 2019 Kent McNamara. All rights reserved.
//

import UIKit

class ExpenseTableViewCell: UITableViewCell {
    //MARK: Properties
    @IBOutlet weak var Name: UILabel!
    @IBOutlet weak var ExpenseAmount: UILabel!
    @IBOutlet weak var dayName: UILabel!
    @IBOutlet weak var dayNum: UILabel!
    @IBOutlet weak var monthName: UILabel!
    @IBOutlet weak var recurringExpense: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.setGradientBackground(colour1: UIColor(named: "NiceBlue")!, colour2: UIColor(named: "MyBlue")!)
    }

}
