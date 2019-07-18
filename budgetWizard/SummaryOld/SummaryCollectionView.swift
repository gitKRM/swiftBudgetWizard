//
//  SummaryCollectionView.swift
//  budgetWizard
//
//  Created by Kent McNamara on 14/07/19.
//  Copyright © 2019 Kent McNamara. All rights reserved.
//

import Foundation
import UIKit
import Charts

extension SummaryViewController:  UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionCellIdentifiers[indexPath.row]!, for: indexPath)
        
        return cell
        
    }
    
}
