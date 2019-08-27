//
//  Summary2ViewController.swift
//  budgetWizard
//
//  Created by Kent McNamara on 17/07/19.
//  Copyright © 2019 Kent McNamara. All rights reserved.
//

import UIKit

class SummaryViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    //MARK: Properties
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var selectedBudgetTxtField: UITextField!
    var budgets = [Budget]()
    var budgetItems: [String] = []
    var selectedBudgetRow = 0
    var selectedCategoryRow = 0
    var pickerData: [[String]] = [[String]]()
    var budgetPicker = UIPickerView()
    var currentPickerIndexPath: IndexPath!
    static var cell: SummaryChartsCollectionCell?
    
    lazy var menuBar: MenuBar = {
        let mb = MenuBar()
        mb.summaryController = self
        return mb
    }()
    
    let cellId = ["pieChart", "barChart", "lineChart"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIColor.loadColors()
        selectedBudgetTxtField.delegate = self
        createBudgetPickerView()
        createBudgetPickerToolBar()
        setupMenuBar()
        self.view.setGradientBackground(colour1: UIColor.white, colour2: UIColor(named: "MyBlue")!)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        LoadBudgets()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    func setupMenuBar(){
        //--Bar behind the time & reception -- used to controll colouring
        let topBar = UIView()
        topBar.backgroundColor = UIColor.black
        view.addSubview(topBar)
        topBar.translatesAutoresizingMaskIntoConstraints = false

        topBar.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        topBar.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        topBar.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1).isActive = true
        topBar.heightAnchor.constraint(equalToConstant: 40).isActive = true
        view.addContraintsWithFormat("H:[v0]|", views: topBar)
        view.addContraintsWithFormat("V:|[v0(50)]|", views: topBar)
        //--Menu Bar with Icons
        
        view.addSubview(menuBar)
        view.addContraintsWithFormat("H:|[v0]|", views: menuBar)
        view.addContraintsWithFormat("V:|-40-[v0(50)]-40-|", views: menuBar)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let ci = cellId[indexPath.item]
       
        SummaryViewController.cell = collectionView.dequeueReusableCell(withReuseIdentifier: ci, for: indexPath) as? SummaryChartsCollectionCell
        
        SummaryViewController.cell!.setGradientBackground(colour1: UIColor.white, colour2: UIColor(named: "MyBlue")!)
        
        switch(ci){
        case "pieChart":
            SummaryViewController.cell!.updatePieChart()

        case "barChart":
            SummaryViewController.cell!.updateBarChart()

        case "lineChart":
            SummaryViewController.cell!.updateLineChart()
        default:
            return SummaryViewController.cell!
        }
        
        return SummaryViewController.cell!
    }

    //:Mark Cell Sizing
    //--sets cell to take up entire width and height of collection view
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout{
            layout.itemSize = CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
            layout.minimumLineSpacing = 0
            layout.invalidateLayout()
        }
    }
    
    //MARK: Horizontal bar
    //--sets the white horizontal menu bar when scrolling horizontally
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        menuBar.horizontalBarLeftAnchor?.constant = scrollView.contentOffset.x / 4
    }
    
    func scrollToMenuIndex(menuIndex: Int){
        if (menuIndex == 3) {
            selectedBudgetTxtField.becomeFirstResponder()
            if (currentPickerIndexPath == nil){
                if (budgets.count > 0){
                    budgetPicker.selectRow(selectedBudgetRow, inComponent: 0, animated: true)
                }
                
            }else{
                budgetPicker.selectRow(currentPickerIndexPath.row, inComponent: currentPickerIndexPath.section, animated: true)
            }
            return
        }
        let indexPath = IndexPath(item: menuIndex, section: 0)
        
        //--Below, if animated is set to true, this will be a spring effect which will come
        //--across as jerky as the horizontal bar will bounce back and forth
        collectionView.scrollToItem(at: indexPath, at: [], animated: false)
        
        let ci = cellId[indexPath.item]
        
        SummaryViewController.cell = collectionView.dequeueReusableCell(withReuseIdentifier: ci, for: indexPath) as? SummaryChartsCollectionCell
        
        SummaryViewController.cell!.backgroundColor = UIColor.darkGray
        
        switch(ci){
        case "pieChart":
            SummaryViewController.cell!.updatePieChart()
            
        case "barChart":
            SummaryViewController.cell!.updateBarChart()
            
        case "lineChart":
            SummaryViewController.cell!.updateLineChart()
        default:
            return
        }
        
    }
    //--Update Menu Cell Image colour when scroll from swipe
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let index = targetContentOffset.pointee.x / view.frame.width
        let indexPath = IndexPath(item: Int(index), section: 0)
        menuBar.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
    }
    
    func returnFromFilter(indexPath: IndexPath){
        menuBar.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
        switch(indexPath.item){
        case 0:
            menuBar.horizontalBarLeftAnchor?.constant = 0.0
            break
        case 1:
            menuBar.horizontalBarLeftAnchor?.constant = menuBar.horizontalBarLeftAnchor!.constant / 3
            return
        case 2:
            menuBar.horizontalBarLeftAnchor?.constant = ((menuBar.horizontalBarLeftAnchor!.constant / 3) * 2)
            return
        default:
            menuBar.horizontalBarLeftAnchor?.constant = 0.0
        }
    }
    
    //MARK:Load budgets
    func LoadBudgets(){
        budgetItems.removeAll()
        self.budgets = PersistenceService.getBudgets()!
        
        if (budgets.count > 0){
            budgets.forEach{b in
                budgetItems.append(b.budgetName!)
            }
                    
            pickerData = [budgetItems,ExpenseCategories.GetCategories()]
            
            selectedBudgetTxtField.text = pickerData[0][selectedBudgetRow] + " | " + pickerData[1][selectedCategoryRow]
            SummaryChartsCollectionCell.selectedBudgetTxtField = selectedBudgetTxtField.text
            SummaryChartsCollectionCell.budget = budgets[selectedBudgetRow]
        }
        
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


