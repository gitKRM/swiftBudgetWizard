//
//  SummaryViewColors.swift
//  budgetWizard
//
//  Created by Kent McNamara on 13/07/19.
//  Copyright © 2019 Kent McNamara. All rights reserved.
//

import Foundation
import UIKit

extension UIColor{
    private static var colorArray = [UIColor]()
    
    static func loadColors(){
        
        colorArray.append(UIColor(named: "DarkLime")!)
        colorArray.append(UIColor(named: "Desert")!)
        colorArray.append(UIColor(named: "Grass")!)
        colorArray.append(UIColor(named: "HotPink")!)
        colorArray.append(UIColor(named: "MyBlue")!)
        colorArray.append(UIColor(named: "MyGreen")!)
        colorArray.append(UIColor(named: "MyLightPurple")!)
        colorArray.append(UIColor(named: "MyLime")!)
        colorArray.append(UIColor(named: "MyPeach")!)
        colorArray.append(UIColor(named: "MyOrange")!)
        colorArray.append(UIColor(named: "MyYellow")!)
        colorArray.append(UIColor(named: "NiceBlue")!)
        colorArray.append(UIColor(named: "PaleBlue")!)
        colorArray.append(UIColor(named: "PastalPink")!)
        colorArray.append(UIColor(named: "SkyBlue")!)
        colorArray.append(UIColor(named: "Violet")!)
    }
    
    static func getColors() -> [UIColor] {return colorArray}
}
