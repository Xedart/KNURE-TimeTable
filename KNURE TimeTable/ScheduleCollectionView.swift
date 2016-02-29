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
        let location = CGPointMake(contentOffset.x, 0)
        let size = controller.scale.frame.size
        controller.scale.frame = CGRect(origin: location, size: size)
    }
}
