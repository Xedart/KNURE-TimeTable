//
//  ThirdPageView.swift
//  KNURE TimeTable
//
//  Created by Shkil Artur on 12/2/16.
//  Copyright © 2016 Shkil Artur. All rights reserved.
//

import UIKit

class ThirdPageView: UIView {

    var ringView = UIImageView()
    var calendarViwe = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init() {
        self.init(frame: CGRect())
        
        backgroundColor = UIColor.blue
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
