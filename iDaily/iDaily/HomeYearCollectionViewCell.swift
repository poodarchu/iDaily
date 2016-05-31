//
//  HomeYearCollectionViewCell.swift
//  iDaily
//
//  Created by P. Chu on 5/31/16.
//  Copyright © 2016 Poodar. All rights reserved.
//

import UIKit

class HomeYearCollectionViewCell: UICollectionViewCell {
    
    var textLabel: iDailyLabel!
    var textInt: Int = 0
    var labelText: String = "" {
        didSet {
            self.textLabel.updateText(labelText)
        }
    }
    
    override func awakeFromNib() {
        self.textLabel = iDailyLabel(
            fontName: "WenYue-XinQingNianTi-NC-W8",
//            fontName: "Wyue-GutiFangsong-NC",
            labelText: labelText,
            fontSize: 16.0,
            lineHeight: 5.0)
        self.addSubview(textLabel)
    }
    
    override func layoutSubviews() {
//        super.layoutSubviews()
        self.textLabel.center = CGPointMake(itemWidth/2.0, 150.0/2.0)
    }
}
