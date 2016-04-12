//
//  CollectionScheduleEmptyCell.swift
//  KNURE TimeTable
//
//  Created by Shkil Artur on 2/28/16.
//  Copyright © 2016 Shkil Artur. All rights reserved.
//.

import UIKit

class CollectionScheduleEmptyCell: CollectionScheduleCellParent {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func configure(events: [Event], shedule: Shedule) {}
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
