//
//  PDStartPageVC.swift
//  iDaily
//
//  Created by P. Chu on 6/2/16.
//  Copyright © 2016 Poodar. All rights reserved.
//

import UIKit

class PDStartPageVC: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var PDHeadImgV: UIImageView!
    @IBOutlet weak var PDStartScrollPage: UIScrollView!
    
    let _pageCtrl: UIPageControl! = UIPageControl()
    var _currentPg: CGFloat = 0.0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addScrollView()
        self.addPageController()
        self.addCustomBtn()
    }
    
    func addPageController() {
        let size: CGSize = _pageCtrl.sizeForNumberOfPages(3)
        _pageCtrl.bounds = CGRectMake(0, 0, size.width, size.height)
        _pageCtrl.center = CGPointMake(screenRect.width/2, screenRect.height - 50)
        _pageCtrl.pageIndicatorTintColor = YAMABUKI
        
        _pageCtrl.numberOfPages = 3
        _currentPg = 0
        
        self.view.addSubview(_pageCtrl)
    }
    
    func addScrollView() {
        var oSize: CGSize = UIScreen.mainScreen().applicationFrame.size
        oSize.height -= 80
        
        PDStartScrollPage.delegate = self
        PDStartScrollPage.bounces = false
        PDStartScrollPage.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        PDStartScrollPage.contentSize = CGSizeMake(oSize.width * 3, oSize.height)
        PDStartScrollPage.setContentOffset(CGPointMake(0, 0), animated: true)
        PDStartScrollPage.showsVerticalScrollIndicator = false
        PDStartScrollPage.showsHorizontalScrollIndicator = false
        PDStartScrollPage.pagingEnabled = true
        
        var oImage: UIImageView = UIImageView(frame: CGRectMake(0, 0, oSize.width, oSize.height))
        oImage.contentMode = UIViewContentMode.ScaleAspectFill
        oImage.image = UIImage(named: "061")
        PDStartScrollPage.addSubview(oImage)
        
        oImage = UIImageView(frame: CGRectMake(oSize.width, 0,  oSize.width, oSize.height))
        oImage.contentMode =  UIViewContentMode.ScaleAspectFill
        oImage.image = UIImage(named: "062")
        PDStartScrollPage.addSubview(oImage)
        
        oImage = UIImageView(frame: CGRectMake(oSize.width * 2, 0,  oSize.width, oSize.height))
        oImage.contentMode =  UIViewContentMode.ScaleAspectFill
        oImage.image = UIImage(named: "063")
        PDStartScrollPage.addSubview(oImage)
        
        //注册与登录按钮，注意在多尺寸设备中，按钮的位置要与图表一致
        let loginBtn: UIButton = UIButton(type: UIButtonType.Custom)
        print("\(screenRect.height / 1.96)")
        
        loginBtn.frame = CGRectMake(oSize.width * 2, screenRect.height/1.96, screenRect.width, 50)
        loginBtn.backgroundColor = UIColor.clearColor()
        loginBtn.addTarget(self, action: #selector(PDStartPageVC.userLoginV), forControlEvents: UIControlEvents.TouchUpInside)
        PDStartScrollPage.addSubview(loginBtn)
        
        let regisBtn: UIButton = UIButton(type: UIButtonType.Custom)
        regisBtn.frame = CGRectMake(oSize.width * 2, screenRect.height/1.96 + 50, screenRect.width, 50)
        regisBtn.backgroundColor = UIColor.clearColor()
        regisBtn.addTarget(self, action: #selector(PDStartPageVC.userRegisV), forControlEvents: UIControlEvents.TouchUpInside)
        PDStartScrollPage.addSubview(regisBtn)
    }
    
    func userLoginV() {
        let dvc = self.storyboard?.instantiateViewControllerWithIdentifier("PDLoginVC") as! PDLoginVC
        self.presentViewController(dvc, animated: true, completion: nil)
    }
    
    func userRegisV() {
        let dvc = self.storyboard?.instantiateViewControllerWithIdentifier("PDLoginVC") as! PDLoginVC
        self.presentViewController(dvc, animated: true, completion: nil)
    }
    
    func addCustomBtn() {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let offset   = scrollView.contentOffset
        if offset.x > _currentPg * screenRect.width {
            _currentPg += CGFloat(1)
        } else {
            _currentPg -= CGFloat(1)
        }
        
        _pageCtrl.currentPage = Int(_currentPg)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
    }
    
    
}
