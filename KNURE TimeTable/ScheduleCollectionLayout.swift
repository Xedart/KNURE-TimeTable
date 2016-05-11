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
    
    let cellWidth: CGFloat = 125
    var cellHeight: CGFloat!
    let headerHeight: CGFloat = 50
    let offset: CGFloat = 1
    let scaleOffset: CGFloat = 55
    var contentHeight: CGFloat! // need to left 40px extra space
    var contentWidth = CGFloat()
    var cache = [UICollectionViewLayoutAttributes]()
    
    override func prepareLayout() {
        
        // defining height:
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            cellHeight = 100
            contentHeight = 890
        } else if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            cellHeight = 70
            contentHeight = 610
        }
        
        self.registerClass(lineView.self, forDecorationViewOfKind: "lineView")
        // compute contentWidth:
        contentWidth = (CGFloat(collectionView!.numberOfSections()) * cellWidth) + (CGFloat(collectionView!.numberOfSections()) * (offset)) + cellWidth / 2
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
    
    override func layoutAttributesForDecorationViewOfKind(elementKind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = UICollectionViewLayoutAttributes(forDecorationViewOfKind: "lineView", withIndexPath: NSIndexPath(forItem: indexPath.row, inSection: 0))
        attributes.frame = CGRect(x: 50, y: CGFloat((Int(cellHeight) + 1) * (indexPath.row) + (51)), width: contentWidth, height: 0.6)
        return attributes
    }
    
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        let layoutAttributes = UICollectionViewLayoutAttributes()
        layoutAttributes.frame = CGRect(x: (cellWidth + offset) * CGFloat(indexPath.section) + scaleOffset, y: (cellHeight + offset) * CGFloat(indexPath.item) + (headerHeight + offset), width: cellWidth, height: cellHeight)
        return layoutAttributes
    }
    
    // MARK: - Methods:
    
    func computeLayoutAttributes() {
        cache.removeAll()
        computeDecorationAttributes()
        for section in 0..<collectionView!.numberOfSections() {
            for item in 0..<collectionView!.numberOfItemsInSection(section) {
                let cellAttributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: NSIndexPath(forItem: item, inSection: section))
                cellAttributes.frame = CGRect(x: (cellWidth + offset) * CGFloat(section) + scaleOffset, y: (cellHeight + offset) * CGFloat(item) + (headerHeight + offset), width: cellWidth, height: cellHeight)
                cache.append(cellAttributes)
            }
        }
    }
    
    func computeDecorationAttributes() {
        if collectionView?.numberOfSections() > 0 {
        for i in 1...8 {
            let attributes = UICollectionViewLayoutAttributes(forDecorationViewOfKind: "lineView", withIndexPath: NSIndexPath(forItem: i, inSection: 0))
            attributes.frame = CGRect(x: 50, y: CGFloat((cellHeight + 1) * CGFloat(i) + (51)), width: contentWidth, height: 0.6)
            cache.append(attributes)
        }
      }
    }
}


















