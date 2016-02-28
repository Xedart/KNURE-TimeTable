//
//  CollectionScheduleCell.swift
//  KNURE TimeTable
//
//  Created by Shkil Artur on 2/20/16.
//  Copyright © 2016 Shkil Artur. All rights reserved.
//

import UIKit

class CollectionScheduleCell: UICollectionViewCell {
    
    let mainTextView = UITextView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(mainTextView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.shouldRasterize = true;
        self.layer.rasterizationScale = UIScreen.mainScreen().scale
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        mainTextView.frame = self.bounds
        mainTextView.textAlignment = .Center
        mainTextView.font = UIFont.systemFontOfSize(17)
    }
    
    func configure(events: [Event], shedule: Shedule) {
        mainTextView.text = "\n\(shedule.subjects[events[0].subject_id]!.briefTitle)\n\(shedule.types[events[0].type]!.short_name) \(events[0].auditory)"
        mainTextView.backgroundColor = UIColor.lightGrayColor()
    }
}
