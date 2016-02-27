//
//  CollectionHeader.swift
//  KNURE TimeTable
//
//  Created by Shkil Artur on 2/20/16.
//  Copyright © 2016 Shkil Artur. All rights reserved.
//

import UIKit

class CollectionHeader: UICollectionReusableView {
    
    var dateLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        dateLabel = UILabel(frame: self.bounds)
        dateLabel.textAlignment = .Center
        self.addSubview(dateLabel)
    }
    
    func configure(dateStr: String) {
        dateLabel.text = dateStr
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}


class CollectionDecorationView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.whiteColor()
    }
    
    func configure(height: CGFloat) {
        for i in 0 ..< 8 {
            let timeLabel = UITextView(frame: CGRect(x: 0, y: CGFloat((100 + 5) * (i) + (50 + 5)), width: 55, height: 100))
            timeLabel.text = "\n\(AppData.pairsStartTime[i+1]!)\n\n\(AppData.pairsEndTime[i+1]!)"
            timeLabel.font = UIFont.systemFontOfSize(15)
            timeLabel.editable = false
            timeLabel.textAlignment = .Center
            self.addSubview(timeLabel)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}









