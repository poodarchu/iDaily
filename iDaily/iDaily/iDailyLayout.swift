//
//  iDailyLayout.swift
//  iDaily
//
//  Created by P. Chu on 5/31/16.
//  Copyright © 2016 Poodar. All rights reserved.
//

import UIKit
/// iDailyLayout
/**
 * 1. organizes items into a grid with optional header and footer views for each section.
 *    对每个section中的items， 将item组织到grid里面，并且可选页眉页脚
 * 2. items in the collection view flow from one row or column (depending on the **scrolling direction**) to the next, with each row comprising as many cells as will fit.
 *    对collectionView中的item，支持横向或纵向桂东
 * 3. Cells can be the same sizes or different sizes.Cell的大小可以相同也可以不同
 */

/// A flow layout works with the collection view’s delegate object to determine the size of items, headers, and footers in each section and grid. 
/// That delegate object must conform to the UICollectionViewDelegateFlowLayout protocol.


class iDailyLayout: UICollectionViewFlowLayout {
    /**
     Tells the layout object to update the current layout.
     */
    override func prepareLayout() {
        super.prepareLayout()
        let itemSize = CGSizeMake(itemWidth, itemHeight)
        self.itemSize = itemSize
        //设置最小行间距和列间距为0
        self.minimumInteritemSpacing = 0.0
        self.minimumLineSpacing = 0.0
    }
}
