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
        let controller = dataSource as! CollectionScheduleViewController
        let location = CGPointMake(contentOffset.x, 0)
        let size = controller.scale.frame.size
        controller.scale.frame = CGRect(origin: location, size: size)
    }
}
