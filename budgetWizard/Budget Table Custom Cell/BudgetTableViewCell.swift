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
    @IBOutlet weak var budgetName: UILabel!
    @IBOutlet weak var dayName: UILabel!
    @IBOutlet weak var dayNum: UILabel!
    @IBOutlet weak var monthName: UILabel!
    @IBOutlet weak var addEditExpense: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: true)
        self.setGradientBackground(colour1: UIColor(named: "NiceBlue")!, colour2: UIColor(named: "MyBlue")!)
    }
    
}

@IBDesignable extension UIButton {
    
    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        set {
            guard let uiColor = newValue else { return }
            layer.borderColor = uiColor.cgColor
        }
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
}
