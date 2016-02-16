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
        super.init(frame: CGRect(x: 0, y: 0, width: 300, height: 40))
        
        setTitleColor(AppData.appleButtonDefault, forState: .Normal)
        setTitleColor(FlatSkyBlue().colorWithAlphaComponent(0.5), forState: .Highlighted)
        titleLabel?.font = UIFont.systemFontOfSize(20)
        setTitle("Выбрать расписание", forState: .Normal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

// 

class TitleViewLabel: UILabel {
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
        font = UIFont.systemFontOfSize(20)
        textColor = UIColor.grayColor()
        text = "Расписания"
    }
    
    convenience init(title: String) {
        self.init()
        text = title
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
