//
//  ScheduleCollectionLayout.swift
//  KNURE TimeTable
//
//  Created by Shkil Artur on 2/20/16.
//  Copyright © 2016 Shkil Artur. All rights reserved.
//

import UIKit

class ScheduleCollectionLayout: UICollectionViewLayout {
    
    // MARK: - properties:
    
    let cellWidth: CGFloat = 100
    let cellHeight: CGFloat = 100
    let headerHeight: CGFloat = 50
    let offset: CGFloat = 5
    let scaleOffset: CGFloat = 55
    let contentHeight: CGFloat = 890
    var contentWidth = CGFloat()
    var cache = [UICollectionViewLayoutAttributes]()
    
    override func prepareLayout() {
        // compute contentWidth:
        contentWidth = (CGFloat(collectionView!.numberOfSections()) * cellWidth) + (CGFloat(collectionView!.numberOfSections()) * offset)
        self.computeLayoutAttributes()
    }
    
    override func collectionViewContentSize() -> CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        for attributes in cache {
            if CGRectIntersectsRect(attributes.frame, rect) {
                layoutAttributes.append(attributes)
            }
        }
        return layoutAttributes
    }
    
    // MARK: - Methods:
    
    func computeLayoutAttributes() {
        cache.removeAll()
        for section in 0..<collectionView!.numberOfSections() {
            // step 1) - setting collectionView header attributes:
            let headerAttributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: "Header", withIndexPath: NSIndexPath(forItem: 0, inSection: section))
            headerAttributes.frame = CGRect(x: (cellWidth + offset) * CGFloat(section) + scaleOffset, y: 0, width: cellWidth, height: headerHeight)
            cache.append(headerAttributes)
            // step 2) - setting collectionView cells attributes:
            for item in 0..<collectionView!.numberOfItemsInSection(section) {
                let cellAttributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: NSIndexPath(forItem: item, inSection: section))
                cellAttributes.frame = CGRect(x: (cellWidth + offset) * CGFloat(section) + scaleOffset, y: (cellHeight + offset) * CGFloat(item) + (headerHeight + offset), width: cellWidth, height: 100)
                cache.append(cellAttributes)
            }
        }
    }
}


















