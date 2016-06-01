//
//  PDHelper.swift
//  iDaily
//
//  Created by P. Chu on 5/31/16.
//  Copyright © 2016 Poodar. All rights reserved.
//

import UIKit

/// 工具函数，定义了：
/**
 * 1. 屏幕尺寸
 * 2. 选定字体颜色除黑丝之外使用 日本传统色“山吹”
 * 3. 自定义按钮
 * 4. 数字转汉字的工具函数
 */

let defaultFontName = "WenYue-XinQingNianTi-NC-W8"

let screenRect = UIScreen.mainScreen().bounds

let YAMABUKI = UIColor(red: 255.0/255.0, green: 177.0/255.0, blue: 27.0/255.0, alpha: 1.0)

let DiaryFont = UIFont(name: defaultFontName, size: 18) as UIFont!
let DiaryLocationFont = UIFont(name: defaultFontName, size: 16) as UIFont!
let DiaryTitleFont = UIFont(name: defaultFontName, size: 18) as UIFont!

let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
let managedContext = appDelegate.managedObjectContext



extension PDDiary {
    func updateTimeWithDate(date: NSDate){
        self.create_date = date
        self.year = NSCalendar.currentCalendar().component(NSCalendarUnit.Year, fromDate: date)
        self.month = NSCalendar.currentCalendar().component(NSCalendarUnit.Month, fromDate: date)
    }
}

extension UIWebView {
    
    func captureView() -> UIImage{
        // tempframe to reset view size after image was created
        let tmpFrame = self.frame
        // set new Frame
        var aFrame = self.frame
        aFrame.size.width = self.sizeThatFits(UIScreen.mainScreen().bounds.size).width
        self.frame = aFrame
        // do image magic
        UIGraphicsBeginImageContextWithOptions(self.sizeThatFits(UIScreen.mainScreen().bounds.size), false, UIScreen.mainScreen().scale)
        let resizedContext = UIGraphicsGetCurrentContext()
        self.layer.renderInContext(resizedContext!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        // reset Frame of view to origin
        self.frame = tmpFrame
        
        return image
    }
}


//传输参数，返回自定义的btn，自定义的范围包括字体，字体大小，颜色，文字内容，背景图片
func btnWith(text text:        String,
             fontSize:         CGFloat,
             width:            CGFloat,
             normalImgNm:      String,
             highlightedImgNm: String) -> UIButton
{
    //自定义btn控件
    let btn = UIButton(type: UIButtonType.Custom)
    //设置btn的frame
    btn.frame = CGRectMake(0, 0, width, width)
    
    let font = UIFont(name: "WenYue-XinQingNianTi-NC-W8", size: fontSize) as UIFont!
    let textAttributes: [String: AnyObject] = [NSFontAttributeName: font, NSForegroundColorAttributeName: UIColor.whiteColor()]
    let attributeText = NSAttributedString(string: text,
                                           attributes: textAttributes)
    
    btn.setAttributedTitle(attributeText, forState: UIControlState.Normal)
    btn.setBackgroundImage(UIImage(named: normalImgNm), forState: UIControlState.Normal)
    btn.setBackgroundImage(UIImage(named: highlightedImgNm), forState: UIControlState.Highlighted)
    
    return btn
}

func numToChinese(num: Int) -> String {
    let numArr = Array(String(num).characters)
    var finalStr = ""
    for singleNum in numArr {
        let string = singleNumToChinese(singleNum)
        finalStr = "\(finalStr)\(string)"
    }
    
    return finalStr
}

func numToChineseWithUnit(num: Int) -> String {
    let numArr = Array(String(num).characters)
    var units = unitParser(numArr.count)
    var finalStr = ""
    
    for(index, singleNum) in numArr.enumerate() {
        let string = singleNumToChinese(singleNum)
        if(!(string == "零" && (index+1) == numArr.count)) {
            finalStr = "\(finalStr)\(string)\(units[index])"
        }
    }
    
    return finalStr
}

func unitParser(unit: Int) -> [String] {
    var units = Array(["万", "千", "百", "十", ""].reverse())
    let parsedUnits = units[0..<(unit)].reverse()
    let slicedUnits: ArraySlice<String> = ArraySlice(parsedUnits)
    let final: [String] = Array(slicedUnits)
    
    return final
}

func singleNumToChinese(number:Character) -> String {
    switch number {
    case "0":
        return "零"
    case "1":
        return "一"
    case "2":
        return "二"
    case "3":
        return "三"
    case "4":
        return "四"
    case "5":
        return "五"
    case "6":
        return "六"
    case "7":
        return "七"
    case "8":
        return "八"
    case "9":
        return "九"
    default:
        return ""
    }
}

