//
//  Summary2ViewController.swift
//  budgetWizard
//
//  Created by Kent McNamara on 17/07/19.
//  Copyright © 2019 Kent McNamara. All rights reserved.
//

import UIKit

class Summary2ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    lazy var menuBar: MenuBar = {
        let mb = MenuBar()
        mb.summaryController = self
        return mb
    }()
    
    let cellId = ["pieChart", "barChart", "lineChart"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMenuBar()
        
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
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ci, for: indexPath)
        
        let colors = [UIColor.blue, UIColor.green, UIColor.red]
        
        cell.backgroundColor = colors[indexPath.item]
    
        return cell
    }

    //:Mark Cell Sizing
    //--sets cell to take up entire width and height of collection view
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout{
            layout.itemSize = CGSize(width: view.frame.width, height: view.frame.height)
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
            return
        }
        let indexPath = IndexPath(item: menuIndex, section: 0)
        collectionView.scrollToItem(at: indexPath, at: [], animated: true)
    }
}
