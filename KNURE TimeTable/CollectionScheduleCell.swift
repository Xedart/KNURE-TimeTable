//
//  CollectionScheduleCell.swift
//  KNURE TimeTable
//
//  Created by Shkil Artur on 2/20/16.
//  Copyright © 2016 Shkil Artur. All rights reserved.
//

import UIKit

class CollectionScheduleCell: UICollectionViewCell {
    
    var textView = UITextView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        textView.frame = self.bounds
        textView.backgroundColor = UIColor.lightGrayColor()
        self.addSubview(textView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(eventTitle: String, eventType: String, auditory: String) {
        textView.text = "\n\(eventTitle)\n\(eventType) \(auditory)"
    }
}
