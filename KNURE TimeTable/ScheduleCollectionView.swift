//
//  ScheduleCollectionView.swift
//  KNURE TimeTable
//
//  Created by Shkil Artur on 2/25/16.
//  Copyright © 2016 Shkil Artur. All rights reserved.
//

import UIKit

class ScheduleCollectionView: UICollectionView {
    override func layoutSubviews() {
        super.layoutSubviews()
        // style:
        self.backgroundColor = UIColor(red: 239/255, green: 239/255, blue: 245/255, alpha: 1)
        let controller = dataSource as! CollectionScheduleViewController
        let location = CGPoint(x: contentOffset.x, y: 0)
        
        let headerLocation = CGPoint(x: 55, y: contentOffset.y)
        let size = controller.scale.frame.size
        controller.scale.frame = CGRect(origin: location, size: size)
        
        let dateScaleSize = controller.headerScale.frame.size
        controller.headerScale.frame = CGRect(origin: headerLocation, size: dateScaleSize)
        controller.headerScale.backgroundColor = UIColor(red: 239/255, green: 239/255, blue: 245/255, alpha: 1)
    }
}
