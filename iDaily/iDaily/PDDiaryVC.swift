//
//  PDDiaryVC.swift
//  iDaily
//
//  Created by P. Chu on 6/1/16.
//  Copyright © 2016 Poodar. All rights reserved.
//

import UIKit

class PDDiaryVC: UIViewController, UIGestureRecognizerDelegate, UIWebViewDelegate, UIScrollViewDelegate
{
    var diary: PDDiary!
    
    var webView: UIWebView!
    
    var saveBtn: UIButton!
    var delBtn: UIButton!
    var editBtn: UIButton!
    
    var btnsView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        setUpUI()
        showBtns()
    }
    
    func setUpUI() {
        
        webView = UIWebView(frame: CGRectMake(0, 0, screenRect.width, screenRect.height))
        webView.scrollView.bounces = true;
        webView.scrollView.showsHorizontalScrollIndicator = false
        webView.scrollView.showsVerticalScrollIndicator = false
        
        webView.delegate = self
        webView.backgroundColor = UIColor.whiteColor()
        webView.scrollView.delegate = self
        webView.alpha = 0.0

        self.view.addSubview(webView)
        
        let mDoubleUpRecognizer = UITapGestureRecognizer(target: self, action: #selector(PDDiaryVC.hideDiary))
        mDoubleUpRecognizer.delegate = self
        mDoubleUpRecognizer.numberOfTapsRequired = 2
        self.webView.addGestureRecognizer(mDoubleUpRecognizer)
        
        let mTapUpRecognizer = UITapGestureRecognizer(target: self, action: #selector(PDDiaryVC.showBtns))
        mTapUpRecognizer.delegate = self
        mTapUpRecognizer.numberOfTapsRequired = 1
        self.webView.addGestureRecognizer(mTapUpRecognizer)
        
        mTapUpRecognizer.requireGestureRecognizerToFail(mDoubleUpRecognizer)
        
        
        //ADD BTNS
        btnsView = UIView(frame: CGRectMake(0, screenRect.height, screenRect.width, 80.0))
        btnsView.backgroundColor = UIColor.whiteColor()
        btnsView.alpha = 0.0
        
        let btnFontSize: CGFloat = 18.0
        
        saveBtn = btnWith(text: "Sv",
                          fontSize: btnFontSize,
                          width: 50.0,
                          normalImgNm: "Oval",
                          highlightedImgNm: "Oval_pressed")
        saveBtn.center = CGPointMake(btnsView.frame.width/2.0, btnsView.frame.height/2.0)
        saveBtn.addTarget(self,
                          action: #selector(PDDiaryVC.saveToList),
                          forControlEvents: UIControlEvents.TouchUpInside)
        btnsView.addSubview(saveBtn)
        
        editBtn = btnWith(text: "Ud",
                          fontSize: btnFontSize,
                          width: 50.0,
                          normalImgNm: "Oval",
                          highlightedImgNm: "Oval_pressed")
        editBtn.center = CGPointMake(saveBtn.center.x - 56.0, saveBtn.center.y)
        editBtn.addTarget(self,
                          action:#selector(PDDiaryVC.editDiary),
                          forControlEvents: UIControlEvents.TouchUpInside)
        btnsView.addSubview(editBtn)
        
        delBtn = btnWith(text: "Dl",
                         fontSize: btnFontSize,
                         width: 50.0,
                         normalImgNm: "Oval",
                         highlightedImgNm: "Oval_pressed")
        delBtn.center = CGPointMake(saveBtn.center.x + 56.0, saveBtn.center.y)
        delBtn.addTarget(self,
                         action:#selector(PDDiaryVC.deleteThisDiary),
                         forControlEvents: UIControlEvents.TouchUpInside)
        btnsView.addSubview(delBtn)
        
        self.view.addSubview(btnsView)
        
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(PDDiaryVC.reloadWebView),
                                                         name: "DiaryChangeFont",
                                                         object: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        reloadWebView()
    }
    
    //载入网页模板
    func reloadWebView() {
        let mainHTML = NSBundle.mainBundle().URLForResource("template", withExtension:"html")
        var contents: NSString = ""
        
        do {
            //获取网页内容
            contents = try NSString(contentsOfFile: mainHTML!.path!, encoding: NSUTF8StringEncoding)
        } catch let error as NSError {
            print(error)
        }
        
        //生成年、月、日的整数类型
        let year = NSCalendar.currentCalendar().component(NSCalendarUnit.Year, fromDate: diary.create_date)
        let month = NSCalendar.currentCalendar().component(NSCalendarUnit.Month, fromDate: diary.create_date)
        let day = NSCalendar.currentCalendar().component(NSCalendarUnit.Day, fromDate: diary.create_date)
        //合并，生成时间戳
        let timeString = "\(numToChinese(year))年 \(numToChineseWithUnit(month))月 \(numToChineseWithUnit(day))日"
        
        //将模板中的timeString替换为指定diary的实际内容
        contents = contents.stringByReplacingOccurrencesOfString("#timeString#", withString: timeString)
        
        //WebView method
        //先将日记内容转换为html的语法格式
        let newDiaryString = diary.content.stringByReplacingOccurrencesOfString("\n", withString: "<br>", options: NSStringCompareOptions.LiteralSearch, range: nil)
        //将模板中的newDiaryString替换为指定diary的实际内容
        contents = contents.stringByReplacingOccurrencesOfString("#newDiaryString#", withString: newDiaryString)
        
        
        //更新网页中的对应元素
        var title = ""
        var contentWidthOffset = 140
        var contentMargin:CGFloat = 10
        
        if let titleStr = diary?.title {
            let parsedTime = "\(numToChineseWithUnit(NSCalendar.currentCalendar().component(NSCalendarUnit.Day, fromDate: diary.create_date))) 日"
            if titleStr != parsedTime {
                title = titleStr
                contentWidthOffset = 205
                contentMargin = 10
                title = "<div class='title'>\(title)</div>"
            }
        }
        
        contents = contents.stringByReplacingOccurrencesOfString("#contentMargin#", withString: "\(contentMargin)")
        contents = contents.stringByReplacingOccurrencesOfString("#title#", withString: title)
        
        let minWidth = self.view.frame.size.width - CGFloat(contentWidthOffset)
        contents = contents.stringByReplacingOccurrencesOfString("#minWidth#", withString: "\(minWidth)")
        
        let fontStr = defaultFontName
        contents = contents.stringByReplacingOccurrencesOfString("#fontStr#", withString: fontStr)
        
        let titleMarginRight:CGFloat = 15
        contents = contents.stringByReplacingOccurrencesOfString("#titleMarginRight#", withString: "\(titleMarginRight)")
        
        if let location = diary.location {
            contents = contents.stringByReplacingOccurrencesOfString("#location#", withString: location)
        } else {
            contents = contents.stringByReplacingOccurrencesOfString("#location#", withString: "")
        }
        
        //显示网页内容
        webView.loadHTMLString(contents as String, baseURL: nil)
    }
    
    func showBtns() {
        if btnsView.alpha == 0.0 {
            UIView.animateWithDuration(0.2,
                                       delay: 0,
                                       options: UIViewAnimationOptions.CurveEaseInOut,
                                       animations:
                {
                    self.btnsView.center = CGPointMake(self.btnsView.center.x, screenRect.height - self.btnsView.frame.size.height/2.0)
                    self.btnsView.alpha = 1.0
                }, completion: nil)
        } else {
            UIView.animateWithDuration(0.2,
                                       delay: 0,
                                       options: UIViewAnimationOptions.CurveEaseInOut,
                                       animations:
                {
                    self.btnsView.center = CGPointMake(self.btnsView.center.x, screenRect.height + self.btnsView.frame.size.height/2.0)
                    self.btnsView.alpha = 0.0
                }, completion: nil)
        }
    }
    
    func editDiary() {
        let ID = "PDComposeVC"
        
        let composeVC = self.storyboard?.instantiateViewControllerWithIdentifier(ID) as! PDComposeVC
        
        if let diary = diary {
            print("Find \(diary.create_date)")
            composeVC.diary = diary
        }
        
        self.presentViewController(composeVC, animated: true, completion: nil)
    }
    
    //并借助系统的分享框架，让用户选择自己喜欢的处理方式
    func saveToList() {
        let offSet = self.webView.scrollView.contentOffset.x
        let image = webView.captureView()
        self.webView.scrollView.contentOffset.x = offSet
        
        var sharingItems = [AnyObject]()
        sharingItems.append(image)
        print("Do Share")
        
        //显示share的activityViewController
        let activityViewController = UIActivityViewController(activityItems: sharingItems, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.saveBtn
        self.presentViewController(activityViewController, animated: true, completion: nil)
    }
    
    //使用deleteObject（）方法删除当前正在查看的Diary，接着调用save（）方法保存操作，最后调用hideDairy（）返回上一层。
    func deleteThisDiary() {
        managedContext.deleteObject(diary)
        do {
            try managedContext.save()
        } catch _ {
        }
        hideDiary()
    }
    
    func hideDiary() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        UIView.animateWithDuration(1.0, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations:
            {
                self.webView.alpha = 1.0
            }, completion: nil)
        
        webView.scrollView.contentOffset = CGPointMake(webView.scrollView.contentSize.width - webView.frame.size.width, 0)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailByGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if (scrollView.contentOffset.y < -80){
            hideDiary()
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
}
