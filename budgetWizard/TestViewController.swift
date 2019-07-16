//
//  TestViewController.swift
//  budgetWizard
//
//  Created by Kent McNamara on 14/07/19.
//  Copyright © 2019 Kent McNamara. All rights reserved.
//

import UIKit
import Charts

class TestViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    var cellIdentifiers = [Int: String]()   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cellIdentifiers[0] = "cell1"
        cellIdentifiers[1] = "cell2"
        cellIdentifiers[2] = "cell3"
        
        SetupMenuBar()
    }
    
    let menuBar: MenuBar = {
        let mb = MenuBar()
        return mb
    }()
    
    private func SetupMenuBar(){
        view.addSubview(menuBar)
        view.addContraintsWithFormat("H:|[v0]|", views: menuBar)
        view.addContraintsWithFormat("V:|-40-[v0(50)]-40-|", views: menuBar)
    }

   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let ci = cellIdentifiers[indexPath.item]
        
        
       let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ci!, for: indexPath) as! TestCollectionViewCell
        
        if ((ci?.elementsEqual("cell1"))! || (ci?.elementsEqual("cell2"))! || (ci?.elementsEqual("cell3"))!){
            cell.setChart()
            cell.myLabel.text = ci
        }
        
       return cell
        
    }
    
}


extension UIView{
    
    func addContraintsWithFormat(_ format: String, views: UIView...) {
        var viewDict = [String: UIView]()
        
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewDict[key] = view
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: viewDict))
    }
}

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

