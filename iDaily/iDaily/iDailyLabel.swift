//
//  iDailyLabel.swift
//  iDaily
//
//  Created by P. Chu on 5/31/16.
//  Copyright © 2016 Poodar. All rights reserved.
//

import UIKit

/// iDailyLabel的主要功能：
/**
 * 1. 继承自UILabel，封装为接收参数：字体名，文字内容，字体大小，行高
 * 2. 根据接收到的参数，将label设置为每行一个字的“竖排显示”的风格
 * 3. 当label的文字内容发生变化时，iDailyLabel可以根据文字内容动态的改变自己的大小
 */
class iDailyLabel: UILabel {
    
    var textAttributes: [String : AnyObject]!
    
    convenience init(fontName: String,
                     labelText: String,
                     fontSize: CGFloat,
                     lineHeight: CGFloat) {
        
        self.init(frame: CGRectZero)
        
        //根据fontName和fontSize新建UIFont！对象
        let font = UIFont(name: fontName, size: fontSize) as UIFont!
        
        //设置段落style
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineHeight
        
        //设置text的字体和段落风格属性，添加到text的属性字典中
        textAttributes = [NSFontAttributeName: font, NSParagraphStyleAttributeName: paragraphStyle]
        
        //根据labelText计算出竖排显示时的labelSize:CGSize.然后用计算出的labelSize更新UILabel的frame
        let labelSize = sizeHeightWithText(labelText, fontSize: fontSize, textAttributes: textAttributes)
        self.frame = CGRectMake(0, 0, labelSize.width, labelSize.height)
        
        //The styled text displayed by the label.
        self.attributedText = NSAttributedString(string: labelText, attributes: textAttributes)
        
        self.lineBreakMode = NSLineBreakMode.ByCharWrapping
        self.numberOfLines = 0
    }
    
    func resizeLabelWithFontName(fontName: String,
                                 labelText: String,
                                 fontSize: CGFloat,
                                 lineHeight: CGFloat ) {
        
        let font = UIFont(name: fontName, size: fontSize) as UIFont!
        
        let paragraphStyle = NSMutableParagraphStyle()
        //设置行间距和行高相同
        paragraphStyle.lineSpacing = lineHeight
        
        textAttributes = [NSFontAttributeName: font,
                          NSForegroundColorAttributeName: YAMABUKI,
                          NSParagraphStyleAttributeName: paragraphStyle]
        let labelSize = sizeHeightWithText(labelText, fontSize: fontSize, textAttributes: textAttributes)
        
        self.frame = CGRectMake(0, 0, labelSize.width, labelSize.height)
        self.attributedText = NSAttributedString(string: labelText, attributes: textAttributes)
        self.lineBreakMode = NSLineBreakMode.ByCharWrapping
        self.numberOfLines = 0
    }
    
    func updateText(labelText: String) {
        
        let labelSize = sizeHeightWithText(labelText, fontSize: self.font.pointSize, textAttributes: textAttributes)
        
        self.frame = CGRectMake(0, 0, labelSize.width, labelSize.height)
        self.attributedText = NSAttributedString(string: labelText, attributes: textAttributes)
    }
    
    func updateLabelColor(color: UIColor) {
        
        textAttributes[NSForegroundColorAttributeName] = color
        
        self.attributedText = NSAttributedString(string: self.attributedText!.string, attributes: textAttributes)
    }
}

/**
 计算竖排显示指定文字的UILabel的bounding rect
 
 - parameter labelText:      文本内容：NSString
 - parameter fontSize:       字体大小：CGFloat
 - parameter textAttributes: e.g. [NSFontAttributeName: fontName]
 
 - returns: 返回用所给的options和显示属性绘制的对象的bounding rect
 */
func sizeHeightWithText(labelText: NSString,
                        fontSize: CGFloat,
                        textAttributes: [String: AnyObject]) -> CGRect {
    
    //func boundingRectWithSize(size: CGSize, options: NSStringDrawingOptions, attributes: [String : AnyObject]?, context: NSStringDrawingContext?) -> CGRect
    /**
     *  计算并返回用所给的options和显示属性绘制的对象的bounding rect
     *
     *  @param size         the size of the rectangle to draw in
     *  @param options      string drawing options
     *  @param attributes   a dictionary of text attributes to be assigned to a string
     *  @param context      the string drawing context to use for the receiver
     *
     *  @return             用所给的options和显示属性绘制的对象的bounding rect
     */
    return labelText.boundingRectWithSize(CGSizeMake(fontSize, 480),
                                          options: NSStringDrawingOptions.UsesLineFragmentOrigin,
                                          attributes: textAttributes,
                                          context: nil)
}
