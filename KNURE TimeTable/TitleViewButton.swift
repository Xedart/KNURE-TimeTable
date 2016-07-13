//
//  TitleViewButton.swift
//  KNURE TimeTable
//
//  Created by Shkil Artur on 2/14/16.
//  Copyright © 2016 Shkil Artur. All rights reserved.
//

import UIKit
//import ChameleonFramework

class TitleViewButton: UIButton {

    init() {
        super.init(frame: CGRect(x: 300, y: 0, width: 300, height: 40))
        setTitleColor(AppData.appleButtonDefault, for: UIControlState())
        setTitleColor(FlatSkyBlue().withAlphaComponent(0.5), for: .highlighted)
        titleLabel?.font = UIFont.systemFont(ofSize: 20)
        setTitle(AppStrings.ChooseSchedule, for: UIControlState())
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

// 

class TitleViewLabel: UILabel {
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 40))
        font = UIFont.systemFont(ofSize: 20)
        textColor = UIColor.gray()
        text = AppStrings.Schedules
    }
    
    convenience init(title: String) {
        self.init()
        text = title
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
