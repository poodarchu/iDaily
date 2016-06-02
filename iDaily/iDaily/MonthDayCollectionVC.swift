//
//  MonthDayCollectionVC.swift
//  iDaily
//
//  Created by P. Chu on 5/31/16.
//  Copyright © 2016 Poodar. All rights reserved.
//

import UIKit
import CoreData

class MonthDayCollectionVC: UICollectionViewController, NSFetchedResultsControllerDelegate, UIGestureRecognizerDelegate {
    
    var diaries = [NSManagedObject]()
    
    var month: Int!
    
    var year: Int!
    var yearLabel: UILabel!
    
    var composeButton: UIButton!
    
    var monthLabel: iDailyLabel!
    
    var fetchedResultsController : NSFetchedResultsController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mDoubleUpRecognizer = UITapGestureRecognizer(target: self, action: #selector(MonthDayCollectionVC.hideDiary))
        mDoubleUpRecognizer.delegate = self
        mDoubleUpRecognizer.numberOfTapsRequired = 2
        self.view.addGestureRecognizer(mDoubleUpRecognizer)
        
        
        
        do {
            let fetchRequest = NSFetchRequest(entityName:"PDDiary")
            print("year = \(year) AND month = \(month)")
            
            //月的查询略有变化，增加了确切的年份和月份
            fetchRequest.predicate = NSPredicate(format: "year = \(year) AND month = \(month)")
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "create_date", ascending: true)]
            fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedContext, sectionNameKeyPath: "year", cacheName: nil)
            
            fetchedResultsController.delegate = self
            
            try fetchedResultsController.performFetch()
            
            diaries = fetchedResultsController.fetchedObjects as! [NSManagedObject]
        } catch _ {
            
        }
        print("This month have \(diaries.count) \n", terminator: "")
        
        
        yearLabel = iDailyLabel(fontName: "WenYue-XinQingNianTi-NC-W8", labelText: "\(numToChinese(year))年", fontSize: 22.0,lineHeight: 5.0)
        yearLabel.center = CGPointMake(screenRect.width - yearLabel.frame.size.width/2.0 - 15, 70 + yearLabel.frame.size.height/2.0)
        yearLabel.userInteractionEnabled = true
        self.view.addSubview(yearLabel)

//        let mTapUpRecognizer = UITapGestureRecognizer(target: self, action:"backToHome")
//        mTapUpRecognizer.numberOfTapsRequired = 1
//        yearLabel.addGestureRecognizer(mTapUpRecognizer)
        
        //Add compose button
        composeButton = btnWith(text: "记",  fontSize: 14.0,  width: 40.0,  normalImgNm: "Oval", highlightedImgNm: "Oval_pressed")
        composeButton.center = CGPointMake(screenRect.width - yearLabel.frame.size.width/2.0 - 15, 86 + yearLabel.frame.size.height + 26.0/2.0)
        composeButton.addTarget(self, action:#selector(MonthDayCollectionVC.newCompose), forControlEvents: UIControlEvents.TouchUpInside)
        
        self.view.addSubview(composeButton)
        
        //
        monthLabel = iDailyLabel(fontName: "WenYue-XinQingNianTi-NC-W8", labelText: "\(numToChineseWithUnit(month)) 月", fontSize: 16.0,lineHeight: 5.0)
        monthLabel.frame = CGRectMake(screenRect.width - 15.0 - monthLabel.frame.size.width, (screenRect.height - 150)/2.0, monthLabel.frame.size.width, monthLabel.frame.size.height)
        
        monthLabel.center = CGPointMake(composeButton.center.x, monthLabel.center.y + 28)
        
        monthLabel.updateLabelColor(YAMABUKI)
        monthLabel.userInteractionEnabled = true
        
//        let mmTapUpRecognizer = UITapGestureRecognizer(target: self, action:"backToYear")
//        mmTapUpRecognizer.numberOfTapsRequired = 1
//        monthLabel.addGestureRecognizer(mmTapUpRecognizer)
        
        self.view.addSubview(monthLabel)
        
        
        let yearLayout = iDailyLayout()
        
        yearLayout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        self.collectionView?.setCollectionViewLayout(yearLayout, animated: false)
        
        self.collectionView?.frame = CGRect(x:0, y:0, width:
            collectionViewWidth, height: itemHeight)
        self.collectionView?.center = CGPoint(x: self.view.frame.size.width/2.0, y: self.view.frame.size.height/2.0)
        
        self.collectionView?.showsHorizontalScrollIndicator = false
        self.collectionView?.showsVerticalScrollIndicator = false
        
        self.view.backgroundColor = UIColor.whiteColor()
        self.collectionView?.backgroundColor = UIColor.whiteColor()
    }
    
    func newCompose() {
        let composeViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PDComposeVC") as! PDComposeVC
        
        self.presentViewController(composeViewController, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return diaries.count
    }
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        let leftRightMagrin = (collectionViewWidth - itemWidth)/2
        return UIEdgeInsetsMake(0, leftRightMagrin, 0, leftRightMagrin);
    }
    
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("iDailyCollectionViewCell", forIndexPath: indexPath) as! iDailyCollectionViewCell
        
        let diary = fetchedResultsController.objectAtIndexPath(indexPath) as! PDDiary
        
        if let title = diary.title {
            cell.labelText = title
        } else {
            cell.labelText = "\(numToChineseWithUnit(NSCalendar.currentCalendar().component(NSCalendarUnit.Day, fromDate: diary.create_date))) 日"
        }
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let vcID = "PDDiaryVC"
        let dvc = self.storyboard?.instantiateViewControllerWithIdentifier(vcID) as! PDDiaryVC
        
        let diary = fetchedResultsController.objectAtIndexPath(indexPath) as! PDDiary
        
        dvc.diary = diary
        
        self.navigationController!.pushViewController(dvc, animated: true)
        
    }
    
    //Notifies the receiver that 
    //the fetched results controller has completed processing of 
    //one or more changes due to an add, remove, move, or update.
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        diaries = fetchedResultsController.fetchedObjects as! [NSManagedObject]
        collectionView?.reloadData()
        self.collectionView?.setCollectionViewLayout(iDailyLayout(), animated: false)
    }
    
    func hideDiary() {
        self.navigationController?.popViewControllerAnimated(true)
    }
}