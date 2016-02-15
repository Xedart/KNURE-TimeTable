//
//  TitleViewButton.swift
//  KNURE TimeTable
//
//  Created by Shkil Artur on 2/14/16.
//  Copyright © 2016 Shkil Artur. All rights reserved.
//

import UIKit

class TitleViewButton: UIButton {

    init() {
        super.init(frame: CGRect())
        
        setTitleColor(FlatSkyBlueDark(), forState: .Normal)
        setTitleColor(FlatSkyBlue(), forState: .Highlighted)
        titleLabel?.font = UIFont.systemFontOfSize(20)
        setTitle("Выбрать расписание", forState: .Normal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
