//
//  ViewController.swift
//  iDaily
//
//  Created by P. Chu on 5/31/16.
//  Copyright © 2016 Poodar. All rights reserved.
//

import UIKit
import CoreData

let itemHeight: CGFloat = 150.0    //cell的高度
let itemWidth: CGFloat = 60.0      //cell的宽度
let collectionViewWidth = itemWidth * 3 //每行显示3个cell

class PDHomeCollectionVC: UICollectionViewController {
    
    var diaries = [NSManagedObject]()
    
    var fetchedResultsController: NSFetchedResultsController!
    
    var yearsCount: Int = 1
    var sectionsCount: Int = 0
    
    

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
//        self.navigationController?.hidesBarsOnTap = true
        
        self.view.backgroundColor = UIColor.whiteColor()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Settings", style: .Plain, target: self, action: #selector(SSASideMenu.presentLeftMenuViewController))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "New", style: .Plain, target: self, action: #selector(SSASideMenu.presentRightMenuViewController))
        
        
        do {
            //NSFetchRequest: 描述查询需求
            //此处查询Core Data的PDDiary数据
            let fetchRequest = NSFetchRequest(entityName:"PDDiary")
            //按照创建时间的升序排列
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "create_date", ascending: true)]
            
            //NSFetchedResultsController：控制查询，控制查询结果
            //NSManagedObjectContext: 数据库上下文
            
            //初始化NSFetchedResultsController，并根据year分成不同的 section
            fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                  managedObjectContext: managedContext,
                                                                  sectionNameKeyPath: "year",
                                                                  cacheName: nil)
            //开始尝试查询
            try self.fetchedResultsController.performFetch()
            
            if (fetchedResultsController.fetchedObjects!.count == 0){
                print("Present empty year")   //没有查询到任何结果
            }else{
                
                //查询结果根据year分成不同的section，此处反过来根据section的数量来判断year的数量
                if let sectionsCount = fetchedResultsController.sections?.count {
                    //每年是一个section
                    yearsCount = sectionsCount
                    //fecthedObjects: [NSManagedObject] 表示查询结果，返回给NSFetchedResultsController
                    diaries = fetchedResultsController.fetchedObjects as! [NSManagedObject]
                    
                }else {
                    sectionsCount = 0
                    yearsCount = 1
                }
            }
            
        } catch let error as NSError {
            debugPrint(error)
        }
        
        /** 
         * 分组通过以上过程，已经由NSFetchedResultsController自动完成，接下来是在年，月界面正确显示相关内容
         */
        
        self.navigationController!.delegate = self
        
        let yearLayout = iDailyLayout()
        
        yearLayout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        self.collectionView?.setCollectionViewLayout(yearLayout, animated: false)
        self.collectionView!.frame = CGRect(x: 0, y: 0, width: collectionViewWidth, height: itemHeight + 44)
        //collectionView 在正中显示
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
        return yearsCount
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> HomeYearCollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("HomeYearCollectionViewCell", forIndexPath: indexPath) as! HomeYearCollectionViewCell
        
        //格式化日期
        var year = NSCalendar.currentCalendar().component(NSCalendarUnit.Year, fromDate: NSDate())
        if sectionsCount > 0 {
            if let sectionInfo = fetchedResultsController.sections![indexPath.row] as? NSFetchedResultsSectionInfo {
                print("Section info \(sectionInfo.name)")
                year = Int(sectionInfo.name)!
            }
        }
        
        cell.textInt = year
        cell.labelText = "\(numToChinese(cell.textInt)) 年"
        
        // Configure the cell
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAtIndex section: Int) -> UIEdgeInsets
    {
        
        let leftRightMagrin = (collectionViewWidth - itemWidth)/2
        return UIEdgeInsetsMake(0, leftRightMagrin, 0, leftRightMagrin)
    }
    
    
    //当在Home点击某一年的时候，跳转到MonthDayCollectionVC
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let identifier = "iDailyYearCollectionVC"
        
        let dvc = self.storyboard?.instantiateViewControllerWithIdentifier(identifier) as! YearCollectionVC
        
        let components = NSCalendar.currentCalendar().component(NSCalendarUnit.Year, fromDate: NSDate())
        var year = components
        if sectionsCount > 0 {
            if let sectionInfo = fetchedResultsController.sections![indexPath.row] as? NSFetchedResultsSectionInfo {
                print("Section info \(sectionInfo.name)")
                year = Int(sectionInfo.name)!
            }
        }
        
        //向将要跳转到的dvc传输year信息
        dvc.year = year
        
        //页面跳转
        self.navigationController!.pushViewController(dvc, animated: true)
    }
}

extension PDHomeCollectionVC: UINavigationControllerDelegate {
    func navigationController(navigationController: UINavigationController,
                              animationControllerForOperation operation: UINavigationControllerOperation,
                              fromViewController fromVC: UIViewController,
                              toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animator = iDailyAnimator()
        animator.operation = operation
        
        return animator
    }
}

