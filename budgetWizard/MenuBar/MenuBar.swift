//
//  MenuBar.swift
//  budgetWizard
//
//  Created by Kent McNamara on 16/07/19.
//  Copyright © 2019 Kent McNamara. All rights reserved.
//

import UIKit

class MenuBar: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var horizontalBarLeftAnchor: NSLayoutConstraint?
    var preHorizontalBarLeftAnchor: NSLayoutConstraint?
    var summaryController: SummaryViewController?
    var originalMenuIndex: IndexPath?
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.black
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    let cellId = "cellId"
    let imageNames = ["pieChart","barChart","lineChart","filter"]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        collectionView.register(MenuCell.self, forCellWithReuseIdentifier: cellId)
        
        addSubview(collectionView)
        addContraintsWithFormat("H:|[v0]|", views: collectionView)
        addContraintsWithFormat("V:|[v0]|", views: collectionView)
        
        let selectedIndexPath = IndexPath(item: 0, section: 0)
        collectionView.selectItem(at: selectedIndexPath, animated: true, scrollPosition: [])
        originalMenuIndex = IndexPath(item: 0, section: 0)
        setupHorizontalBar()
    }
    
    func setupHorizontalBar(){
        let horizontalBarView = UIView()
        horizontalBarView.backgroundColor = UIColor.white
        addSubview(horizontalBarView)
        horizontalBarView.translatesAutoresizingMaskIntoConstraints = false
        
        horizontalBarLeftAnchor = horizontalBarView.leftAnchor.constraint(equalTo: self.leftAnchor)
        horizontalBarLeftAnchor?.isActive = true
        horizontalBarView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        horizontalBarView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1/4).isActive = true
        horizontalBarView.heightAnchor.constraint(equalToConstant: 4).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MenuCell
        
        cell.image.image = UIImage(named: imageNames[indexPath.item])?.withRenderingMode(.alwaysTemplate)
        cell.tintColor = UIColor.white
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //--Dont check if filter is being selected
        if (indexPath.item != 3){
            originalMenuIndex = indexPath
        }
        
        let x = CGFloat(indexPath.item) * frame.width / 4
        horizontalBarLeftAnchor?.constant = x
       
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.layoutIfNeeded()
        }, completion: nil)

        summaryController?.scrollToMenuIndex(menuIndex: indexPath.item)
        
    }
    
    //MARK:Cells
    //--Sets cell width
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width / 4, height: frame.height)
    }
    //--Removes all spacing between cells, will appear to be one single bar
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}

class MenuCell: UICollectionViewCell {
    
    let image: UIImageView = {
       
        let iv = UIImageView()
        iv.image = UIImage(named: "pieChart")?.withRenderingMode(.alwaysTemplate)
        iv.tintColor = UIColor.white
        return iv
    }()
    
    override var isHighlighted: Bool{
        didSet{
            image.tintColor = isHighlighted ? UIColor.green : UIColor.white
        }
    }
    
    override var isSelected: Bool{
        didSet{
            image.tintColor = isSelected ? UIColor.green : UIColor.white
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        SetupViews()
        
        addSubview(image)
        addContraintsWithFormat("H:[v0(28)]", views: image)
        addContraintsWithFormat("V:[v0(28)]", views: image)
        
        addConstraint(NSLayoutConstraint(item: image, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: image, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
    }
    
    func SetupViews(){
//        backgroundColor = UIColor(red: 67/255, green: 67/255, blue: 67/255, alpha: 1)
        backgroundColor = UIColor.black
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension UIColor{

    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIColor{
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
}
