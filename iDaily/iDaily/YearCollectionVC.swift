//
//  YearCollectionVC.swift
//  iDaily
//
//  Created by P. Chu on 5/31/16.
//  Copyright © 2016 Poodar. All rights reserved.
//

import UIKit
import CoreData

class YearCollectionVC: UICollectionViewController, UIGestureRecognizerDelegate {
    var year: Int!
    
    var yearLabel: UILabel!
    
    var diaries = [NSManagedObject]()
    
    var composeButton: UIButton!
    
    var fetchedResultsController: NSFetchedResultsController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mDoubleUpRecognizer = UITapGestureRecognizer(target: self, action: #selector(YearCollectionVC.hideDiary))
        mDoubleUpRecognizer.delegate = self
        mDoubleUpRecognizer.numberOfTapsRequired = 2
        self.view.addGestureRecognizer(mDoubleUpRecognizer)
        
//        self.clearsSelectionOnViewWillAppear = false
        
        let fetchRequest = NSFetchRequest(entityName: "PDDiary")
        let year = 2016
        let month = 6
        
        do  {
            let fetchedResults = try managedContext.executeFetchRequest(fetchRequest) as! [NSManagedObject]
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "create_date", ascending: true)] //排序方式
            fetchRequest.predicate = NSPredicate(format: "year = \(year) AND month = \(month)")
            
            fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedContext, sectionNameKeyPath: "month", cacheName: nil) //根据year来分 section
            
            try fetchedResultsController.performFetch()
            
            if fetchedResultsController.fetchedObjects!.count == 0 {
                print("Present empty year")
            } else {
                diaries = fetchedResults
            }
        } catch _ {
            print("Fetch Error")
        }
        
        // Register cell classes
        yearLabel = iDailyLabel(fontName: "WenYue-XinQingNianTi-NC-W8", labelText: "\(numToChinese(year))年", fontSize: 20.0,lineHeight: 5.0)
        yearLabel.center = CGPointMake(screenRect.width - yearLabel.frame.size.width/2.0 - 15, 70 + yearLabel.frame.size.height/2.0 )
        yearLabel.userInteractionEnabled = true
        
        let mTapUpRecognizer = UITapGestureRecognizer(target: self, action:Selector("backToHome"))
        mTapUpRecognizer.numberOfTapsRequired = 1
        yearLabel.addGestureRecognizer(mTapUpRecognizer)
        
        self.view.addSubview(yearLabel)
        
        //Add compose button
        composeButton = btnWith(text: "记",  fontSize: 14.0,  width: 40.0,  normalImgNm: "Oval", highlightedImgNm: "Oval_pressed")
        composeButton.center = CGPointMake(screenRect.width - yearLabel.frame.size.width/2.0 - 15, 86 + yearLabel.frame.size.height + 26.0/2.0)
        composeButton.addTarget(self, action:#selector(YearCollectionVC.newCompose), forControlEvents: UIControlEvents.TouchUpInside)
        
        self.view.addSubview(composeButton)
        
        
        let yearLayout = iDailyLayout()
        
        yearLayout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        self.collectionView?.setCollectionViewLayout(yearLayout, animated: false)
        
        self.collectionView!.frame = CGRect(x:0, y:0, width: collectionViewWidth, height: itemHeight)
        self.collectionView?.center = CGPoint(x: self.view.frame.size.width/2.0, y: self.view.frame.size.height/2.0)
        
        self.view.backgroundColor = UIColor.whiteColor()
        self.collectionView?.backgroundColor = UIColor.whiteColor()
    }
    
    func newCompose() {
        let composeVC = self.storyboard?.instantiateViewControllerWithIdentifier("PDComposeVC") as! PDComposeVC
        
        self.presentViewController(composeVC, animated: true, completion: nil)
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
//        _ = collectionView.dequeueReusableCellWithReuseIdentifier("iDailyCollectionViewCell", forIndexPath: indexPath) as! iDailyCollectionViewCell
        
        let dvc = self.storyboard?.instantiateViewControllerWithIdentifier("MonthDayCollectionVC") as! MonthDayCollectionVC
        
        if fetchedResultsController.sections?.count == 0 {
            dvc.month = NSCalendar.currentCalendar().component(NSCalendarUnit.Month, fromDate: NSDate())
        } else {
            let sectionInfo = fetchedResultsController.sections![indexPath.row]
            let month = Int(sectionInfo.name)
            dvc.month = month
        }
        
        dvc.year = year
        
        self.navigationController!.pushViewController(dvc, animated: true) // 页面跳转
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAtIndex section: Int) -> UIEdgeInsets
    {
        let leftRightMagrin = (collectionViewWidth - itemWidth)/2
        return UIEdgeInsetsMake(0, leftRightMagrin, 0, leftRightMagrin);
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchedResultsController.sections?.count == 0 ? 1 : fetchedResultsController.sections!.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("iDailyCollectionViewCell", forIndexPath: indexPath) as! iDailyCollectionViewCell
        
        if fetchedResultsController.sections?.count == 0 {
            cell.labelText = "\(numToChineseWithUnit(NSCalendar.currentCalendar().component(NSCalendarUnit.Month, fromDate: NSDate()))) 月"
        } else {
            let sectionInfo = fetchedResultsController.sections![indexPath.row]
            let month = Int(sectionInfo.name)
            cell.labelText = "\(numToChineseWithUnit(month!)) 月"
        }
        
        return cell
    }
    
    func hideDiary() {
        self.navigationController?.popViewControllerAnimated(true)
    }

}
