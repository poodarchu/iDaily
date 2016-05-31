//
//  YearCollectionVC.swift
//  iDaily
//
//  Created by P. Chu on 5/31/16.
//  Copyright © 2016 Poodar. All rights reserved.
//

import UIKit

class YearCollectionVC: UICollectionViewController {
    var year: Int!
    
    var yearLabel: UILabel!
    
    var composeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        yearLabel = iDailyLabel(fontName: "WenYue-XinQingNianTi-NC-W8", labelText: "\(numToChinese(year))", fontSize: 22.0, lineHeight: 5.0)
        
        yearLabel.center = CGPointMake(screenRect.width - yearLabel.frame.size.width/2.0 - 15, yearLabel.frame.size.height/2.0 + 20)
        
        yearLabel.userInteractionEnabled = true
        
        let mTapUpRecognizer = UITapGestureRecognizer(target: self, action: "backToHome")
        mTapUpRecognizer.numberOfTapsRequired = 1
        yearLabel.addGestureRecognizer(mTapUpRecognizer)
        
        self.view.addSubview(yearLabel)
        
        
        composeButton = btnWith(text: "记", fontSize: 15.0, width: 40.0, normalImgNm: "Oval", highlightedImgNm: "Oval_pressed")
        composeButton.center = CGPointMake(screenRect.width - yearLabel.frame.size.width/2.0 - 15, yearLabel.frame.size.height + 26.0/2 + 38)
        composeButton.addTarget(self, action: "newCompose", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.view.addSubview(composeButton)
        
        
        let yearLayout = iDailyLayout()
        //设置年视图水平滚动
        yearLayout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        self.collectionView?.setCollectionViewLayout(yearLayout, animated: false)
        
        self.collectionView!.frame = CGRect(x: 0, y: 0, width: collectionViewWidth, height: itemHeight)
        self.collectionView!.center = CGPoint(x: self.view.frame.size.width/2.0, y: self.view.frame.size.height/2.0)
        
        self.view.backgroundColor = UIColor.whiteColor()
        self.collectionView?.backgroundColor = UIColor.whiteColor()
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        _ = collectionView.dequeueReusableCellWithReuseIdentifier("iDailyCollectionViewCell", forIndexPath: indexPath) as! iDailyCollectionViewCell
        
        let dvc = self.storyboard?.instantiateViewControllerWithIdentifier("MonthDayCollectionVC") as! MonthDayCollectionVC
        
        dvc.year = year
        dvc.month = 6
        
        self.navigationController!.pushViewController(dvc, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        let leftRightMargin = (collectionViewWidth - itemHeight)/2
        return UIEdgeInsetsMake(0, leftRightMargin, 0, leftRightMargin)
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cellID = "iDailyCollectionViewCell"
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellID, forIndexPath: indexPath) as! iDailyCollectionViewCell
        
        cell.labelText = "六 月"
        cell.textInt = 6
        
        return cell
    }
}
