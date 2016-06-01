//
//  iDailyCollectionViewCell.swift
//  iDaily
//
//  Created by P. Chu on 5/31/16.
//  Copyright © 2016 Poodar. All rights reserved.
//

import UIKit

/// 定义月视图和日视如下collection view中item/cell的样式
// Cell中含有一下元素：
// 1. textLabel： 文本标签
// 2. labeltext: 文本标签的内容， 当labelText被赋值时， 会自动更新其对应的textLabel， 并将其置于视图中的合适位置（x:父视图（cell）中间， y:父视图的Label的center.y + 28）
// 3. textInt: 文本对应的数字值
class iDailyCollectionViewCell: UICollectionViewCell {
    var textLabel: iDailyLabel!
    
    var labelText: String = "" {
        didSet {
            self.textLabel.updateText(labelText)
            self.textLabel.center = CGPointMake(itemWidth/2.0, self.textLabel.center.y + 28)
        }
    }
    
    //当从storyboard中加载该空间时，调用该方法做好所需准备
    //设置行高
    //设置textLabel的样式
    //将textLabel添加到父视图的subviews中
    override func awakeFromNib() {
        let lineHeight: CGFloat = 5.0
        
        self.textLabel = iDailyLabel(fontName: "WenYue-XinQingNianTi-NC-W8", labelText: labelText, fontSize: 16.0, lineHeight: lineHeight)
        
        self.addSubview(textLabel)
    }

}
