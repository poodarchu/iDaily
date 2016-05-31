//
//  iDailyCollectionViewCell.swift
//  iDaily
//
//  Created by P. Chu on 5/31/16.
//  Copyright © 2016 Poodar. All rights reserved.
//

import UIKit

class iDailyCollectionViewCell: UICollectionViewCell {
    var textLabel: iDailyLabel!
    
    var labelText: String = "" {
        didSet {
            self.textLabel.updateText(labelText)
            self.textLabel.center = CGPointMake(itemWidth/2.0, self.textLabel.center.y + 28)
        }
    }
    
    var textInt: Int = 0
    
    override func awakeFromNib() {
        let lineHeight: CGFloat = 5.0
        
        self.textLabel = iDailyLabel(fontName: "WenYue-XinQingNianTi-NC-W8", labelText: labelText, fontSize: 16.0, lineHeight: lineHeight)
        
        self.addSubview(textLabel)
    }

}
