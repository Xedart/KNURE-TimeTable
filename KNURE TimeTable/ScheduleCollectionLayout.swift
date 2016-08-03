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
    let scaleOffset: CGFloat = 50
    var contentHeight = CGFloat() // need to left 40px extra space
    var contentWidth = CGFloat()
    var cache = [UICollectionViewLayoutAttributes]()
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func prepare() {
        
        // defining height:
        if UIDevice.current.userInterfaceIdiom == .pad {
            cellHeight = 90
            contentHeight = 890
        } else if UIDevice.current.userInterfaceIdiom == .phone {
            cellHeight = 72
            contentHeight = 634 // contentHeight = cellHeight * 8 + headerHeight + 8 ( 8 line view)
        }
        
        self.register(lineView.self, forDecorationViewOfKind: "lineView")
        // compute contentWidth:
        contentWidth = (CGFloat(collectionView!.numberOfSections) * cellWidth) + (CGFloat(collectionView!.numberOfSections) * (offset)) + cellWidth / 2
        self.computeLayoutAttributes()
        
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        for attributes in cache {
            if attributes.frame.intersects(rect) {
                layoutAttributes.append(attributes)
            }
        }
        return layoutAttributes
    }
    
    override func layoutAttributesForDecorationView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = UICollectionViewLayoutAttributes(forDecorationViewOfKind: "lineView", with: IndexPath(item: (indexPath as NSIndexPath).row, section: 0))
        attributes.frame = CGRect(x: 50, y: CGFloat((Int(cellHeight) + 1) * ((indexPath as NSIndexPath).row) + (51)), width: contentWidth, height: 0.6)
        return attributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let layoutAttributes = UICollectionViewLayoutAttributes()
        layoutAttributes.frame = CGRect(x: (cellWidth + offset) * CGFloat((indexPath as NSIndexPath).section) + scaleOffset, y: (cellHeight + offset) * CGFloat((indexPath as NSIndexPath).item) + (headerHeight + offset), width: cellWidth, height: cellHeight)
        return layoutAttributes
    }
    
    // MARK: - Methods:
    
    func computeLayoutAttributes() {
        cache.removeAll()
        computeDecorationAttributes()
        for section in 0..<collectionView!.numberOfSections {
            for item in 0..<collectionView!.numberOfItems(inSection: section) {
                let cellAttributes = UICollectionViewLayoutAttributes(forCellWith: IndexPath(item: item, section: section))
                cellAttributes.frame = CGRect(x: (cellWidth + offset) * CGFloat(section) + scaleOffset, y: (cellHeight + offset) * CGFloat(item) + (headerHeight + offset), width: cellWidth, height: cellHeight)
                cache.append(cellAttributes)
            }
        }
    }
    
    func computeDecorationAttributes() {
        if collectionView?.numberOfSections > 0 {
        for i in 1...8 {
            let attributes = UICollectionViewLayoutAttributes(forDecorationViewOfKind: "lineView", with: IndexPath(item: i, section: 0))
            attributes.frame = CGRect(x: 50, y: CGFloat((cellHeight + 1) * CGFloat(i) + (51)), width: contentWidth, height: 0.6)
            cache.append(attributes)
        }
      }
    }
}


















