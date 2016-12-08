//
//  FirstPageView.swift
//  KNURE TimeTable
//
//  Created by Shkil Artur on 11/26/16.
//  Copyright © 2016 Shkil Artur. All rights reserved.
//

import UIKit

class FirstPageView: UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init() {
        self.init(frame: CGRect())
        
        backgroundColor = UIColor.white
        image = UIImage(named: "LunchImage")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
