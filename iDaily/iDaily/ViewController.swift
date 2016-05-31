//
//  ViewController.swift
//  iDaily
//
//  Created by P. Chu on 5/31/16.
//  Copyright © 2016 Poodar. All rights reserved.
//

import UIKit

let itemHeight: CGFloat = 150.0    //cell的高度
let itemWidth: CGFloat = 60.0
let collectionViewWidth = itemWidth * 3 //每行显示3个cell

class ViewController: UICollectionViewController {

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let yearLayout = iDailyLayout()
        
        yearLayout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        self.collectionView?.setCollectionViewLayout(yearLayout, animated: false)
        self.collectionView!.frame = CGRect(x: 0, y: 0, width: collectionViewWidth, height: itemHeight)
        self.collectionView!.center = CGPoint(x: self.view.frame.size.width/2.0, y: self.view.frame.size.height/2.0)
        
        self.collectionView?.backgroundColor = UIColor.whiteColor()
        self.view.backgroundColor = UIColor.whiteColor()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> HomeYearCollectionViewCell
    {
        
        let identifier = "HomeYearCollectionViewCell"
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath) as! HomeYearCollectionViewCell
        
        cell.textInt = 2015
        cell.labelText = "二零一五 年"
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAtIndex section: Int) -> UIEdgeInsets
    {
        
        let leftRightMagrin = (collectionViewWidth - itemWidth)/2
        return UIEdgeInsetsMake(0, leftRightMagrin, 0, leftRightMagrin)
    }
}

