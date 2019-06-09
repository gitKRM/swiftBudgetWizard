//
//  BudgetTableViewCell.swift
//  budgetWizard
//
//  Created by Kent McNamara on 9/06/19.
//  Copyright © 2019 Kent McNamara. All rights reserved.
//

import UIKit

class BudgetTableViewCell : UITableViewCell{
    //MARK: Properties
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var fromDateLabel: UILabel!
    @IBOutlet weak var toDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: true)
    }
    
}
