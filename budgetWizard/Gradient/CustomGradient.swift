//
//  CustomGradient.swift
//  budgetWizard
//
//  Created by Kent McNamara on 4/08/19.
//  Copyright © 2019 Kent McNamara. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func setGradientBackground(colour1: UIColor, colour2: UIColor){
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [colour1.cgColor,colour2.cgColor]
        gradientLayer.locations = [0.0,1.0]
        gradientLayer.startPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.0)
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func setGradientBackground(colour1: UIColor, colour2: UIColor, colour3: UIColor){
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [colour1.cgColor,colour2.cgColor, colour3.cgColor]
        gradientLayer.locations = [0.33, 0.66, 1.0]
        gradientLayer.startPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.0)
        layer.insertSublayer(gradientLayer, at: 0)
    }
}
