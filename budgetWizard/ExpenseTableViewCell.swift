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
    @IBOutlet weak var Category: UILabel!
    @IBOutlet weak var Name: UILabel!
    @IBOutlet weak var ExpenditureDate: UILabel!
    @IBOutlet weak var Amount: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
