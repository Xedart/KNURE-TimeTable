//
//  TableSheduleHeader.swift
//  KNURE TimeTable
//
//  Created by Shkil Artur on 2/9/16.
//  Copyright © 2016 Shkil Artur. All rights reserved.
//

import UIKit

class TableSheduleHeader: UILabel {
    init(section: Int) {
        super.init(frame: CGRect())
        if section == 0 {
            text = "Сегодня"
        } else {
            text = "Завтра"
        }
        //
        backgroundColor = UIColor(red: 239/255, green: 239/255, blue: 245/255, alpha: 1)
        textAlignment = .Center
        font = UIFont.systemFontOfSize(20)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
