//
//  CollectionScheduleMultiCell.swift
//  KNURE TimeTable
//
//  Created by Shkil Artur on 2/28/16.
//  Copyright © 2016 Shkil Artur. All rights reserved.
//

import UIKit

class CollectionScheduleMultiCell: UICollectionViewCell {
    
    let scrollView = UIScrollView()
    let mainTextView = UITextView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(scrollView)
        scrollView.addSubview(mainTextView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        scrollView.frame = self.bounds
        mainTextView.frame = self.bounds
        mainTextView.textAlignment = .Center
        mainTextView.font = UIFont.systemFontOfSize(17)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.shouldRasterize = true;
        self.layer.rasterizationScale = UIScreen.mainScreen().scale
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(events: [Event], shedule: Shedule) {
        mainTextView.text = "\n\(shedule.subjects[events[0].subject_id]!.briefTitle)\n\(shedule.types[events[0].type]!.short_name) \(events[0].auditory)"
        mainTextView.backgroundColor = UIColor.lightGrayColor()
        scrollView.contentSize.width = (self.bounds.width + 5) * CGFloat(events.count)
        for i in 1..<events.count - 1 {
            let textView = UITextView(frame: CGRect(x: 105 * CGFloat(i), y: 0, width: self.bounds.width, height: self.bounds.height))
            textView.textAlignment = .Center
            textView.text = "\n\(shedule.subjects[events[i].subject_id]!.briefTitle)\n\(shedule.types[events[i].type]!.short_name) \(events[i].auditory)"
            textView.backgroundColor = UIColor.lightGrayColor() // *
            scrollView.addSubview(textView)
        }
    }
}
